import 'package:flutter/material.dart';
import '../../models/carousel_model.dart';

class CarouselItemWidget extends StatelessWidget {
  final CarouselModel item;
  final int itemIndex;
  final bool isSelected;

  const CarouselItemWidget({
    super.key,
    required this.item,
    required this.itemIndex,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final double opacity = isSelected ? 1.0 : 0.4;
    final double scaleFactor = isSelected ? 1.0 : 0.95;

    return AnimatedScale(
      duration: const Duration(
        milliseconds: 200,
      ),
      scale: scaleFactor,
      child: Opacity(
        opacity: opacity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Image.network(
                item.image,
                width: 500,
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
