import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manhwa_alert/layers/scrape/view/screen/scrape_screen.dart';
import 'package:manhwa_alert/layers/search/view/screen/search_screen.dart';

class HelperScreen extends StatefulWidget {
  @override
  _HelperScreenState createState() => _HelperScreenState();
}

class _HelperScreenState extends State<HelperScreen> {
  int _currentIndex = 0;

  List<Widget> _screens = [
    ScrapeScreen(),
    SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomNavigationBar(
        scaleFactor: 0.01,
        strokeColor: Colors.transparent,
        backgroundColor: Color(0xFF262626),
        currentIndex: _currentIndex,
        onTap: (index) {
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
          // CustomNavigationBarItem(icon: Icon(Icons.notifications)),
          // CustomNavigationBarItem(icon: Icon(Icons.settings)),
        ],
      ),
    );
  }
}
