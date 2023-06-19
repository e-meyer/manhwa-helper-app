import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:manhwa_alert/core/injector/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../notification_service.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final NotificationService service = serviceLocator.get<NotificationService>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.reload();
      print(sp.getInt('newNotificationCount').toString());
      print("testeeee  " + service.newNotificationCount.toString());
      service.loadNotificationCount().then((value) => setState(() {}));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsFlutterBinding.ensureInitialized();
    service.loadNotificationCount().then((value) => setState(() {
          print("service ${service.newNotificationCount}");
        }));

    _fcm.getToken().then((token) => print('FCM Token: $token'));

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground:');
      print('Message data: ${message.data}');
      setState(() {
        service.incrementNotificationCount();
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('&*&*&*&**&*&*&**&*&*&!@&*!@&*!@&*!&@*!@&*&!*');
      print('Received a message and opened the app:');
      print('Message data: ${message.data}');
    });

    _fcm.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('Received a message while the app was terminated:');
        print('Message data: ${message.data}');
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _subscribeToBanana() {
    _fcm.subscribeToTopic('banana');
  }

  void _subscribeToFrenchFries() {
    _fcm.subscribeToTopic('french_fries');
  }

  void _printNotificationsNumber() {
    print(service.newNotificationCount);
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _subscribeToBanana,
              child: Text('Send to Banana'),
            ),
            ElevatedButton(
              onPressed: _subscribeToFrenchFries,
              child: Text('Send to French Fries'),
            ),
            ElevatedButton(
              onPressed: _printNotificationsNumber,
              child: Text('Notifications Number'),
            ),
            Text(service.newNotificationCount.toString())
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (_selectedIndex == 1) {
            service.resetNotificationCount();
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.notifications),
                if (service.newNotificationCount > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _buildBadge(),
                  ),
              ],
            ),
            label: 'Notifications',
          ),
          // Add more BottomNavigationBarItems here if needed
        ],
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
