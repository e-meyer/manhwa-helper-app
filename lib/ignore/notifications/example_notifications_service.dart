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
}
