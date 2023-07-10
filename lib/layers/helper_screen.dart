import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manhwa_alert/layers/home/view/screen/home_screen.dart';
import 'package:manhwa_alert/layers/notifications/view/screen/notifications_screen.dart';
import 'package:manhwa_alert/layers/search/models/scanlator_model.dart';
import 'package:manhwa_alert/layers/search/view/screen/scanlator_selection_screen.dart';
import 'package:manhwa_alert/layers/search/view/screen/search_screen.dart';
import 'package:manhwa_alert/core/injector/service_locator.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notifications/controller/notification_service.dart';

class HelperScreen extends StatefulWidget {
  const HelperScreen({super.key});

  @override
  State<HelperScreen> createState() => _HelperScreenState();
}

class _HelperScreenState extends State<HelperScreen>
    with WidgetsBindingObserver {
  final FirebaseMessaging _fcm = serviceLocator.get<FirebaseMessaging>();
  final NotificationService service = serviceLocator.get<NotificationService>();
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  final List<Widget> _screens = [
    HomeScreen(),
    ScanlatorSelectionScreen(),
    NotificationsScreen(),
    HomeScreen(),
  ];

  requestPermission() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User grander provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.reload();
      service.loadNotificationCount();
    }
  }

  @override
  void initState() {
    super.initState();
    service.getLocalSubscribedTopics();
    service.listenForNewNotifications();
    WidgetsBinding.instance.addObserver(this);
    requestPermission();
    WidgetsFlutterBinding.ensureInitialized();

    _fcm.getToken().then((token) => print('FCM Token: $token'));

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      service.incrementNotificationCount();
      await service.saveNotificationCount();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        if (settings.name == '/search') {
          final ScanlatorModel scanlator = settings.arguments as ScanlatorModel;
          return MaterialPageRoute(
            builder: (_) => SearchScreen(scanlator: scanlator),
          );
        }
        return null;
      },
      home: PersistentTabView(
        context,
        controller: _controller,
        screens: _screens,
        items: [
          PersistentBottomNavBarItem(
            inactiveIcon: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icons/home.svg',
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFFFFFF),
                  BlendMode.srcIn,
                ),
              ),
            ),
            icon: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icons/home-solid.svg',
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFFFFFF),
                  BlendMode.srcIn,
                ),
              ),
            ),
            activeColorPrimary: Colors.white,
            inactiveColorPrimary: Colors.grey,
          ),
          PersistentBottomNavBarItem(
            inactiveIcon: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFFFFFF),
                  BlendMode.srcIn,
                ),
              ),
            ),
            icon: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icons/search-solid.svg',
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFFFFFF),
                  BlendMode.srcIn,
                ),
              ),
            ),
            activeColorPrimary: Colors.white,
            inactiveColorPrimary: Colors.grey,
          ),
          PersistentBottomNavBarItem(
            inactiveIcon: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ValueListenableBuilder(
                  valueListenable: service.unseenNotificationCount,
                  builder: (context, value, child) {
                    return Stack(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/notifications-bell.svg',
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFFFFFFF),
                            BlendMode.srcIn,
                          ),
                        ),
                        if (value > 0)
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
                    );
                  },
                ),
              ),
            ),
            icon: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ValueListenableBuilder(
                  valueListenable: service.unseenNotificationCount,
                  builder: (context, value, child) {
                    return Stack(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/notifications-bell-solid.svg',
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFFFFFFF),
                            BlendMode.srcIn,
                          ),
                        ),
                        if (value > 0)
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
                    );
                  },
                ),
              ),
            ),
            activeColorPrimary: Colors.white,
            inactiveColorPrimary: Colors.grey,
          ),
          PersistentBottomNavBarItem(
            inactiveIcon: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icons/bookmark.svg',
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFFFFFF),
                  BlendMode.srcIn,
                ),
              ),
            ),
            icon: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icons/bookmark-solid.svg',
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFFFFFF),
                  BlendMode.srcIn,
                ),
              ),
            ),
            activeColorPrimary: Colors.white,
            inactiveColorPrimary: Colors.grey,
          ),
        ],
        onItemSelected: (value) async {
          if (value == 2) {
            service.resetNotificationCount();
            await service.saveNotificationCount();
          }
        },
        confineInSafeArea: true,
        backgroundColor: Color(0xFF262626),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: false,
        decoration: const NavBarDecoration(
          colorBehindNavBar: Color(0xFF262626),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        // padding: NavBarPadding.symmetric(vertical: 17),
        navBarStyle: NavBarStyle.style12,
      ),
    );
  }
}
