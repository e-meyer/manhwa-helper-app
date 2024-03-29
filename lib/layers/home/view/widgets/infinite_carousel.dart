import 'dart:async';
import 'package:flutter/material.dart';
import 'package:manhwa_alert/layers/home/models/carousel_model.dart';
import 'carousel_item_builder_widget.dart';

class InfiniteCarousel extends StatefulWidget {
  const InfiniteCarousel({super.key});

  @override
  State<InfiniteCarousel> createState() => _InfiniteCarouselState();
}

class _InfiniteCarouselState extends State<InfiniteCarousel> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  final List<CarouselModel> _carouselItems = [
    CarouselModel(
      image:
          'https://www.asurascans.com/wp-content/uploads/2022/12/RelifePlayerCover03.png',
      subtitle: 'Relife Player',
      title: 'Title 1',
    ),
    CarouselModel(
      image: 'https://flamescans.org/wp-content/uploads/2021/01/image.png',
      subtitle: 'Solo Leveling',
      title: 'Title 1',
    ),
    CarouselModel(
      image:
          'https://www.asurascans.com/wp-content/uploads/2021/07/solomaxlevelnewbie.jpg',
      subtitle: 'Solo Max-Level Newbie',
      title: 'Title 2',
    ),
    CarouselModel(
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
      viewportFraction: 0.5,
    );

    _startAutoplay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoplay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: _carouselItems.length * 10000,
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
    );
  }
}
