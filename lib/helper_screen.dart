import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manhwa_alert/layers/home/view/screen/home_screen.dart';
import 'package:manhwa_alert/layers/search/models/scanlator_model.dart';
import 'package:manhwa_alert/layers/search/view/screen/scanlator_selection_screen.dart';
import 'package:manhwa_alert/layers/search/view/screen/search_screen.dart';

class HelperScreen extends StatefulWidget {
  @override
  _HelperScreenState createState() => _HelperScreenState();
}

class _HelperScreenState extends State<HelperScreen> {
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
    HomeScreen(),
    HomeScreen(),
  ];

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
          print(index);
          setState(() {
            _currentIndex = index;
          });
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
            icon: SvgPicture.asset(
              'assets/icons/notifications-bell.svg',
              colorFilter: ColorFilter.mode(
                Color(0xFF676767),
                BlendMode.srcIn,
              ),
              height: 28,
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
