import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../layers/notifications/controller/notification_service.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupLocator() async {
  if (!serviceLocator.isRegistered<SharedPreferences>()) {
    final sharedPreferences = await SharedPreferences.getInstance();
    serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);
  }
  if (!serviceLocator.isRegistered<FirebaseMessaging>()) {
    serviceLocator
        .registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance);
  }
  if (!serviceLocator.isRegistered<FirebaseFirestore>()) {
    serviceLocator
        .registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  }
  if (!serviceLocator.isRegistered<NotificationService>()) {
    serviceLocator.registerSingleton<NotificationService>(
      NotificationService(
        serviceLocator(),
        serviceLocator(),
      ),
    );
  }
}
