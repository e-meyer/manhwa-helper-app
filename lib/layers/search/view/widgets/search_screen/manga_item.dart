import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class MangaItem extends StatefulWidget {
  final Map<String, String> webtoon;

  const MangaItem({
    required this.webtoon,
  });

  @override
  State<MangaItem> createState() => _MangaItemState();
}

class _MangaItemState extends State<MangaItem>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImage();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadImage() async {
    final image = NetworkImage(widget.webtoon['cover']!);
    await precacheImage(image, context);
    setState(() {
      isLoading = false;
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          widget.webtoon['cover']!,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Colors.white,
              ),
            );
          },
        ),
        Visibility(
          visible: !isLoading,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.webtoon['title']!,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
