import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:manhwa_alert/layers/notifications/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService extends ChangeNotifier {
  final ValueNotifier<List<NotificationModel>> notifications =
      ValueNotifier([]);
  final ValueNotifier<Map<String, String>> subscribedTopics = ValueNotifier({});
  Map<String, StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>
      listeners = {};
  String latestNotificationTimestamp = '';
  DocumentSnapshot? lastDocument;

  final FirebaseFirestore _db;
  final SharedPreferences _sharedPreferences;

  NotificationService(this._sharedPreferences, this._db) {
    loadCachedNotifications();
    latestNotificationTimestamp = loadLatestNotificationTimestamp();
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
              isGreaterThan: latestNotificationTimestamp)
          .snapshots()
          .listen((querySnapshot) async {
        List<NotificationModel> newNotifications = [];

        for (var docSnapshot in querySnapshot.docs) {
          newNotifications.add(NotificationModel.fromMap(docSnapshot.data()));
          print(
              'listenForNewNotifications: ${docSnapshot.id} => ${docSnapshot.data()}');
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

          print("Highest date in the list: $highestDate");
          latestNotificationTimestamp = highestDate.toIso8601String();
          await saveLatestNotificationTimestamp(latestNotificationTimestamp);

          // Call listenForNewNotifications() again to set up a new listener with the updated query
          listenForNewNotifications();
        } else {
          await saveLatestNotificationTimestamp(latestNotificationTimestamp);
        }
      });
    }
  }

  addNewListener(key) {
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
        print(
            'listenForNewNotifications: ${docSnapshot.id} => ${docSnapshot.data()}');
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

        print("Highest date in the list: $highestDate");
        latestNotificationTimestamp = highestDate.toIso8601String();
        await saveLatestNotificationTimestamp(latestNotificationTimestamp);

        // Call listenForNewNotifications() again to set up a new listener with the updated query
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

  String loadLatestNotificationTimestamp() {
    return _sharedPreferences.getString('latest_notification_timestamp') ?? '';
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
    print(subscribedTopics.value);
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
    latestNotificationTimestamp = '';
  }

  Future<void> subscribeToPlayer() async {
    FirebaseMessaging.instance
        .subscribeToTopic('player_who_returned_10000_years_later');
    await saveSubscribedTopicLocal('player_who_returned_10000_years_later');
    addNewListener('player_who_returned_10000_years_later');
  }

  Future<String> saveSubscribedTopicLocal(String topic) async {
    final String formattedTopic = 'topic_$topic';
    final String timestamp = DateTime.now().toIso8601String();
    if (!_sharedPreferences.containsKey(formattedTopic)) {
      await _sharedPreferences.setString(
          formattedTopic, DateTime.now().toIso8601String());
      subscribedTopics.value[topic] = timestamp;
    }
    return timestamp;
  }

  Future<void> removeSubscribedTopicLocal(String topic) async {
    final String formattedTopic = 'topic_$topic';
    await _sharedPreferences.remove(formattedTopic);
    subscribedTopics.value.remove(topic);
  }
}
