import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:manhwa_alert/layers/scrape/view/widgets/infinite_carousel.dart';
import 'package:manhwa_alert/layers/scrape/view/widgets/manhwa_list_widget.dart';

class ScrapeScreen extends StatefulWidget {
  const ScrapeScreen({super.key});

  @override
  State<ScrapeScreen> createState() => _ScrapeScreenState();
}

class _ScrapeScreenState extends State<ScrapeScreen> {
  // Future<List<Map<String, dynamic>>> fetchData() async {
  //   final response =
  //       await http.get(Uri.parse('http://10.0.2.2:5000/thread_scrape'));

  //   List<dynamic> decodedData = jsonDecode(response.body);
  //   if (decodedData is List<dynamic>) {
  //     return decodedData.cast<Map<String, dynamic>>();
  //   }
  //   return [];
  // }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  void dispose() {
    super.dispose();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values); // to re-show bars
  }

  List<Map<String, dynamic>> manhwaData = [
    {
      "website": "Asura",
      "manhwa_data": [
        {
          "title": "Omniscient Reader\u2019s Viewpoint",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2020/09/ORV03.png",
          "chapters": ["Chapter 161", "Chapter 160", "Chapter 159"],
          "chapters_links": [
            "https://www.asurascans.com/omniscient-readers-viewpoint-chapter-161/",
            "https://www.asurascans.com/omniscient-readers-viewpoint-chapter-160/",
            "https://www.asurascans.com/omniscient-readers-viewpoint-chapter-159/"
          ]
        },
        {
          "title": "Life of a Magic Academy Mage",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2022/11/magicAcademyMageCover02.png",
          "chapters": ["Chapter 44", "Chapter 43", "Chapter 42"],
          "chapters_links": [
            "https://www.asurascans.com/life-of-a-magic-academy-mage-chapter-44/",
            "https://www.asurascans.com/life-of-a-magic-academy-mage-chapter-43/",
            "https://www.asurascans.com/life-of-a-magic-academy-mage-chapter-42/"
          ]
        },
        {
          "title": "Chronicles Of The Martial God\u2019s Return",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2022/05/martialreturnCover02.png",
          "chapters": ["Chapter 53", "Chapter 52", "Chapter 51"],
          "chapters_links": [
            "https://www.asurascans.com/chronicles-of-the-martial-gods-return-chapter-53/",
            "https://www.asurascans.com/chronicles-of-the-martial-gods-return-chapter-52/",
            "https://www.asurascans.com/chronicles-of-the-martial-gods-return-chapter-51/"
          ]
        },
        {
          "title": "The World After The End",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2022/02/the-world-after-the-end-cover.jpg",
          "chapters": ["Chapter 77", "Chapter 76", "Chapter 75"],
          "chapters_links": [
            "https://www.asurascans.com/the-world-after-the-end-chapter-77/",
            "https://www.asurascans.com/the-world-after-the-end-chapter-76/",
            "https://www.asurascans.com/the-world-after-the-end-chapter-75/"
          ]
        },
        {
          "title": "The S-Classes That I Raised",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2021/11/thesclassesthatiraisedcover.jpg",
          "chapters": ["Chapter 89", "Chapter 88", "Chapter 87"],
          "chapters_links": [
            "https://www.asurascans.com/the-s-classes-that-i-raised-chapter-89/",
            "https://www.asurascans.com/the-s-classes-that-i-raised-chapter-88/",
            "https://www.asurascans.com/the-s-classes-that-i-raised-chapter-87/"
          ]
        },
        {
          "title": "Legendary Ranker\u2019s Comeback",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2023/04/LegendaryRankerComebackCover02.png",
          "chapters": ["Chapter 22", "Chapter 21", "Chapter 20"],
          "chapters_links": [
            "https://www.asurascans.com/legendary-rankers-comeback-chapter-22/",
            "https://www.asurascans.com/legendary-rankers-comeback-chapter-21/",
            "https://www.asurascans.com/legendary-rankers-comeback-chapter-20/"
          ]
        },
        {
          "title": "Genius of the Unique Lineage",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2022/08/geniusLineageCover01.png",
          "chapters": ["Chapter 49", "Chapter 48", "Chapter 47"],
          "chapters_links": [
            "https://www.asurascans.com/genius-of-the-unique-lineage-chapter-49/",
            "https://www.asurascans.com/genius-of-the-unique-lineage-chapter-48/",
            "https://www.asurascans.com/genius-of-the-unique-lineage-chapter-47/"
          ]
        },
        {
          "title": "Solo Max-Level Newbie",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2021/07/solomaxlevelnewbie.jpg",
          "chapters": [
            "Chapter 103 - Horn that Brings Despair (1)",
            "Chapter 102 - Ghostly Blood Leader Yeom Ho",
            "Chapter 101 - Mad for Pleasure and Fighting"
          ],
          "chapters_links": [
            "https://www.asurascans.com/solo-max-level-newbie-chapter-103-horn-that-brings-despair-1/",
            "https://www.asurascans.com/solo-max-level-newbie-chapter-102-ghostly-blood-leader-yeom-ho/",
            "https://www.asurascans.com/solo-max-level-newbie-chapter-101-mad-for-pleasure-and-fighting/"
          ]
        },
        {
          "title": "The Novel\u2019s Extra (Remake)",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2022/06/novelextraCover02.png",
          "chapters": ["Chapter 60", "Chapter 59", "Chapter 58"],
          "chapters_links": [
            "https://www.asurascans.com/the-novels-extra-chapter-60/",
            "https://www.asurascans.com/the-novels-extra-chapter-59/",
            "https://www.asurascans.com/the-novels-extra-chapter-58/"
          ]
        },
        {
          "title": "Return Of The Shattered Constellation",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2021/11/00-cover.jpg",
          "chapters": ["Chapter 71", "Chapter 70", "Chapter 69"],
          "chapters_links": [
            "https://www.asurascans.com/return-of-the-shattered-constellation-chapter-71/",
            "https://www.asurascans.com/return-of-the-shattered-constellation-chapter-70/",
            "https://www.asurascans.com/return-of-the-shattered-constellation-chapter-69/"
          ]
        }
      ]
    },
    {
      "website": "Flame",
      "manhwa_data": [
        {
          "title": "In the Night Consumed by Blades, I Walk",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2022/06/cover-242x350.png",
          "chapters": ["Chapter 63", "Chapter 62", "Chapter 61"],
          "chapters_links": [
            "https://flamescans.org/in-the-night-consumed-by-blades-i-walk-chapter-63/",
            "https://flamescans.org/1686045662-in-the-night-consumed-by-blades-i-walk-chapter-62/",
            "https://flamescans.org/1686045662-in-the-night-consumed-by-blades-i-walk-chapter-61/"
          ]
        },
        {
          "title": "Omniscient Reader\u2019s Viewpoint",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2021/01/ORV-NEW-COVER2.webp",
          "chapters": ["Chapter 161", "Chapter 160", "Chapter 159"],
          "chapters_links": [
            "https://flamescans.org/omniscient-readers-viewpoint-chapter-161/",
            "https://flamescans.org/1686045662-omniscient-readers-viewpoint-chapter-160/",
            "https://flamescans.org/1686045662-omniscient-readers-viewpoint-chapter-159/"
          ]
        },
        {
          "title": "Dungeon Reset",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2021/04/DRS3cover.png",
          "chapters": ["Chapter 156", "Chapter 155", "Chapter 154"],
          "chapters_links": [
            "https://flamescans.org/dungeon-reset-chapter-156/",
            "https://flamescans.org/1686045662-dungeon-reset-chapter-155/",
            "https://flamescans.org/1686045662-dungeon-reset-chapter-154/"
          ]
        },
        {
          "title": "I\u2019ll be Taking a Break for Personal Reasons",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2022/10/Cleaned.png",
          "chapters": ["Chapter 53", "Chapter 52", "Chapter 51"],
          "chapters_links": [
            "https://flamescans.org/1686045662-ill-be-taking-a-break-for-personal-reasons-chapter-53/",
            "https://flamescans.org/1686045662-ill-be-taking-a-break-for-personal-reasons-chapter-52/",
            "https://flamescans.org/1686045662-ill-be-taking-a-break-for-personal-reasons-chapter-51/"
          ]
        },
        {
          "title": "Moon-Shadow Sword Emperor",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2023/01/CoverMSSE.png",
          "chapters": ["Chapter 37", "Chapter 36", "Chapter 35"],
          "chapters_links": [
            "https://flamescans.org/1686045662-moon-shadow-sword-emperor-chapter-37/",
            "https://flamescans.org/1686045662-moon-shadow-sword-emperor-chapter-36/",
            "https://flamescans.org/1686045662-moon-shadow-sword-emperor-chapter-35/"
          ]
        },
        {
          "title": "Hero, Returns",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2022/02/The-Hero-Returns_clean.png",
          "chapters": ["Chapter 62", "Chapter 61", "Chapter 60"],
          "chapters_links": [
            "https://flamescans.org/1686045662-hero-returns-chapter-62/",
            "https://flamescans.org/1686045662-hero-returns-chapter-61/",
            "https://flamescans.org/1686045662-hero-returns-chapter-60/"
          ]
        },
        {
          "title": "The Novel\u2019s Extra (Remake)",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2022/02/Cover.png",
          "chapters": ["Chapter 60", "Chapter 59", "Chapter 58"],
          "chapters_links": [
            "https://flamescans.org/1686045662-the-novels-extra-remake-chapter-60/",
            "https://flamescans.org/1686045662-the-novels-extra-remake-chapter-59/",
            "https://flamescans.org/1686045662-the-novels-extra-remake-chapter-58/"
          ]
        },
        {
          "title": "Return of the Broken Constellation",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2021/11/BCS-Cover.png",
          "chapters": ["Chapter 71", "Chapter 70", "Chapter 69"],
          "chapters_links": [
            "https://flamescans.org/1686045662-return-of-the-broken-constellation-chapter-71/",
            "https://flamescans.org/1686045662-return-of-the-broken-constellation-chapter-70/",
            "https://flamescans.org/1686045662-return-of-the-broken-constellation-chapter-69/"
          ]
        },
        {
          "title": "BJ Archmage",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2022/01/BJA.png",
          "chapters": ["Chapter 69", "Chapter 68", "Chapter 67"],
          "chapters_links": [
            "https://flamescans.org/1686045662-bj-archmage-chapter-69/",
            "https://flamescans.org/1686045662-bj-archmage-chapter-68/",
            "https://flamescans.org/1686045662-bj-archmage-chapter-67/"
          ]
        },
        {
          "title": "Solo Necromancy",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2021/09/3.3MB-SN-Updated-2-WEBP-1.webp",
          "chapters": ["Chapter 94", "Chapter 93", "Chapter 92"],
          "chapters_links": [
            "https://flamescans.org/1686045662-solo-necromancy-chapter-94/",
            "https://flamescans.org/1686045662-solo-necromancy-chapter-93/",
            "https://flamescans.org/1686045662-solo-necromancy-chapter-92/"
          ]
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Color(0xFF222222),
        title: Text(
          'Manhwas',
          style: GoogleFonts.overpass(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.36, // Specify a height for the InfiniteCarousel
              child: InfiniteCarousel(),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 1,
              color: Color(0xFF464646),
              margin: EdgeInsets.symmetric(
                vertical: 8.0,
              ),
            ),
            ManhwaListWidget(data: manhwaData),
          ],
        ),
      ),
    );
  }
}
