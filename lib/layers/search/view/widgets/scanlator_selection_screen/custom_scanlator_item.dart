import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../../common/widgets/arc/two_rotating_arc.dart';
import '../../../models/scanlator_model.dart';
import '../../screen/search_screen.dart';

class CustomScanlatorItem extends StatefulWidget {
  const CustomScanlatorItem({super.key, required this.scanlatorData});

  final Map<String, dynamic> scanlatorData;

  @override
  State<CustomScanlatorItem> createState() => _CustomScanlatorItemState();
}

class _CustomScanlatorItemState extends State<CustomScanlatorItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final scanlator = ScanlatorModel.fromMap(widget.scanlatorData);
        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
          context,
          settings: RouteSettings(name: '/search'),
          screen: SearchScreen(scanlator: scanlator),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.network(
                  widget.scanlatorData['logo_url'],
                  height: 150,
                  width: 150,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 50.0),
                      child: Center(
                        child: TwoRotatingArc(
                          size: 40,
                          color: Color(0xFFFF6812),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/image-placeholder.svg',
                          height: 150,
                          colorFilter: ColorFilter.mode(
                            Color(0xFF676767),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.scanlatorData['name'],
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
