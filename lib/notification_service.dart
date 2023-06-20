import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:manhwa_alert/layers/notifications/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService extends ChangeNotifier {
  final ValueNotifier<int> unseenNotificationCount = ValueNotifier(0);
  final ValueNotifier<List<NotificationModel>> notifications =
      ValueNotifier([]);

  final SharedPreferences _sharedPreferences;

  NotificationService(this._sharedPreferences) {
    loadLocalNotifications();
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
    await saveNotification(message.data);
    await _sharedPreferences.reload();
    loadNotificationCount();
    loadLocalNotifications();
  }

  void loadLocalNotifications() {
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

  void markNotificationAsRead(NotificationModel notification) async {
    final List<NotificationModel> updatedNotifications =
        List.from(notifications.value);
    for (var item in updatedNotifications) {
      if (item.chapterUrl == notification.chapterUrl) {
        item.isRead = true;
      }
    }

    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    List<String> currentLocalNotifications =
        _sharedPreferences.getStringList('notifications') ?? [];

    int notificationIndex = currentLocalNotifications
        .indexWhere((element) => element.contains(notification.chapterUrl));
    if (notificationIndex != -1) {
      List<String> notificationData =
          currentLocalNotifications[notificationIndex].split('|');
      notificationData[5] = 'read'; // Update the isRead value
      currentLocalNotifications[notificationIndex] =
          notificationData.join('|'); // Rejoin the notification data
      await _sharedPreferences.setStringList('notifications',
          currentLocalNotifications); // Save the updated list back to SharedPreferences
    }
    notifications.value = updatedNotifications;
  }

  Future<void> clearAllNotifications() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    await _sharedPreferences.remove('notifications');
    notifications.value = [];
  }
}
