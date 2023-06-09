import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ManhwaListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ManhwaListWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final website = data[index]['website'];
          final manhwaData = data[index]['manhwa_data'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  website,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, manhwaIndex) {
                  final title = manhwaData[manhwaIndex]['title'];
                  final coverLink = manhwaData[manhwaIndex]['cover_link'];
                  final chapters = manhwaData[manhwaIndex]['chapters'];
                  final chapterLinks =
                      manhwaData[manhwaIndex]['chapters_links'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Row(
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
                                    "assets/scanlators_logos/${website.toLowerCase()}.png",
                                    height: 140,
                                    // width
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              // Center(
                              //   child: Image.asset(
                              //     "assets/scanlators_logos/asura.png",
                              //     height: 140,
                              //     // width
                              //     fit: BoxFit.fitHeight,
                              //   ),
                              // ),
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
                                        style: GoogleFonts.overpass(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
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
                                              style: GoogleFonts.overpass(
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
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 20,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
