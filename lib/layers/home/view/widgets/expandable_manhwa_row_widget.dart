import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpandableManhwaRowWidget extends StatefulWidget {
  const ExpandableManhwaRowWidget({
    super.key,
    required this.website,
    required this.manhwaData,
  });

  final String website;
  final List manhwaData;

  @override
  State<ExpandableManhwaRowWidget> createState() =>
      _ExpandableManhwaRowWidgetState();
}

class _ExpandableManhwaRowWidgetState extends State<ExpandableManhwaRowWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            widget.website,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        AnimatedCrossFade(
          firstChild: Column(
            children: [
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, manhwaIndex) {
                    final coverLink =
                        widget.manhwaData[manhwaIndex]['cover_link'];
                    return Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Image.network(
                        coverLink,
                        fit: BoxFit.fitHeight,
                        width: 105,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, manhwaIndex) {
                    final title = widget.manhwaData[manhwaIndex]['title'];
                    final coverLink =
                        widget.manhwaData[manhwaIndex]['cover_link'];
                    final chapters = widget.manhwaData[manhwaIndex]['chapters'];
                    final chapterLinks =
                        widget.manhwaData[manhwaIndex]['chapters_links'];

                    return Row(
                      children: [
                        Image.network(
                          coverLink,
                          fit: BoxFit.fitHeight,
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: 150,
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Center(
                                child: Opacity(
                                  opacity: 0.03,
                                  child: Image.asset(
                                    "assets/scanlators/${widget.website.toLowerCase()}_bg.png",
                                    height: 140,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: Text(
                                        title,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(chapters.length,
                                          (chapterIndex) {
                                        final chapter = chapters[chapterIndex];
                                        final chapterLink =
                                            chapterLinks[chapterIndex];
                                        return InkWell(
                                          onTap: () {
                                            _launchUrl(Uri.parse(chapterLink));
                                          },
                                          child: ListTile(
                                            dense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 0.0,
                                              vertical: 0.0,
                                            ),
                                            visualDensity: VisualDensity(
                                              horizontal: 0,
                                              vertical: -4,
                                            ),
                                            title: Text(
                                              chapter,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 20,
                    );
                  },
                ),
              ),
            ],
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(
            milliseconds: 300,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
          ),
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                _isExpanded
                    ? 'assets/icons/arrow-up.svg'
                    : 'assets/icons/arrow-down.svg',
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Details',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
