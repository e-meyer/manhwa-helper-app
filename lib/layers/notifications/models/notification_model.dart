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
