import 'package:flutter/material.dart';

class InfiniteCarousel extends StatefulWidget {
  @override
  _InfiniteCarouselState createState() => _InfiniteCarouselState();
}

class _InfiniteCarouselState extends State<InfiniteCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  final List<CarouselItem> _carouselItems = [
    CarouselItem(
      image:
          'https://www.asurascans.com/wp-content/uploads/2022/12/RelifePlayerCover03.png',
      subtitle: 'Relife Player',
      title: 'Title 1',
    ),
    CarouselItem(
      image: 'https://flamescans.org/wp-content/uploads/2021/01/image.png',
      subtitle: 'Solo Leveling',
      title: 'Title 1',
    ),
    CarouselItem(
      image:
          'https://www.asurascans.com/wp-content/uploads/2021/07/solomaxlevelnewbie.jpg',
      subtitle: 'Solo Max-Level Newbie',
      title: 'Title 2',
    ),
    CarouselItem(
      image:
          'https://www.asurascans.com/wp-content/uploads/2022/10/inquisitionSwordCover02.png',
      subtitle: 'Heavenly Inquisition Sword',
      title: 'Title 3',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _currentPage = _carouselItems.length * 1000;

    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.6,
    );

    // _pageController.addListener(_pageListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _carouselItems.length *
            10000, // Use a large number to ensure infinite scrolling
        itemBuilder: (context, index) {
          final itemIndex = index % _carouselItems.length;
          return CarouselItemWidget(
            item: _carouselItems[itemIndex],
            itemIndex: itemIndex,
            isSelected: itemIndex == _currentPage % _carouselItems.length,
          );
        },
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}

class CarouselItem {
  final String image;
  final String subtitle;
  final String title;

  CarouselItem({
    required this.image,
    required this.subtitle,
    required this.title,
  });
}

class CarouselItemWidget extends StatelessWidget {
  final CarouselItem item;
  final int itemIndex;
  final bool isSelected;

  CarouselItemWidget({
    required this.item,
    required this.itemIndex,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final double opacity = isSelected ? 1.0 : 0.5;
    // final double height = itemIndex == currentIndex ? 350.0 : 300.0;
    final double height = MediaQuery.of(context).size.height * 0.5;
    final double scaleFactor = isSelected ? 1.0 : 0.8;

    return AnimatedScale(
      duration: Duration(milliseconds: 200),
      scale: scaleFactor,
      child: Opacity(
        opacity: opacity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height,
              child: Image.network(item.image, fit: BoxFit.cover),
            ),
            if (isSelected)
              Text(
                item.subtitle,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
