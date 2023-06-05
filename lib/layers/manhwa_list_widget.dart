import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ManhwaListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  ManhwaListWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
              itemCount: manhwaData.length,
              itemBuilder: (context, manhwaIndex) {
                final title = manhwaData[manhwaIndex]['title'];
                final chapters = manhwaData[manhwaIndex]['chapters'];
                final chapterLinks = manhwaData[manhwaIndex]['chapters_links'];

                return Row(
                  children: [
                    Image.network(
                      "https://www.asurascans.com/wp-content/uploads/2023/02/tIEELUSJN.webp-t.w640-vert-copyCUnetauto_scaleLevel3width-1000.jpg",
                      width: MediaQuery.of(context).size.width * 0.25,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: chapters.length,
                            itemBuilder: (context, chapterIndex) {
                              final chapter = chapters[chapterIndex];
                              final chapterLink = chapterLinks[chapterIndex];
                              return InkWell(
                                onTap: () {
                                  _launchUrl(Uri.parse(chapterLink));
                                },
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 0.0,
                                    vertical: 0.0,
                                  ),
                                  visualDensity: VisualDensity(
                                    horizontal: 0,
                                    vertical: -4,
                                  ),
                                  title: Text(
                                    chapter,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
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
          ],
        );
      },
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
