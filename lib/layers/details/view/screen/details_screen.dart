import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      "Chapter 101",
      "Chapter 100",
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
      "1 day ago",
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
        "Big synopsis very big one. A very big synopsis right here, as you can see. And no one is really caring about how big it is because it's actually kind of small, not that big of a deal. But not that small aswell, just average I'd say. Big synopsis very big one. A very big synopsis right here, as you can see. And no one is really caring about how big it is because it's actually kind of small, not that big of a deal. But not that small aswell, just average I'd say. ",
  };
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF151515),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
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
                    padding: const EdgeInsets.only(top: 90),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/notifications-bell.svg',
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF858597),
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Subscribe',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Color(0xFF858597),
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/web-view.svg',
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF858597),
                                  BlendMode.srcIn,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'View on web',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Color(0xFF858597),
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Synopsis',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          firstChild: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color(0xFF151515).withOpacity(0.95),
                                Color(0xFF151515).withOpacity(0.4),
                                Colors.transparent
                              ],
                              stops: [
                                0.1,
                                0.7,
                                1.0
                              ], // adjust the stops to control where the gradient starts and ends
                            ).createShader(bounds),
                            blendMode: BlendMode.darken,
                            child: Text(
                              webtoon['synopsis'],
                              maxLines: 3,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF9393A3),
                              ),
                            ),
                          ),
                          secondChild: Text(
                            webtoon['synopsis'],
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF9393A3),
                            ),
                          ),
                          crossFadeState: _isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: SvgPicture.asset(
                              _isExpanded
                                  ? 'assets/icons/arrow-up.svg'
                                  : 'assets/icons/arrow-down.svg',
                              colorFilter: ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chapters',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          ListView.separated(
                            padding: EdgeInsets.all(0),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: webtoon["chapters_labels"].length,
                            itemBuilder: (context, index) {
                              final chapterNumber =
                                  webtoon["chapters_labels"].length - index;
                              return Row(
                                children: [
                                  Container(
                                    width:
                                        webtoon["chapters_labels"].length < 100
                                            ? 30
                                            : 50,
                                    child: Text(
                                      chapterNumber.toString(),
                                      style: GoogleFonts.oswald(
                                        fontSize: 30,
                                        color: Color(0xFF858597),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          webtoon["chapters_labels"][index],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins',
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          webtoon["chapters_release_date"]
                                              [index],
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            color: Color(
                                              0xFF8A8A8A,
                                            ),
                                          ),
                                        )
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
      ),
    );
  }
}
