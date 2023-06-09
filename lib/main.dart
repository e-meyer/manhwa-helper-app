import 'package:flutter/material.dart';
import 'package:manhwa_alert/layers/scrape/view/screen/scrape_screen.dart';

import 'layers/scrape/view/widgets/infinite_carousel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Carousel Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScrapeScreen(),
    );
  }
}
