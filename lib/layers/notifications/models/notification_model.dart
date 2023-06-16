class NotificationModel {
  final String title;
  final String trailingImageLink;
  final DateTime date;
  final String subtitle;
  final bool isRead;

  NotificationModel({
    required this.title,
    required this.trailingImageLink,
    required this.date,
    required this.subtitle,
    required this.isRead,
  });
}

getNotifications() {
  return notifications;
}

List<NotificationModel> notifications = [
  NotificationModel(
    title: "Omniscient Reader\u2019s Viewpoint",
    trailingImageLink:
        "https://www.asurascans.com/wp-content/uploads/2020/09/ORV03.png",
    date: DateTime.now().subtract(Duration(hours: 2)),
    subtitle: 'Chapter 3',
    isRead: false,
  ),
  NotificationModel(
    title: "Life of a Magic Academy Mage",
    trailingImageLink:
        "https://www.asurascans.com/wp-content/uploads/2022/11/magicAcademyMageCover02.png",
    date: DateTime.now().subtract(Duration(days: 3)),
    subtitle: 'Chapter 7',
    isRead: false,
  ),
  NotificationModel(
    title: "Chronicles Of The Martial God\u2019s Return",
    trailingImageLink:
        "https://www.asurascans.com/wp-content/uploads/2022/05/martialreturnCover02.png",
    date: DateTime.now().subtract(Duration(minutes: 30)),
    subtitle: 'Chapter 2',
    isRead: false,
  ),
  NotificationModel(
    title: "The World After The End",
    trailingImageLink:
        "https://www.asurascans.com/wp-content/uploads/2022/02/the-world-after-the-end-cover.jpg",
    date: DateTime.now().subtract(Duration(days: 1, hours: 5)),
    subtitle: 'Chapter 4',
    isRead: true,
  ),
  NotificationModel(
    title: "The S-Classes That I Raised",
    trailingImageLink:
        "https://www.asurascans.com/wp-content/uploads/2021/11/thesclassesthatiraisedcover.jpg",
    date: DateTime.now().subtract(Duration(days: 2, hours: 12)),
    subtitle: 'Chapter 9',
    isRead: false,
  ),
  NotificationModel(
    title: "Legendary Ranker\u2019s Comeback",
    trailingImageLink:
        "https://www.asurascans.com/wp-content/uploads/2023/04/LegendaryRankerComebackCover02.png",
    date: DateTime.now().subtract(Duration(hours: 3)),
    subtitle: 'Chapter 6',
    isRead: true,
  ),
  NotificationModel(
    title: "Genius of the Unique Lineage",
    trailingImageLink:
        "https://www.asurascans.com/wp-content/uploads/2022/08/geniusLineageCover01.png",
    date: DateTime.now().subtract(Duration(days: 5)),
    subtitle: 'Chapter 10',
    isRead: false,
  ),
  NotificationModel(
    title: 'Meeting Reminder',
    trailingImageLink:
        "https://www.asurascans.com/wp-content/uploads/2021/07/solomaxlevelnewbie.jpg",
    date: DateTime.now().subtract(Duration(days: 1, hours: 1)),
    subtitle: 'Chapter 8',
    isRead: false,
  ),
  NotificationModel(
    title: 'Notification 7',
    trailingImageLink:
        "https://www.asurascans.com/wp-content/uploads/2021/11/00-cover.jpg",
    date: DateTime.now().subtract(Duration(days: 4)),
    subtitle: 'Chapter 11',
    isRead: true,
  ),
];
