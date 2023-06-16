import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manhwa_alert/helper_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:manhwa_alert/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.instance.getInitialMessage();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");

  SharedPreferences sp = await SharedPreferences.getInstance();

  final value = sp.getInt('newNotificationCount') ?? 0;
  await sp.setInt('newNotificationCount', value + 1);
  print("value: " + value.toString());
  // await setupLocator();
  // NotificationService service = serviceLocator.get<NotificationService>();
  // SharedPreferences sp = serviceLocator.get<SharedPreferences>();

  // service.loadNotificationCount();
  // service.incrementNotificationCount();
  // service.loadNotificationCount();
  // print("Teste: " + service.newNotificationCount.toString());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Carousel Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HelperScreen(),
    );
  }
}
