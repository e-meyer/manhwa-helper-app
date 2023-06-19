import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:manhwa_alert/layers/notifications/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService extends ChangeNotifier {
  int _newNotificationCount = 0;

  final SharedPreferences _sharedPreferences;

  NotificationService(this._sharedPreferences);

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

  Future<List<NotificationModel>> getLocalNotifications() async {
    List<NotificationModel> notifications = [];
    final List<String> initialList =
        await _sharedPreferences.getStringList('notifications') ?? [];

    for (String notificationString in initialList) {
      List<String> notificationParts = notificationString.split('|');
      String manhwaTitle = notificationParts[0];
      String chapterNumber = notificationParts[1];
      String chapterUrl = notificationParts[2];
      String coverUrl = notificationParts[3];
      DateTime notificationTimestamp = DateTime.parse(notificationParts[4]);
      bool isRead = notificationParts[5] == 'unread' ? false : true;

      notifications.add(
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
    return notifications;
  }

  Future<void> saveNotification(Map<String, dynamic> message) async {
    String manhawTitle = message['manhwa_title'];
    String chapterNumber = message['chapter_number'];
    String coverUrl = message['chapter_url'];
    String chapterUrl = message['cover_url'];
    String notificationTimestamp = message['notification_timestamp'];

    List<String> notifications =
        _sharedPreferences.getStringList('notifications') ?? [];
    notifications.add(
      '$manhawTitle|$chapterNumber|$coverUrl|$chapterUrl|$notificationTimestamp|unread',
    );
    await _sharedPreferences.setStringList('notifications', notifications);

    // DateTime dateTime = DateTime.parse(dateStr);

    // String formattedDate = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
    // String formattedTime =
    //     '${dateTime.hour}:${dateTime.minute}:${dateTime.second}';

    // print('Formatted Date: $formattedDate');
    // print('Formatted Time: $formattedTime');
  }
}
