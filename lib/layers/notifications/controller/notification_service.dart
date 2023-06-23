import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:manhwa_alert/layers/notifications/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService extends ChangeNotifier {
  final ValueNotifier<int> unseenNotificationCount = ValueNotifier(0);
  final ValueNotifier<List<NotificationModel>> notifications =
      ValueNotifier([]);
  final ValueNotifier<Map<String, String>> subscribedTopics = ValueNotifier({});

  final SharedPreferences _sharedPreferences;

  NotificationService(this._sharedPreferences) {
    loadCachedNotifications();
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

  void addNotifications(List<NotificationModel> newNotifications) {
    List<NotificationModel> notificationsHolder = notifications.value;
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
    cachedNotifications.map((notification) {
      final Map<String, dynamic> notificationMap = json.decode(notification);
      notificationsHolder.add(NotificationModel.fromMap(notificationMap));
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

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    final value = _sharedPreferences.getInt('unseenNotificationCount') ?? 0;
    await _sharedPreferences.setInt('unseenNotificationCount', value + 1);
    await _sharedPreferences.reload();
    loadNotificationCount();
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
}
