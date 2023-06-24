import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:manhwa_alert/layers/notifications/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService extends ChangeNotifier {
  final ValueNotifier<int> unseenNotificationCount = ValueNotifier(0);
  final ValueNotifier<List<NotificationModel>> notifications =
      ValueNotifier([]);
  final ValueNotifier<Map<String, String>> subscribedTopics = ValueNotifier({});
  Map<String, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>
      listeners = {};
  ValueNotifier<String> latestNotificationTimestamp =
      ValueNotifier(DateTime.now().toIso8601String());
  DocumentSnapshot? lastDocument;

  final FirebaseFirestore _db;
  final SharedPreferences _sharedPreferences;

  NotificationService(this._sharedPreferences, this._db) {
    loadCachedNotifications();
    latestNotificationTimestamp.value = loadLatestNotificationTimestamp();
  }

  Future<void> saveNotificationCount() async {
    await _sharedPreferences.setInt(
        'unseenNotificationCount', unseenNotificationCount.value);
  }

  void loadNotificationCount() {
    unseenNotificationCount.value =
        _sharedPreferences.getInt('unseenNotificationCount') ?? 0;
  }

  void incrementNotificationCount() {
    unseenNotificationCount.value++;
  }

  void resetNotificationCount() {
    unseenNotificationCount.value = 0;
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    final value = _sharedPreferences.getInt('unseenNotificationCount') ?? 0;
    await _sharedPreferences.setInt('unseenNotificationCount', value + 1);
    await _sharedPreferences.reload();
    print(_sharedPreferences.getInt('unseenNotificationCount'));
    loadNotificationCount();
  }

  void listenForNewNotifications() {
    final Map<String, String> localTopics = subscribedTopics.value;

    for (final key in localTopics.keys) {
      String value = localTopics[key]!;

      if (listeners.containsKey(key)) {
        listeners[key]!.cancel();
      }

      listeners[key] = _db
          .collection("notifications")
          .doc(key)
          .collection("notifications")
          .where('notification_timestamp',
              isGreaterThan: latestNotificationTimestamp.value)
          .snapshots()
          .listen((querySnapshot) async {
        List<NotificationModel> newNotifications = [];

        for (var docSnapshot in querySnapshot.docs) {
          newNotifications.add(NotificationModel.fromMap(docSnapshot.data()));
        }
        addNotifications(newNotifications);
        await saveNotificationsToCache();
        if (newNotifications.isNotEmpty) {
          DateTime highestDate = newNotifications
              .reduce((curr, next) =>
                  curr.notificationTimestamp.isAfter(next.notificationTimestamp)
                      ? curr
                      : next)
              .notificationTimestamp;

          latestNotificationTimestamp.value = highestDate.toIso8601String();

          await saveLatestNotificationTimestamp(latestNotificationTimestamp);
          notifyListeners();

          listenForNewNotifications();
        } else {
          await saveLatestNotificationTimestamp(latestNotificationTimestamp);
        }
      });
    }
  }

  Future<void> removeAListener(String topic) async {
    await listeners[topic]!.cancel();
    listeners.removeWhere((key, value) => key == topic);

    listeners.remove(topic);
  }

  void addTopicSnapshotListener(key) {
    if (listeners.containsKey(key)) {
      return;
    }

    if (subscribedTopics.value[key] == null ||
        subscribedTopics.value[key] == '') {
      return;
    }

    listeners[key] = _db
        .collection("notifications")
        .doc(key)
        .collection("notifications")
        .where('notification_timestamp',
            isGreaterThan: subscribedTopics.value[key])
        .snapshots()
        .listen((querySnapshot) async {
      List<NotificationModel> newNotifications = [];

      for (var docSnapshot in querySnapshot.docs) {
        newNotifications.add(NotificationModel.fromMap(docSnapshot.data()));
      }

      addNotifications(newNotifications);
      await saveNotificationsToCache();
      if (newNotifications.isNotEmpty) {
        DateTime highestDate = newNotifications
            .reduce((curr, next) =>
                curr.notificationTimestamp.isAfter(next.notificationTimestamp)
                    ? curr
                    : next)
            .notificationTimestamp;

        latestNotificationTimestamp.value = highestDate.toIso8601String();
        await saveLatestNotificationTimestamp(latestNotificationTimestamp);
        notifyListeners();
        listenForNewNotifications();
      } else {
        await saveLatestNotificationTimestamp(latestNotificationTimestamp);
      }
    });
  }

  void addNotifications(List<NotificationModel> newNotifications) {
    List<NotificationModel> notificationsHolder =
        List.from(notifications.value);
    notificationsHolder.addAll(newNotifications);
    notifications.value = notificationsHolder;
  }

  Future<void> saveNotificationsToCache() async {
    List<String> cachedNotifications = notifications.value
        .map<String>((notification) => json.encode(notification.toMap()))
        .toList();

    await _sharedPreferences.setStringList(
      'cached_notifications',
      cachedNotifications,
    );
  }

  void loadCachedNotifications() {
    List<String> cachedNotifications =
        _sharedPreferences.getStringList('cached_notifications') ?? [];
    final List<NotificationModel> notificationsHolder = [];
    cachedNotifications.forEach((notification) {
      notificationsHolder.add(NotificationModel.fromJson(notification));
    });
    notifications.value = notificationsHolder;
  }

  Future<String> saveLatestNotificationTimestamp(timestamp) async {
    final String timestamp = DateTime.now().toIso8601String();
    await _sharedPreferences.setString(
        'latest_notification_timestamp', timestamp);
    return timestamp;
  }

  Future<void> markAsRead(String chapterUrl) async {
    int targetIndex = notifications.value
        .indexWhere((notification) => notification.chapterUrl == chapterUrl);

    if (targetIndex != -1) {
      notifications.value[targetIndex].isRead = true;
      notifications.notifyListeners();
    }
  }

  String loadLatestNotificationTimestamp() {
    String timestamp = '';
    _sharedPreferences.getKeys().forEach((key) {
      if (key.startsWith('topic_')) {
        timestamp = _sharedPreferences.getString(key)!;
      }
    });
    return _sharedPreferences.getString('latest_notification_timestamp') ??
        (timestamp != '' ? timestamp : DateTime.now().toIso8601String());
  }

  Future<void> clearAllNotifications() async {
    await _sharedPreferences.remove('cached_notifications');
    await _sharedPreferences.remove('latest_notification_timestamp');
    _sharedPreferences.getKeys().forEach((key) {
      if (key.startsWith('topic_')) {
        String topic = key.substring('topic_'.length);
        _sharedPreferences.remove(key);
        FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      }
    });
    listeners.forEach((key, value) {
      listeners[key]!.cancel();
    });
    notifications.value = [];
    latestNotificationTimestamp.value = DateTime.now().toIso8601String();
    notifyListeners();
  }

  void getLocalSubscribedTopics() {
    final Map<String, String> localTopics = {};

    _sharedPreferences.getKeys().forEach((key) {
      if (key.startsWith('topic_')) {
        String topic = key.substring('topic_'.length);
        String timestamp = _sharedPreferences.getString(key)!;
        localTopics[topic] = timestamp;
      }
    });

    subscribedTopics.value = localTopics;
  }

  Future<void> saveSubscribedTopicLocal(String topic) async {
    final String formattedTopic = 'topic_$topic';
    final String timestamp = DateTime.now().toIso8601String();
    await _sharedPreferences.setString(formattedTopic, timestamp);
    subscribedTopics.value[topic] = timestamp;
  }

  Future<void> removeSubscribedTopicLocal(String topic) async {
    final String formattedTopic = 'topic_$topic';
    await _sharedPreferences.remove(formattedTopic);
    subscribedTopics.value.remove(topic);
    notifyListeners();
  }
}
