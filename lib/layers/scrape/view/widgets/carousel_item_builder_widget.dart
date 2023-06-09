import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/carousel_model.dart';

class CarouselItemWidget extends StatelessWidget {
  final CarouselModel item;
  final int itemIndex;
  final bool isSelected;

  const CarouselItemWidget({
    required this.item,
    required this.itemIndex,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final double opacity = isSelected ? 1.0 : 0.4;
    final double height = MediaQuery.of(context).size.height * 0.4;
    // final double scaleFactor = isSelected ? 1.0 : 0.9;

    return AnimatedScale(
      duration: const Duration(
        milliseconds: 200,
      ),
      scale: 1.0,
      child: Opacity(
        opacity: opacity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.33,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  item.image,
                  width: 500,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            (isSelected)
                ? Positioned(
                    bottom: 0,
                    child: Text(
                      item.subtitle,
                      style: GoogleFonts.overpass(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
