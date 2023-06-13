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
        scaleFactor: 0.01,
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
              colorFilter: _currentIndex == 0
                  ? ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn)
                  : ColorFilter.mode(Color(0xFF676767), BlendMode.srcIn),
            ),
          ),
          CustomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: _currentIndex == 1
                  ? ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn)
                  : ColorFilter.mode(Color(0xFF676767), BlendMode.srcIn),
            ),
          ),
          CustomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/notifications_bell.svg',
              colorFilter: _currentIndex == 2
                  ? ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn)
                  : ColorFilter.mode(Color(0xFF676767), BlendMode.srcIn),
            ),
          ),
          CustomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/settings_engine.svg',
              colorFilter: _currentIndex == 3
                  ? ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn)
                  : ColorFilter.mode(Color(0xFF676767), BlendMode.srcIn),
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
