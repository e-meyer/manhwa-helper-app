import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../notification_service.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupLocator() async {
  if (!serviceLocator.isRegistered<SharedPreferences>()) {
    final sharedPreferences = await SharedPreferences.getInstance();
    serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);
  }
  if (!serviceLocator.isRegistered<NotificationService>()) {
    serviceLocator.registerSingleton<NotificationService>(
      NotificationService(
        serviceLocator(),
      ),
    );
  }
  if (!serviceLocator.isRegistered<FirebaseMessaging>()) {
    serviceLocator.registerLazySingleton<FirebaseMessaging>(
        () => FirebaseMessaging.instance);
  }
}
