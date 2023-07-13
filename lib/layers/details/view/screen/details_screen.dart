import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  Map<String, dynamic> webtoon = {
    "title": "Hero Returns",
    "cover_url":
        "https://www.asurascans.com/wp-content/uploads/2022/03/theheroreturnsCover02.png",
    "chapters_number": "16",
    "status": "Ongoing",
    "chapters_labels": [
      "Chapter 16",
      "Chapter 15",
      "Chapter 14",
      "Chapter 13",
      "Chapter 12",
      "Chapter 11",
      "Chapter 10",
      "Chapter 9",
      "Chapter 8",
      "Chapter 7",
      "Chapter 6",
      "Chapter 5",
      "Chapter 4",
      "Chapter 3",
      "Chapter 2",
      "Chapter 1",
    ],
    "chapters_urls": [
      "https://example.com",
      "https://example.com",
      "https://example.com",
      "https://example.com",
      "https://example.com",
      "https://example.com",
      "https://example.com",
      "https://example.com",
      "https://example.com",
      "https://example.com",
      "https://example.com",
      "https://example.com",
      "https://example.com",
      "https://example.com",
      "https://example.com",
      "https://example.com",
    ],
    "chapters_release_date": [
      "1 day ago",
      "1 week ago",
      "2 weeks ago",
      "3 weeks ago",
      "1 month ago",
      "1 month ago",
      "1 month ago",
      "1 month ago",
      "2 months ago",
      "2 months ago",
      "2 months ago",
      "2 months ago",
      "3 months ago",
      "3 months ago",
      "3 months ago",
      "3 months ago",
    ],
    "synopsis":
        "Big synopsis very big one. A very big synopsis right here, as you can see. And no one is really caring about how big it is because it's actually kind of small, not that big of a deal. But not that small aswell, just average I'd say.",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF151515),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.34,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(webtoon["cover_url"]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.34,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xFF151515).withOpacity(1.0),
                            Color(0xFF151515).withOpacity(0.81),
                            Color(0xFF151515).withOpacity(0.43),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: Column(
                    children: List.generate(
                      webtoon["chapters_labels"].length,
                      (index) {
                        return ListTile(
                          title: Text(webtoon["chapters_labels"][index]),
                          subtitle:
                              Text(webtoon["chapters_release_date"][index]),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.13,
            left: 18,
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 150,
                    height: 210,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(webtoon["cover_url"]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${webtoon['chapters_number']} Chapters',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Color(0xFF858597),
                          ),
                        ),
                        Text(
                          webtoon['title'],
                          style: GoogleFonts.oswald(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
