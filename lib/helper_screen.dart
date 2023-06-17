import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manhwa_alert/layers/home/view/screen/home_screen.dart';
import 'package:manhwa_alert/layers/notifications/view/screen/notifications_screen.dart';
import 'package:manhwa_alert/layers/search/models/scanlator_model.dart';
import 'package:manhwa_alert/layers/search/view/screen/scanlator_selection_screen.dart';
import 'package:manhwa_alert/layers/search/view/screen/search_screen.dart';
import 'package:manhwa_alert/core/injector/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';

class HelperScreen extends StatefulWidget {
  @override
  _HelperScreenState createState() => _HelperScreenState();
}

class _HelperScreenState extends State<HelperScreen>
    with WidgetsBindingObserver {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final NotificationService service = serviceLocator.get<NotificationService>();
  int _currentIndex = 0;

  Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
  };

  List<Widget> _screens = [
    HomeScreen(),
    ScanlatorSelectionScreen(),
    NotificationsScreen(),
    HomeScreen(),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildNavigator(),
      bottomNavigationBar: CustomNavigationBar(
        scaleCurve: Curves.decelerate,
        // iconSize: 24,
        scaleFactor: 0.05,
        strokeColor: Colors.transparent,
        backgroundColor: Color(0xFF262626),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (_currentIndex == 2) {
            service.resetNotificationCount();
          }
        },
        items: [
          CustomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              colorFilter: ColorFilter.mode(
                Color(0xFF676767),
                BlendMode.srcIn,
              ),
              height: 28,
            ),
            selectedIcon: AnimatedOpacity(
              opacity: _currentIndex == 0 ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: SvgPicture.asset(
                'assets/icons/home-solid.svg',
                colorFilter: ColorFilter.mode(
                  Color(0xFFFFFFFF),
                  BlendMode.srcIn,
                ),
                height: 28,
              ),
            ),
          ),
          CustomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: ColorFilter.mode(
                Color(0xFF676767),
                BlendMode.srcIn,
              ),
              height: 28,
            ),
            selectedIcon: SvgPicture.asset(
              'assets/icons/search-solid.svg',
              colorFilter: ColorFilter.mode(
                Color(0xFFFFFFFF),
                BlendMode.srcIn,
              ),
              height: 28,
            ),
          ),
          CustomNavigationBarItem(
            icon: Stack(
              children: [
                SvgPicture.asset(
                  'assets/icons/notifications-bell.svg',
                  colorFilter: ColorFilter.mode(
                    Color(0xFF676767),
                    BlendMode.srcIn,
                  ),
                  height: 28,
                ),
                if (service.newNotificationCount > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
              ],
            ),
            selectedIcon: SvgPicture.asset(
              'assets/icons/notifications-bell-solid.svg',
              colorFilter: ColorFilter.mode(
                Color(0xFFFFFFFF),
                BlendMode.srcIn,
              ),
              height: 28,
            ),
          ),
          CustomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/bookmark.svg',
              colorFilter: ColorFilter.mode(
                Color(0xFF676767),
                BlendMode.srcIn,
              ),
              height: 28,
            ),
            selectedIcon: SvgPicture.asset(
              'assets/icons/bookmark-solid.svg',
              colorFilter: ColorFilter.mode(
                Color(0xFFFFFFFF),
                BlendMode.srcIn,
              ),
              height: 28,
            ),
          ),
        ],
      ),
    );
  }

  buildNavigator() {
    return Navigator(
      key: navigatorKeys[_currentIndex],
      onGenerateRoute: (RouteSettings settings) {
        final args = settings.arguments;

        if (settings.name == 'search') {
          if (args is ScanlatorModel) {
            return MaterialPageRoute(
              builder: (_) => SearchScreen(
                scanlator: args,
              ),
            );
          }
        }
        return MaterialPageRoute(
            builder: (_) => _screens.elementAt(_currentIndex));
      },
    );
  }
}
