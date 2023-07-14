import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manhwa_alert/layers/details/view/screen/details_screen.dart';
import 'package:manhwa_alert/layers/search/models/scanlator_model.dart';
import 'package:manhwa_alert/layers/search/view/widgets/search_screen/manhwa_alert_dialog.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/scheduler.dart';

class ManhwaSearchResultListBuilder extends StatefulWidget {
  const ManhwaSearchResultListBuilder({
    super.key,
    required this.webtoon,
    required this.scanlator,
  });

  final ScanlatorModel scanlator;
  final Map<String, String> webtoon;

  @override
  State<ManhwaSearchResultListBuilder> createState() =>
      _ManhwaSearchResultListBuilderState();
}

class _ManhwaSearchResultListBuilderState
    extends State<ManhwaSearchResultListBuilder>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  bool get wantKeepAlive => true;

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
    final image = NetworkImage(
      widget.webtoon['smaller_cover_url'] ?? widget.webtoon['cover_url']!,
    );
    await precacheImage(image, context);
    if (mounted) {
      setState(() {
        isLoading = false;
        _animationController.forward();
      });
    }
  }

  void _showManhwaAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ManhwaAlertDialog(
          webtoon: widget.webtoon, scanlator: widget.scanlator),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
          context,
          settings: RouteSettings(name: '/details'),
          screen: DetailsScreen(webtoon: widget.webtoon),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
        // _showManhwaAlertDialog(context);
      },
      child: Stack(
        children: [
          // CachedNetworkImage(
          //   imageUrl: widget.webtoon['smaller_cover_url'] ??
          //       widget.webtoon['cover_url']!,
          //   width: 300,
          //   height: 300,
          //   fit: BoxFit.cover,
          //   progressIndicatorBuilder: (context, url, downloadProgress) =>
          //       Shimmer.fromColors(
          //     baseColor: Color(0xFF292929),
          //     highlightColor: Color(0xFF333333),
          //     child: Container(
          //       color: Color(0xFF292929),
          //     ),
          //   ),
          //   errorWidget: (context, url, error) => Icon(Icons.error),
          // ),

          Image.network(
            widget.webtoon['smaller_cover_url'] ?? widget.webtoon['cover_url']!,
            width: 300,
            height: 300,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Shimmer.fromColors(
                baseColor: Colors.black,
                highlightColor: Colors.grey,
                child: Container(
                  color: Colors.white,
                ),
              );
            },
          ),
          // Visibility(
          //   visible: !isLoading,
          //   child:
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF151515).withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              // ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 2.0,
              ),
              child: Text(
                widget.webtoon['title']!,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
