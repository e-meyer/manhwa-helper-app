import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manhwa_alert/layers/helper_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:manhwa_alert/core/injector/service_locator.dart';
import 'core/firebase/firebase_options.dart';
import 'layers/notifications/controller/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupLocator();

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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupLocator();
  NotificationService service = serviceLocator.get<NotificationService>();
  await service.firebaseMessagingBackgroundHandler(message);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Infinite Carousel Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HelperScreen(),
    );
  }
}
