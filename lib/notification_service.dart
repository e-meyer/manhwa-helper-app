import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:manhwa_alert/layers/notifications/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService extends ChangeNotifier {
  int _newNotificationCount = 0;
  final ValueNotifier<List<NotificationModel>> notifications =
      ValueNotifier([]);

  final SharedPreferences _sharedPreferences;

  NotificationService(this._sharedPreferences) {
    getLocalNotifications();
  }

  int get newNotificationCount => _newNotificationCount;

  Future<void> saveNotificationCount() async {
    await _sharedPreferences.setInt(
        'newNotificationCount', _newNotificationCount);
  }

  Future<void> loadNotificationCount() async {
    _newNotificationCount =
        _sharedPreferences.getInt('newNotificationCount') ?? 0;
    notifyListeners();
  }

  void incrementNotificationCount() {
    _newNotificationCount++;
    saveNotificationCount();
    notifyListeners();
  }

  void resetNotificationCount() {
    _newNotificationCount = 0;
    saveNotificationCount();
    notifyListeners();
  }

  void initializeFirebaseMessaging() async {
    await loadNotificationCount();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      incrementNotificationCount();
    });
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await loadNotificationCount();
    incrementNotificationCount();
  }

  void getLocalNotifications() {
    final List<String> initialList =
        _sharedPreferences.getStringList('notifications') ?? [];
    final List<NotificationModel> updatedNotifications = [];

    for (String notificationString in initialList) {
      List<String> notificationParts = notificationString.split('|');
      String manhwaTitle = notificationParts[0];
      String chapterNumber = notificationParts[1];
      String coverUrl = notificationParts[2];
      String chapterUrl = notificationParts[3];

      DateTime notificationTimestamp = DateTime.parse(notificationParts[4]);
      bool isRead = notificationParts[5] == 'unread' ? false : true;

      updatedNotifications.add(
        NotificationModel(
          manhwaTitle: manhwaTitle,
          coverUrl: coverUrl,
          chapterUrl: chapterUrl,
          notificationTimestamp: notificationTimestamp,
          chapterNumber: chapterNumber,
          isRead: isRead,
        ),
      );
    }
    notifications.value = updatedNotifications;
  }

  Future<void> saveNotification(Map<String, dynamic> message) async {
    String manhwaTitle = message['manhwa_title'];
    String chapterNumber = message['chapter_number'];
    String coverUrl = message['cover_url'];
    String chapterUrl = message['chapter_url'];
    String notificationTimestamp = message['notification_timestamp'];

    List<String> currentLocalNotifications =
        _sharedPreferences.getStringList('notifications') ?? [];
    currentLocalNotifications.add(
      '$manhwaTitle|$chapterNumber|$coverUrl|$chapterUrl|$notificationTimestamp|unread',
    );
    await _sharedPreferences.setStringList(
        'notifications', currentLocalNotifications);

    final newNotification = NotificationModel(
      manhwaTitle: manhwaTitle,
      coverUrl: coverUrl,
      chapterUrl: chapterUrl,
      notificationTimestamp: DateTime.parse(notificationTimestamp),
      chapterNumber: chapterNumber,
      isRead: false,
    );

    List<NotificationModel> updatedNotifications =
        List.from(notifications.value);
    updatedNotifications.add(newNotification);
    notifications.value = updatedNotifications;
  }

  void markNotificationAsRead(NotificationModel notification) {
    final List<NotificationModel> updatedNotifications =
        List.from(notifications.value);
    for (var item in updatedNotifications) {
      if (item.chapterUrl == notification.chapterUrl) {
        item.isRead = true;
      }
    }
    for (var item in updatedNotifications) {
      print(item.isRead);
    }
    notifications.value = updatedNotifications;
  }
}
