import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:manhwa_alert/layers/manhwa_list_widget.dart';

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

  List<Map<String, dynamic>> manhwaData = [
    {
      "website": "Asura",
      "manhwa_data": [
        {
          "title": "Chronicles of the Demon Faction",
          "chapters": ["Chapter 19", "Chapter 18", "Chapter 17"],
          "chapters_links": [
            "https://www.asurascans.com/chronicles-of-the-demon-faction-chapter-19/",
            "https://www.asurascans.com/chronicles-of-the-demon-faction-chapter-18/",
            "https://www.asurascans.com/chronicles-of-the-demon-faction-chapter-17/"
          ]
        },
        {
          "title": "I Regressed to My Ruined Family",
          "chapters": ["Chapter 48 { S1 END }", "Chapter 47", "Chapter 46"],
          "chapters_links": [
            "https://www.asurascans.com/i-regressed-to-my-ruined-family-chapter-48-s1-end/",
            "https://www.asurascans.com/i-regressed-to-my-ruined-family-chapter-47/",
            "https://www.asurascans.com/i-regressed-to-my-ruined-family-chapter-46/"
          ]
        },
        {
          "title": "I Returned as an FFF-Class Witch Doctor",
          "chapters": ["Chapter 25", "Chapter 24", "Chapter 23"],
          "chapters_links": [
            "https://www.asurascans.com/i-returned-as-an-fff-class-witch-doctor-chapter-25/",
            "https://www.asurascans.com/i-returned-as-an-fff-class-witch-doctor-chapter-24/",
            "https://www.asurascans.com/i-returned-as-an-fff-class-witch-doctor-chapter-23/"
          ]
        },
        {
          "title": "Heavenly Demon Instructor",
          "chapters": ["Chapter 98", "Chapter 97", "Chapter 96"],
          "chapters_links": [
            "https://www.asurascans.com/heavenly-demon-instructor-chapter-98/",
            "https://www.asurascans.com/heavenly-demon-instructor-chapter-97/",
            "https://www.asurascans.com/heavenly-demon-instructor-chapter-96/"
          ]
        },
        {
          "title": "I Grow Stronger By Eating!",
          "chapters": ["Chapter 97", "Chapter 96", "Chapter 95"],
          "chapters_links": [
            "https://www.asurascans.com/i-grow-stronger-by-eating-chapter-97/",
            "https://www.asurascans.com/i-grow-stronger-by-eating-chapter-96/",
            "https://www.asurascans.com/i-grow-stronger-by-eating-chapter-95/"
          ]
        },
        {
          "title": "Return of The Unrivaled Spear Knight",
          "chapters": ["Chapter 97", "Chapter 96", "Chapter 95"],
          "chapters_links": [
            "https://www.asurascans.com/return-of-the-unrivaled-spear-knight-chapter-97/",
            "https://www.asurascans.com/return-of-the-unrivaled-spear-knight-chapter-96/",
            "https://www.asurascans.com/return-of-the-unrivaled-spear-knight-chapter-95/"
          ]
        },
        {
          "title": "F-Class Destiny Hunter",
          "chapters": ["Chapter 25", "Chapter 24", "Chapter 23"],
          "chapters_links": [
            "https://www.asurascans.com/f-class-destiny-hunter-chapter-25/",
            "https://www.asurascans.com/f-class-destiny-hunter-chapter-24/",
            "https://www.asurascans.com/f-class-destiny-hunter-chapter-23/"
          ]
        },
        {
          "title": "Worn and Torn Newbie",
          "chapters": ["Chapter 146", "Chapter 145", "Chapter 144"],
          "chapters_links": [
            "https://www.asurascans.com/worn-and-torn-newbie-chapter-146/",
            "https://www.asurascans.com/worn-and-torn-newbie-chapter-145/",
            "https://www.asurascans.com/worn-and-torn-newbie-chapter-144/"
          ]
        },
        {
          "title": "Reincarnated Escort Warrior",
          "chapters": ["Chapter 48", "Chapter 47", "Chapter 46"],
          "chapters_links": [
            "https://www.asurascans.com/reincarnated-escort-warrior-chapter-48/",
            "https://www.asurascans.com/reincarnated-escort-warrior-chapter-47/",
            "https://www.asurascans.com/reincarnated-escort-warrior-chapter-46/"
          ]
        },
        {
          "title": "Sleeping Ranker",
          "chapters": ["Chapter 71", "Chapter 70", "Chapter 69"],
          "chapters_links": [
            "https://www.asurascans.com/sleeping-ranker-chapter-71/",
            "https://www.asurascans.com/sleeping-ranker-chapter-70/",
            "https://www.asurascans.com/sleeping-ranker-chapter-69/"
          ]
        }
      ]
    },
    {
      "website": "Flame",
      "manhwa_data": [
        {
          "title": "BJ Archmage",
          "chapters": ["Chapter 69", "Chapter 68", "Chapter 67"],
          "chapters_links": [
            "https://flamescans.org/1685959262-bj-archmage-chapter-69/",
            "https://flamescans.org/1685959262-bj-archmage-chapter-68/",
            "https://flamescans.org/1685959262-bj-archmage-chapter-67/"
          ]
        },
        {
          "title": "Solo Necromancy",
          "chapters": ["Chapter 94", "Chapter 93", "Chapter 92"],
          "chapters_links": [
            "https://flamescans.org/1685959262-solo-necromancy-chapter-94/",
            "https://flamescans.org/1685959262-solo-necromancy-chapter-93/",
            "https://flamescans.org/1685959262-solo-necromancy-chapter-92/"
          ]
        },
        {
          "title": "Heavenly Demon Cultivation Simulation",
          "chapters": ["Chapter 81", "Chapter 80", "Chapter 79"],
          "chapters_links": [
            "https://flamescans.org/1685959262-heavenly-demon-cultivation-simulation-chapter-81/",
            "https://flamescans.org/1685959262-heavenly-demon-cultivation-simulation-chapter-80/",
            "https://flamescans.org/1685959262-heavenly-demon-cultivation-simulation-chapter-79/"
          ]
        },
        {
          "title": "Youngest Son of the Renowned Swordsmanship Clan",
          "chapters": ["Chapter 75", "Chapter 74", "Chapter 73"],
          "chapters_links": [
            "https://flamescans.org/1685959262-youngest-son-of-the-renowned-swordsmanship-clan-chapter-75/",
            "https://flamescans.org/1685959262-youngest-son-of-the-renowned-swordsmanship-clan-chapter-74/",
            "https://flamescans.org/1685959262-youngest-son-of-the-renowned-swordsmanship-clan-chapter-73/"
          ]
        },
        {
          "title": "Reincarnation of the Murim Clan\u2019s Former Ranker",
          "chapters": ["Chapter 86", "Chapter 85", "Chapter 84"],
          "chapters_links": [
            "https://flamescans.org/1685959262-reincarnation-of-the-murim-clans-former-ranker-chapter-86/",
            "https://flamescans.org/1685959262-reincarnation-of-the-murim-clans-former-ranker-chapter-85/",
            "https://flamescans.org/1685959262-reincarnation-of-the-murim-clans-former-ranker-chapter-84/"
          ]
        },
        {
          "title": "My Wife Is Actually The Empress?",
          "chapters": ["Chapter 111", "Chapter 110", "Chapter 109"],
          "chapters_links": [
            "https://flamescans.org/1685959262-my-wife-is-actually-the-empress-chapter-111/",
            "https://flamescans.org/1685959262-my-wife-is-actually-the-empress-chapter-110/",
            "https://flamescans.org/1685959262-my-wife-is-actually-the-empress-chapter-109/"
          ]
        },
        {
          "title": "To Not Die",
          "chapters": ["Chapter 87", "Chapter 86", "Chapter 85"],
          "chapters_links": [
            "https://flamescans.org/1685959262-to-not-die-chapter-87/",
            "https://flamescans.org/1685959262-to-not-die-chapter-86/",
            "https://flamescans.org/1685959262-to-not-die-chapter-85/"
          ]
        },
        {
          "title": "One Step for the Dark Lord",
          "chapters": ["Chapter 69", "Chapter 68", "Chapter 67"],
          "chapters_links": [
            "https://flamescans.org/1685959262-one-step-for-the-dark-lord-chapter-69/",
            "https://flamescans.org/1685959262-one-step-for-the-dark-lord-chapter-68/",
            "https://flamescans.org/1685959262-one-step-for-the-dark-lord-chapter-67/"
          ]
        },
        {
          "title": "Is This Hero for Real?",
          "chapters": ["Chapter 78", "Chapter 77", "Chapter 76"],
          "chapters_links": [
            "https://flamescans.org/1685959262-is-this-hero-for-real-chapter-78/",
            "https://flamescans.org/1685959262-is-this-hero-for-real-chapter-77/",
            "https://flamescans.org/1685959262-is-this-hero-for-real-chapter-76/"
          ]
        },
        {
          "title": "I Used to be a Boss",
          "chapters": ["Chapter 31", "Chapter 30", "Chapter 29"],
          "chapters_links": [
            "https://flamescans.org/1685959262-i-used-to-be-a-boss-chapter-31/",
            "https://flamescans.org/1685959262-i-used-to-be-a-boss-chapter-30/",
            "https://flamescans.org/1685959262-i-used-to-be-a-boss-chapter-29/"
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
        title: const Text('Manhwas'),
      ),
      body: ManhwaListWidget(manhwaData),
    );
  }
}
