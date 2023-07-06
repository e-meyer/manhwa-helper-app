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
      'manhwa_title': manhwaTitle,
      'chapter_number': chapterNumber,
      'cover_url': coverUrl,
      'chapter_url': chapterUrl,
      'notification_timestamp': notificationTimestamp.toIso8601String().replaceAll('Z', ''),
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      manhwaTitle: map['manhwa_title'] as String,
      chapterNumber: map['chapter_number'] as String,
      coverUrl: map['cover_url'] as String,
      chapterUrl: map['chapter_url'] as String,
      notificationTimestamp:
          DateTime.parse(map['notification_timestamp'] as String),
      isRead: map['isRead'] != null ? map['isRead'] as bool : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
