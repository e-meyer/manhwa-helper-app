import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DetailsScreen extends StatefulWidget {
  final Map<String, dynamic> webtoon;

  const DetailsScreen({
    super.key,
    required this.webtoon,
  });

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.34,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.webtoon["cover_url"]),
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
                              Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(1.0),
                              Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.95),
                              Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.81),
                              Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.43),
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
                              const SizedBox(height: 10),
                              Text(
                                'Subscribe',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFF858597),
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
                              const SizedBox(height: 10),
                              Text(
                                'View on web',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xFF858597),
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Synopsis',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 15),
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          firstChild: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.95),
                                Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.4),
                                Colors.transparent
                              ],
                              stops: const [0.1, 0.7, 1.0],
                            ).createShader(bounds),
                            blendMode: BlendMode.darken,
                            child: Text(
                              webtoon['synopsis'],
                              maxLines: 3,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF9393A3),
                              ),
                            ),
                          ),
                          secondChild: Text(
                            webtoon['synopsis'],
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF9393A3),
                            ),
                          ),
                          crossFadeState: _isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(
                                  _isExpanded
                                      ? 'assets/icons/arrow-up.svg'
                                      : 'assets/icons/arrow-down.svg',
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
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
                          const Text(
                            'Chapters',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 18),
                          ListView.separated(
                            padding: const EdgeInsets.all(0),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: webtoon["chapters_labels"].length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    webtoon["chapters_labels"][index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    webtoon["chapters_release_date"][index],
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: Color(
                                        0xFF8A8A8A,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 20);
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
                      // child: CachedNetworkImage(
                      //   imageUrl: widget.webtoon['smaller_cover_url'] ??
                      //       widget.webtoon['cover_url']!,
                      //   fit: BoxFit.cover,
                      // ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.webtoon["cover_url"]),
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
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Color(0xFF858597),
                            ),
                          ),
                          Text(
                            widget.webtoon['title'],
                            style: TextStyle(
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
            Positioned(
              top: 30,
              left: 18,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
