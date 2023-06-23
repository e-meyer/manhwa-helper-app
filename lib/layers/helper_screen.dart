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
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final NotificationService service = serviceLocator.get<NotificationService>();
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  final List<Widget> _screens = [
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
      service.loadNotificationCount();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsFlutterBinding.ensureInitialized();
    service.loadNotificationCount();

    _fcm.getToken().then((token) => print('FCM Token: $token'));

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        service.incrementNotificationCount();
      });
      service.saveNotificationCount();
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
            inactiveIcon: SvgPicture.asset(
              'assets/icons/home.svg',
              colorFilter: const ColorFilter.mode(
                Color(0xFF676767),
                BlendMode.srcIn,
              ),
            ),
            icon: SvgPicture.asset(
              'assets/icons/home-solid.svg',
              colorFilter: const ColorFilter.mode(
                Color(0xFFFFFFFF),
                BlendMode.srcIn,
              ),
            ),
            activeColorPrimary: Colors.white,
            inactiveColorPrimary: Colors.grey,
          ),
          PersistentBottomNavBarItem(
            inactiveIcon: SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: const ColorFilter.mode(
                Color(0xFF676767),
                BlendMode.srcIn,
              ),
            ),
            icon: SvgPicture.asset(
              'assets/icons/search-solid.svg',
              colorFilter: const ColorFilter.mode(
                Color(0xFFFFFFFF),
                BlendMode.srcIn,
              ),
            ),
            activeColorPrimary: Colors.white,
            inactiveColorPrimary: Colors.grey,
          ),
          PersistentBottomNavBarItem(
            inactiveIcon: Center(
              child: ValueListenableBuilder(
                valueListenable: service.unseenNotificationCount,
                builder: (context, value, child) {
                  return Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/notifications-bell.svg',
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF676767),
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
                            // child: Center(
                            //   child: Text(
                            //     service.unseenNotificationCount.value
                            //         .toString(),
                            //     style: GoogleFonts.overpass(
                            //       color: Colors.white,
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.w800,
                            //     ),
                            //   ),
                            // ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            icon: Center(
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
            activeColorPrimary: Colors.white,
            inactiveColorPrimary: Colors.grey,
          ),
          PersistentBottomNavBarItem(
            inactiveIcon: SvgPicture.asset(
              'assets/icons/bookmark.svg',
              colorFilter: const ColorFilter.mode(
                Color(0xFF676767),
                BlendMode.srcIn,
              ),
            ),
            icon: SvgPicture.asset(
              'assets/icons/bookmark-solid.svg',
              colorFilter: const ColorFilter.mode(
                Color(0xFFFFFFFF),
                BlendMode.srcIn,
              ),
            ),
            activeColorPrimary: Colors.white,
            inactiveColorPrimary: Colors.grey,
          ),
        ],
        onItemSelected: (value) {
          if (value == 2) {
            service.resetNotificationCount();
            service.saveNotificationCount();
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
        padding: NavBarPadding.all(0),
        navBarStyle: NavBarStyle.style12,
      ),
    );
  }
}