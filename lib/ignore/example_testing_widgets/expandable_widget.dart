import 'package:flutter/material.dart';

class CarouselItem {
  final String image;
  final String subtitle;
  final String title;

  CarouselItem({
    required this.image,
    required this.subtitle,
    required this.title,
  });
}

class ExpandableWidget extends StatefulWidget {
  @override
  _ExpandableWidgetState createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  bool _isExpanded = false;

  List<CarouselItem> _carouselItems = [
    CarouselItem(
      image:
          'https://www.asurascans.com/wp-content/uploads/2022/12/RelifePlayerCover03.png',
      subtitle: 'Relife Player',
      title: 'Title 1',
    ),
    CarouselItem(
      image: 'https://flamescans.org/wp-content/uploads/2021/01/image.png',
      subtitle: 'Solo Leveling',
      title: 'Title 1',
    ),
    CarouselItem(
      image:
          'https://www.asurascans.com/wp-content/uploads/2021/07/solomaxlevelnewbie.jpg',
      subtitle: 'Solo Max-Level Newbie',
      title: 'Title 2',
    ),
    CarouselItem(
      image:
          'https://www.asurascans.com/wp-content/uploads/2022/10/inquisitionSwordCover02.png',
      subtitle: 'Heavenly Inquisition Sword',
      title: 'Title 3',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildImagesRow(),
            ),
          ),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildItemsColumn(),
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(_isExpanded ? 'Collapse' : 'Expand'),
        ),
      ],
    );
  }

  List<Widget> _buildImagesRow() {
    return _carouselItems.map((item) {
      return Padding(
        padding: EdgeInsets.all(4.0),
        child: Image.network(
          item.image,
          height: 200,
          fit: BoxFit.cover,
        ),
      );
    }).toList();
  }

  List<Widget> _buildItemsColumn() {
    return _carouselItems.map((item) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Image.network(
              item.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 16),
            Text(
              item.title,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }).toList();
  }
}


// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ManhwaListWidget extends StatefulWidget {
//   final List<Map<String, dynamic>> data;

//   const ManhwaListWidget({
//     super.key,
//     required this.data,
//   });

//   @override
//   State<ManhwaListWidget> createState() => _ManhwaListWidgetState();
// }

// class _ManhwaListWidgetState extends State<ManhwaListWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: ListView.builder(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: widget.data.length,
//         itemBuilder: (context, index) {
//           final website = widget.data[index]['website'];
//           final manhwaData = widget.data[index]['manhwa_data'];

//           return ListView.separated(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: 4,
//             itemBuilder: (context, manhwaIndex) {
//               final title = manhwaData[manhwaIndex]['title'];
//               final coverLink = manhwaData[manhwaIndex]['cover_link'];
//               final chapters = manhwaData[manhwaIndex]['chapters'];
//               final chapterLinks = manhwaData[manhwaIndex]['chapters_links'];

