import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/scheduler.dart';

class ManhwaSearchResultListBuilder extends StatefulWidget {
  const ManhwaSearchResultListBuilder({
    super.key,
    required this.webtoon,
  });

  final Map<String, String> webtoon;

  @override
  State<ManhwaSearchResultListBuilder> createState() =>
      _ManhwaSearchResultListBuilderState();
}

class _ManhwaSearchResultListBuilderState
    extends State<ManhwaSearchResultListBuilder>
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
          width: 300,
          height: 300,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Shimmer.fromColors(
              baseColor: Color(0xFF292929),
              highlightColor: Color(0xFF333333),
              child: Container(
                color: Color(0xFF292929),
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
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !isLoading,
          child: Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 4.0,
              ),
              child: Text(
                widget.webtoon['title']!,
                style: GoogleFonts.overpass(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      ],
    );
  }
}
