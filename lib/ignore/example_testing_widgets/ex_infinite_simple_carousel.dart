import 'package:flutter/material.dart';

final List<String> carouselItems = [
  'Item 1',
  'Item 2',
  'Item 3',
  'Item 4',
  // Add more items as needed
];

class InfiniteScrollCarousel extends StatefulWidget {
  @override
  _InfiniteScrollCarouselState createState() => _InfiniteScrollCarouselState();
}

class _InfiniteScrollCarouselState extends State<InfiniteScrollCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _currentPage = carouselItems.length *
        1000; // Set initial page to a large number for infinite scrolling
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: carouselItems.length *
          10000, // Use a large number to ensure infinite scrolling
      itemBuilder: (context, index) {
        final itemIndex = index % carouselItems.length;
        return _buildCarouselItem(itemIndex);
      },
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    );
  }

  Widget _buildCarouselItem(int index) {
    final currentItem = carouselItems[index];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      color: Colors.blue,
      child: Center(
        child: Text(
          currentItem,
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    );
  }
}
