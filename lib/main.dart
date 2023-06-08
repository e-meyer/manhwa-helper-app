import 'package:flutter/material.dart';

import 'infinite_carousel.dart';

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
      home: InfiniteCarousel(),
    );
  }
}