//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 14.0),
//                 child: Row(
//                   children: [
//                     Image.network(
//                       coverLink,
//                       fit: BoxFit.fitHeight,
//                       width: MediaQuery.of(context).size.width * 0.30,
//                       height: 150,
//                     ),
//                     Expanded(
//                       child: Stack(
//                         children: [
//                           Center(
//                             child: Opacity(
//                               opacity: 0.03,
//                               child: Image.asset(
//                                 "assets/scanlators_logos/${website.toLowerCase()}.png",
//                                 height: 140,
//                                 fit: BoxFit.fitHeight,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 4.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(bottom: 12.0),
//                                   child: Text(
//                                     title,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: List.generate(chapters.length,
//                                       (chapterIndex) {
//                                     final chapter = chapters[chapterIndex];
//                                     final chapterLink =
//                                         chapterLinks[chapterIndex];
//                                     return InkWell(
//                                       onTap: () {
//                                         _launchUrl(Uri.parse(chapterLink));
//                                       },
//                                       child: ListTile(
//                                         dense: true,
//                                         contentPadding: EdgeInsets.symmetric(
//                                           horizontal: 0.0,
//                                           vertical: 0.0,
//                                         ),
//                                         visualDensity: VisualDensity(
//                                           horizontal: 0,
//                                           vertical: -4,
//                                         ),
//                                         title: Text(
//                                           chapter,
//                                           style: GoogleFonts.poppins(
//                                             fontSize: 14,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   }),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             separatorBuilder: (context, index) {
//               return SizedBox(
//                 height: 20,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Future<void> _launchUrl(url) async {
//     if (!await launchUrl(url)) {
//       throw Exception('Could not launch $url');
//     }
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ManhwaListWidget extends StatefulWidget {
//   final List<Map<String, dynamic>> data;

//   const ManhwaListWidget({
//     super.key,
//     required this.data,
//   });

//   @override
//   State<ManhwaListWidget> createState() => _ManhwaListWidgetState();
// }

// class _ManhwaListWidgetState extends State<ManhwaListWidget> {
//   bool _isExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     final website = widget.data[0]['website'];
//     final manhwaData = widget.data[0]['manhwa_data'];

//     return SingleChildScrollView(
//       physics: NeverScrollableScrollPhysics(),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Flexible(
//             child: ListView.separated(
//                 shrinkWrap: true,
//                 itemCount: widget.data.length,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   final website = widget.data[index]['website'];
//                   final manhwaData = widget.data[index]['manhwa_data'];
//                   return Column(
//                     children: [
//                       SizedBox(
//                         height: 150,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           shrinkWrap: true,
//                           physics: BouncingScrollPhysics(),
//                           itemCount: 4,
//                           itemBuilder: (context, manhwaIndex) {
//                             final title = manhwaData[manhwaIndex]['title'];
//                             final coverLink =
//                                 manhwaData[manhwaIndex]['cover_link'];
//                             final chapters =
//                                 manhwaData[manhwaIndex]['chapters'];
//                             final chapterLinks =
//                                 manhwaData[manhwaIndex]['chapters_links'];
//                             return Image.network(
//                               coverLink,
//                               fit: BoxFit.fitHeight,
//                               width: MediaQuery.of(context).size.width * 0.30,
//                               height: 150,
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   );
                  // return ListView.separated(
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemCount: 4,
                  //   itemBuilder: (context, manhwaIndex) {
                  //     final title = manhwaData[manhwaIndex]['title'];
                  //     final coverLink = manhwaData[manhwaIndex]['cover_link'];
                  //     final chapters = manhwaData[manhwaIndex]['chapters'];
                  //     final chapterLinks = manhwaData[manhwaIndex]['chapters_links'];

                  //     return Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  //       child: Row(
                  //         children: [
                  //           Image.network(
                  //             coverLink,
                  //             fit: BoxFit.fitHeight,
                  //             width: MediaQuery.of(context).size.width * 0.30,
                  //             height: 150,
                  //           ),
                  //           Expanded(
                  //             child: Stack(
                  //               children: [
                  //                 Center(
                  //                   child: Opacity(
                  //                     opacity: 0.03,
                  //                     child: Image.asset(
                  //                       "assets/scanlators_logos/${website.toLowerCase()}.png",
                  //                       height: 140,
                  //                       fit: BoxFit.fitHeight,
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: const EdgeInsets.only(left: 4.0),
                  //                   child: Column(
                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                  //                     children: [
                  //                       Padding(
                  //                         padding: const EdgeInsets.only(bottom: 12.0),
                  //                         child: Text(
                  //                           title,
                  //                           overflow: TextOverflow.ellipsis,
                  //                           style: GoogleFonts.poppins(
                  //                             fontSize: 15,
                  //                             fontWeight: FontWeight.w600,
                  //                             color: Colors.white,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       Column(
                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                  //                         children: List.generate(chapters.length,
                  //                             (chapterIndex) {
                  //                           final chapter = chapters[chapterIndex];
                  //                           final chapterLink =
                  //                               chapterLinks[chapterIndex];
                  //                           return InkWell(
                  //                             onTap: () {
                  //                               _launchUrl(Uri.parse(chapterLink));
                  //                             },
                  //                             child: ListTile(
                  //                               dense: true,
                  //                               contentPadding: EdgeInsets.symmetric(
                  //                                 horizontal: 0.0,
                  //                                 vertical: 0.0,
                  //                               ),
                  //                               visualDensity: VisualDensity(
                  //                                 horizontal: 0,
                  //                                 vertical: -4,
                  //                               ),
                  //                               title: Text(
                  //                                 chapter,
                  //                                 style: GoogleFonts.poppins(
                  //                                   fontSize: 14,
                  //                                   color: Colors.white,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           );
                  //                         }),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  //   separatorBuilder: (context, index) {
                  //     return SizedBox(
                  //       height: 20,
                  //     );
                  //   },
                  // );
//                 },
//                 separatorBuilder: (context, index) {
//                   return SizedBox(
//                     height: 20,
//                   );
//                 }),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRowOfCovers() {
//     return ListView.builder(
//         itemCount: widget.data.length,
//         itemBuilder: (context, index) {
//           // final website = value['website'];
//           final manhwaData = widget.data[index]['manhwa_data'];

//           // final title = manhwaData['title'];
//           final coverLink = manhwaData['cover_link'];

//           return Padding(
//             padding: EdgeInsets.symmetric(horizontal: 14.0),
//             child: Image.network(
//               coverLink,
//               fit: BoxFit.fitHeight,
//               width: MediaQuery.of(context).size.width * 0.30,
//               height: 150,
//             ),
//           );
//         });
//   }

//   Future<void> _launchUrl(url) async {
//     if (!await launchUrl(url)) {
//       throw Exception('Could not launch $url');
//     }
//   }
// }
