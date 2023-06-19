// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationModel {
  final String manhwaTitle;
  final String chapterNumber;
  final String coverUrl;
  final String chapterUrl;
  final DateTime notificationTimestamp;
  bool isRead;

  NotificationModel({
    required this.manhwaTitle,
    required this.coverUrl,
    required this.chapterUrl,
    required this.notificationTimestamp,
    required this.chapterNumber,
    required this.isRead,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'manhwaTitle': manhwaTitle,
      'chapterNumber': chapterNumber,
      'coverUrl': coverUrl,
      'chapterUrl': chapterUrl,
      'notificationTimestamp': notificationTimestamp.millisecondsSinceEpoch,
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      manhwaTitle: map['manhwaTitle'] as String,
      chapterNumber: map['chapterNumber'] as String,
      coverUrl: map['coverUrl'] as String,
      chapterUrl: map['chapterUrl'] as String,
      notificationTimestamp: DateTime.fromMillisecondsSinceEpoch(
          map['notificationTimestamp'] as int),
      isRead: map['isRead'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

// getNotifications() {
//   return notifications;
// }

// List<NotificationModel> notifications = [
//   NotificationModel(
//     manhwaTitle: "Omniscient Reader\u2019s Viewpoint",
//     coverUrl: "https://www.asurascans.com/wp-content/uploads/2020/09/ORV03.png",
//     chapterUrl:
//         "https://www.asurascans.com/wp-content/uploads/2020/09/ORV03.png",
//     notificationTimestamp: DateTime.now().subtract(Duration(hours: 2)),
//     chapterNumber: 'Chapter 3',
//     isRead: false,
//   ),
//   NotificationModel(
//     manhwaTitle: "Life of a Magic Academy Mage",
//     coverUrl:
//         "https://www.asurascans.com/wp-content/uploads/2022/11/magicAcademyMageCover02.png",
//     chapterUrl:
//         "https://www.asurascans.com/wp-content/uploads/2020/09/ORV03.png",
//     notificationTimestamp: DateTime.now().subtract(Duration(days: 3)),
//     chapterNumber: 'Chapter 7',
//     isRead: false,
//   ),
//   NotificationModel(
//     manhwaTitle: "Chronicles Of The Martial God\u2019s Return",
//     coverUrl:
//         "https://www.asurascans.com/wp-content/uploads/2022/05/martialreturnCover02.png",
//     chapterUrl:
//         "https://www.asurascans.com/wp-content/uploads/2020/09/ORV03.png",
//     notificationTimestamp: DateTime.now().subtract(Duration(minutes: 30)),
//     chapterNumber: 'Chapter 2',
//     isRead: false,
//   ),
//   NotificationModel(
//     manhwaTitle: "The World After The End",
//     coverUrl:
//         "https://www.asurascans.com/wp-content/uploads/2022/02/the-world-after-the-end-cover.jpg",
//     chapterUrl:
//         "https://www.asurascans.com/wp-content/uploads/2020/09/ORV03.png",
//     notificationTimestamp: DateTime.now().subtract(Duration(days: 1, hours: 5)),
//     chapterNumber: 'Chapter 4',
//     isRead: true,
//   ),
//   NotificationModel(
//     manhwaTitle: "The S-Classes That I Raised",
//     coverUrl:
//         "https://www.asurascans.com/wp-content/uploads/2021/11/thesclassesthatiraisedcover.jpg",
//     chapterUrl:
//         "https://www.asurascans.com/wp-content/uploads/2020/09/ORV03.png",
//     notificationTimestamp:
//         DateTime.now().subtract(Duration(days: 2, hours: 12)),
//     chapterNumber: 'Chapter 9',
//     isRead: false,
//   ),
//   NotificationModel(
//     manhwaTitle: "Legendary Ranker\u2019s Comeback",
//     coverUrl:
//         "https://www.asurascans.com/wp-content/uploads/2023/04/LegendaryRankerComebackCover02.png",
//     chapterUrl:
//         "https://www.asurascans.com/wp-content/uploads/2020/09/ORV03.png",
//     notificationTimestamp: DateTime.now().subtract(Duration(hours: 3)),
//     chapterNumber: 'Chapter 6',
//     isRead: true,
//   ),
//   NotificationModel(
//     manhwaTitle: "Genius of the Unique Lineage",
//     coverUrl:
//         "https://www.asurascans.com/wp-content/uploads/2022/08/geniusLineageCover01.png",
//     chapterUrl:
//         "https://www.asurascans.com/wp-content/uploads/2020/09/ORV03.png",
//     notificationTimestamp: DateTime.now().subtract(Duration(days: 5)),
//     chapterNumber: 'Chapter 10',
//     isRead: false,
//   ),
//   NotificationModel(
//     manhwaTitle: 'Notification 7',
//     coverUrl:
//         "https://www.asurascans.com/wp-content/uploads/2021/11/00-cover.jpg",
//     chapterUrl:
//         "https://www.asurascans.com/wp-content/uploads/2020/09/ORV03.png",
//     notificationTimestamp: DateTime.now().subtract(Duration(days: 4)),
//     chapterNumber: 'Chapter 11',
//     isRead: true,
//   ),
// ];
