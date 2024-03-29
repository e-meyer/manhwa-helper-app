import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:manhwa_alert/core/injector/service_locator.dart';
import 'package:manhwa_alert/layers/home/view/widgets/infinite_carousel.dart';
import 'package:manhwa_alert/layers/home/view/widgets/manhwa_list_widget.dart';
import 'package:manhwa_alert/layers/notifications/controller/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
// {
//       "website": "Luminous",
//       "manhwa_data": [
//         {
//           "title": "I Became the Despised Granddaughter of the Murim Family",
//           "cover_link":
//               "https://luminousscans.com/wp-content/uploads/2023/02/resource-210x300.jpg",
//           "chapters": ["Chapter 41", "Chapter 40", "Chapter 39"],
//           "chapters_links": [
//             "https://luminousscans.com/i-became-the-despised-granddaughter-of-the-murim-family-chapter-41/",
//             "https://luminousscans.com/i-became-the-despised-granddaughter-of-the-murim-family-chapter-40/",
//             "https://luminousscans.com/i-became-the-despised-granddaughter-of-the-murim-family-chapter-39/"
//           ]
//         },
//         {
//           "title": "Legend of the Northern Blade",
//           "cover_link":
//               "https://luminousscans.com/wp-content/uploads/2021/07/LONBAnimGif1-212x300.gif",
//           "chapters": ["Chapter 160", "Chapter 159", "Chapter 158"],
//           "chapters_links": [
//             "https://luminousscans.com/legend-of-the-northern-blade-chapter-160/",
//             "https://luminousscans.com/legend-of-the-northern-blade-chapter-159/",
//             "https://luminousscans.com/legend-of-the-northern-blade-chapter-158/"
//           ]
//         },
//         {
//           "title": "I Stole The Number One Ranker\u2019s Soul",
//           "cover_link":
//               "https://luminousscans.com/wp-content/uploads/2022/09/resource-210x300.png",
//           "chapters": ["Chapter 50", "Chapter 49", "Chapter 48"],
//           "chapters_links": [
//             "https://luminousscans.com/i-stole-the-number-one-rankers-soul-chapter-50/",
//             "https://luminousscans.com/i-stole-the-number-one-rankers-soul-chapter-49/",
//             "https://luminousscans.com/i-stole-the-number-one-rankers-soul-chapter-48/"
//           ]
//         },
//         {
//           "title": "Leveling Up with the Gods",
//           "cover_link":
//               "https://luminousscans.com/wp-content/uploads/2021/07/COVER-LWG-copy-222x300.png",
//           "chapters": ["Chapter 80", "Chapter 79.5", "Chapter 79"],
//           "chapters_links": [
//             "https://luminousscans.com/leveling-up-with-the-gods-chapter-80/",
//             "https://luminousscans.com/leveling-up-with-the-gods-chapter-79-5/",
//             "https://luminousscans.com/leveling-up-with-the-gods-chapter-79/"
//           ]
//         },
//         {
//           "title": "Mercenary Enrollment",
//           "cover_link":
//               "https://luminousscans.com/wp-content/uploads/2022/02/690x100_cover-207x300.jpg",
//           "chapters": ["Chapter 139", "Chapter 138", "Chapter 137"],
//           "chapters_links": [
//             "https://luminousscans.com/mercenary-enrollment-chapter-139/",
//             "https://luminousscans.com/mercenary-enrollment-chapter-138/",
//             "https://luminousscans.com/mercenary-enrollment-chapter-137/"
//           ]
//         },
//         {
//           "title": "My Dad Is Too Strong",
//           "cover_link":
//               "https://luminousscans.com/wp-content/uploads/2021/08/DAD_TOO_STRONK_copy-222x300.png",
//           "chapters": ["Chapter 130", "Chapter 129", "Chapter 128"],
//           "chapters_links": [
//             "https://luminousscans.com/my-dad-is-too-strong-chapter-130/",
//             "https://luminousscans.com/my-dad-is-too-strong-chapter-129/",
//             "https://luminousscans.com/my-dad-is-too-strong-chapter-128/"
//           ]
//         },
//         {
//           "title": "The Chronicles of Heavenly Demon",
//           "cover_link":
//               "https://luminousscans.com/wp-content/uploads/2021/05/chroCover02-222x300.png",
//           "chapters": ["Chapter 211", "Chapter 210", "Chapter 209"],
//           "chapters_links": [
//             "https://luminousscans.com/the-chronicles-of-heavenly-demon-chapter-211/",
//             "https://luminousscans.com/the-chronicles-of-heavenly-demon-chapter-210/",
//             "https://luminousscans.com/the-chronicles-of-heavenly-demon-chapter-209/"
//           ]
//         },
//         {
//           "title": "Wind Breaker",
//           "cover_link":
//               "https://luminousscans.com/wp-content/uploads/2021/08/image-208x300.jpeg",
//           "chapters": ["Chapter 447", "Chapter 446", "Chapter 445"],
//           "chapters_links": [
//             "https://luminousscans.com/wind-breaker-chapter-447/",
//             "https://luminousscans.com/wind-breaker-chapter-446/",
//             "https://luminousscans.com/wind-breaker-chapter-445/"
//           ]
//         },
//         {
//           "title": "Skeleton Soldier Couldn\u2019t Protect the Dungeon",
//           "cover_link":
//               "https://luminousscans.com/wp-content/uploads/2022/06/resource-210x300.jpg",
//           "chapters": ["Chapter 239", "Chapter 238", "Chapter 237"],
//           "chapters_links": [
//             "https://luminousscans.com/skeleton-soldier-couldnt-protect-the-dungeon-chapter-239/",
//             "https://luminousscans.com/skeleton-soldier-couldnt-protect-the-dungeon-chapter-238/",
//             "https://luminousscans.com/skeleton-soldier-couldnt-protect-the-dungeon-chapter-237/"
//           ]
//         },
//         {
//           "title": "FFF-Class Trash Hero",
//           "cover_link":
//               "https://luminousscans.com/wp-content/uploads/2021/06/FFF-Class-Trash-Hero-Cover-copy-1-222x300.jpg",
//           "chapters": ["Chapter 153", "Chapter 152", "Chapter 151"],
//           "chapters_links": [
//             "https://luminousscans.com/fff-class-trash-hero-chapter-153/",
//             "https://luminousscans.com/fff-class-trash-hero-chapter-152/",
//             "https://luminousscans.com/fff-class-trash-hero-chapter-151/"
//           ]
//         }
//       ]
//     },

  List<Map<String, dynamic>> manhwaData = [
    {
      "website": "Asura",
      "manhwa_data": [
        {
          "title": "The Hero Returns",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2022/03/theheroreturnsCover02.png",
          "chapters": ["Chapter 64", "Chapter 63", "Chapter 62"],
          "chapters_links": [
            "https://www.asurascans.com/the-hero-returns-chapter-64/",
            "https://www.asurascans.com/the-hero-returns-chapter-63/",
            "https://www.asurascans.com/the-hero-returns-chapter-62/"
          ]
        },
        {
          "title": "Swordmaster\u2019s Youngest Son",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2022/04/swordmastersyoungestCover02.png",
          "chapters": ["Chapter 77", "Chapter 76", "Chapter 75"],
          "chapters_links": [
            "https://www.asurascans.com/swordmasters-youngest-son-chapter-77/",
            "https://www.asurascans.com/swordmasters-youngest-son-chapter-76/",
            "https://www.asurascans.com/swordmasters-youngest-son-chapter-75/"
          ]
        },
        {
          "title": "Everyone Else is A Returnee",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2023/01/EveryoneReturneeCover01.png",
          "chapters": ["Chapter 38", "Chapter 37", "Chapter 36"],
          "chapters_links": [
            "https://www.asurascans.com/everyone-else-is-a-returnee-chapter-38/",
            "https://www.asurascans.com/everyone-else-is-a-returnee-chapter-37/",
            "https://www.asurascans.com/everyone-else-is-a-returnee-chapter-36/"
          ]
        },
        {
          "title": "I\u2019ll Be Taking A Break For Personal Reasons",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2022/10/takingaBreakCover01.png",
          "chapters": ["Chapter 55", "Chapter 54", "Chapter 53"],
          "chapters_links": [
            "https://www.asurascans.com/ill-be-taking-a-break-for-personal-reasons-chapter-55/",
            "https://www.asurascans.com/ill-be-taking-a-break-for-personal-reasons-chapter-54/",
            "https://www.asurascans.com/ill-be-taking-a-break-for-personal-reasons-chapter-53/"
          ]
        },
        {
          "title": "Ending Maker",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2022/05/ending_maker_01.jpg",
          "chapters": ["Chapter 44", "Chapter 43", "Chapter 42"],
          "chapters_links": [
            "https://www.asurascans.com/ending-maker-chapter-44/",
            "https://www.asurascans.com/ending-maker-chapter-43/",
            "https://www.asurascans.com/ending-maker-chapter-42/"
          ]
        },
        {
          "title": "The Player Hides His Past",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2023/06/Fyvv2iyaIAEsfNc.jpg",
          "chapters": ["Chapter 4", "Chapter 3", "Chapter 2"],
          "chapters_links": [
            "https://www.asurascans.com/the-player-hides-his-past-chapter-4/",
            "https://www.asurascans.com/the-player-hides-his-past-chapter-3/",
            "https://www.asurascans.com/the-player-hides-his-past-chapter-2/"
          ]
        },
        {
          "title": "Return of the SSS-Class Ranker",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2022/08/ReturnSSSCover01.png",
          "chapters": ["Chapter 63", "Chapter 62", "Chapter 61"],
          "chapters_links": [
            "https://www.asurascans.com/return-of-the-sss-class-ranker-chapter-63/",
            "https://www.asurascans.com/return-of-the-sss-class-ranker-chapter-62/",
            "https://www.asurascans.com/return-of-the-sss-class-ranker-chapter-61/"
          ]
        },
        {
          "title": "The Knight King Who Returned with a God",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2023/05/theknightkingCover01.png",
          "chapters": ["Chapter 9", "Chapter 8", "Chapter 7"],
          "chapters_links": [
            "https://www.asurascans.com/the-knight-king-who-returned-with-a-god-chapter-9/",
            "https://www.asurascans.com/the-knight-king-who-returned-with-a-god-chapter-8/",
            "https://www.asurascans.com/the-knight-king-who-returned-with-a-god-chapter-7/"
          ]
        },
        {
          "title": "The Greatest Estate Developer",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2022/09/EstateDevCover01.png",
          "chapters": ["Chapter 104", "Chapter 103", "Chapter 102"],
          "chapters_links": [
            "https://www.asurascans.com/the-greatest-estate-developer-chapter-104/",
            "https://www.asurascans.com/the-greatest-estate-developer-chapter-103/",
            "https://www.asurascans.com/the-greatest-estate-developer-chapter-102/"
          ]
        },
        {
          "title": "To Hell With Being A Saint, I\u2019m A Doctor",
          "cover_link":
              "https://www.asurascans.com/wp-content/uploads/2022/05/saintdoctorCover05.png",
          "chapters": ["Chapter 52", "Chapter 51", "Chapter 50"],
          "chapters_links": [
            "https://www.asurascans.com/to-hell-with-being-a-saint-im-a-doctor-chapter-52/",
            "https://www.asurascans.com/to-hell-with-being-a-saint-im-a-doctor-chapter-51/",
            "https://www.asurascans.com/to-hell-with-being-a-saint-im-a-doctor-chapter-50/"
          ]
        }
      ]
    },
    {
      "website": "Flame",
      "manhwa_data": [
        {
          "title": "Hero, Returns",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2022/02/The-Hero-Returns_clean.png",
          "chapters": ["Chapter 64", "Chapter 63", "Chapter 62"],
          "chapters_links": [
            "https://flamescans.org/hero-returns-chapter-64/",
            "https://flamescans.org/1686996061-hero-returns-chapter-63/",
            "https://flamescans.org/1686996061-hero-returns-chapter-62/"
          ]
        },
        {
          "title": "To Not Die",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2021/06/CoverUpRGBnoise_scaleLevel3width-800.png",
          "chapters": ["Chapter 89", "Chapter 88", "Chapter 87"],
          "chapters_links": [
            "https://flamescans.org/to-not-die-chapter-89/",
            "https://flamescans.org/to-not-die-chapter-88/",
            "https://flamescans.org/1686996061-to-not-die-chapter-87/"
          ]
        },
        {
          "title": "Youngest Son of the Renowned Swordsmanship Clan",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2022/04/YSC_NEW_COVER.webp",
          "chapters": ["Chapter 77", "Chapter 76", "Chapter 75"],
          "chapters_links": [
            "https://flamescans.org/youngest-son-of-the-renowned-swordsmanship-clan-chapter-77/",
            "https://flamescans.org/1686996061-youngest-son-of-the-renowned-swordsmanship-clan-chapter-76/",
            "https://flamescans.org/1686996061-youngest-son-of-the-renowned-swordsmanship-clan-chapter-75/"
          ]
        },
        {
          "title": "Hero Has Returned",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2021/10/HHRUpRGBnoise_scaleLevel2width-800.jpg",
          "chapters": ["Chapter 94", "Chapter 93", "Chapter 92"],
          "chapters_links": [
            "https://flamescans.org/1686996061-hero-has-returned-chapter-94/",
            "https://flamescans.org/1686996061-hero-has-returned-chapter-93/",
            "https://flamescans.org/1686996061-hero-has-returned-chapter-92/"
          ]
        },
        {
          "title": "SSS-Rank Lone Summoner",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2022/11/zhiyouwonengyongzhaohuanzhu-zhuloutingxiyuyuanzhumaxiaodaobianjusanhengyishugongzuoshihuizhiUpRGBnoise_scaleLevel3width-800.jpg",
          "chapters": ["Chapter 61", "Chapter 60", "Chapter 59"],
          "chapters_links": [
            "https://flamescans.org/1686996061-sss-rank-lone-summoner-chapter-61/",
            "https://flamescans.org/1686996061-sss-rank-lone-summoner-chapter-60/",
            "https://flamescans.org/1686996061-sss-rank-lone-summoner-chapter-59/"
          ]
        },
        {
          "title": "My Wife Is Actually The Empress?",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2021/02/My_Wife_is_Actually_the_Empress_-_Title_Cover_-_Barak-262x350.png",
          "chapters": ["Chapter 116", "Chapter 115", "Chapter 114"],
          "chapters_links": [
            "https://flamescans.org/1686996061-my-wife-is-actually-the-empress-chapter-116/",
            "https://flamescans.org/1686996061-my-wife-is-actually-the-empress-chapter-115/",
            "https://flamescans.org/1686996061-my-wife-is-actually-the-empress-chapter-114/"
          ]
        },
        {
          "title": "The Ancient Sovereign of Eternity",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2021/06/anceint-sovereign-of-eternity-v2-1070x1676-1-223x350.png",
          "chapters": ["Chapter 204", "Chapter 203", "Chapter 202"],
          "chapters_links": [
            "https://flamescans.org/1686996061-the-ancient-sovereign-of-eternity-chapter-204/",
            "https://flamescans.org/1686996061-the-ancient-sovereign-of-eternity-chapter-203/",
            "https://flamescans.org/1686996061-the-ancient-sovereign-of-eternity-chapter-202/"
          ]
        },
        {
          "title": "The Breaker 3 \u2013 Eternal Force",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2022/05/12A_Ai_CAo_690x1000-242x350.jpg",
          "chapters": ["Chapter 64", "Chapter 63", "Chapter 62"],
          "chapters_links": [
            "https://flamescans.org/1686996061-the-breaker-3-eternal-force-chapter-64/",
            "https://flamescans.org/1686996061-the-breaker-3-eternal-force-chapter-63/",
            "https://flamescans.org/1686996061-the-breaker-3-eternal-force-chapter-62/"
          ]
        },
        {
          "title": "Ex and Ash",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2021/11/EXACOVER-242x350.jpg",
          "chapters": ["Chapter 87", "Chapter 86", "Chapter 85"],
          "chapters_links": [
            "https://flamescans.org/1686996061-ex-and-ash-chapter-87/",
            "https://flamescans.org/1686996061-ex-and-ash-chapter-86/",
            "https://flamescans.org/1686996061-ex-and-ash-chapter-85/"
          ]
        },
        {
          "title": "Nine Heavens Swordmaster",
          "cover_link":
              "https://flamescans.org/wp-content/uploads/2022/10/NHS.png",
          "chapters": ["Chapter 53", "Chapter 52", "Chapter 51"],
          "chapters_links": [
            "https://flamescans.org/1686996061-nine-heavens-swordmaster-chapter-53/",
            "https://flamescans.org/1686996061-nine-heavens-swordmaster-chapter-52/",
            "https://flamescans.org/1686996061-nine-heavens-swordmaster-chapter-51/"
          ]
        }
      ]
    }
  ];

  final NotificationService service = serviceLocator.get<NotificationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: const Color(0xFF222222),
        title: ValueListenableBuilder(
          valueListenable: service.unseenNotificationCount,
          builder: (context, value, child) {
            return const Text(
              'Manhwas',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.36,
              child: const InfiniteCarousel(),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 1,
              color: const Color(0xFF464646),
              margin: const EdgeInsets.symmetric(
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
