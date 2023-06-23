import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manhwa_alert/layers/notifications/controller/notification_service.dart';
import 'package:manhwa_alert/core/injector/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManhwaAlertDialog extends StatelessWidget {
  final Map<String, String> webtoon;
  final FirebaseMessaging fcm = serviceLocator.get<FirebaseMessaging>();
  final NotificationService service = serviceLocator.get<NotificationService>();
  final FirebaseFirestore _db = serviceLocator.get<FirebaseFirestore>();

  ManhwaAlertDialog({
    super.key,
    required this.webtoon,
  });

  Future<String> saveSubscribedTopicLocal(String topic) async {
    final SharedPreferences sp = serviceLocator.get<SharedPreferences>();
    final String formattedTopic = 'topic_$topic';
    final String timestamp = DateTime.now().toIso8601String();
    if (!sp.containsKey(formattedTopic)) {
      await sp.setString(formattedTopic, DateTime.now().toIso8601String());
      service.subscribedTopics.value[topic] = timestamp;
    }
    return timestamp;
  }

  Future<void> removeSubscribedTopicLocal(String topic) async {
    final SharedPreferences sp = serviceLocator.get<SharedPreferences>();
    final String formattedTopic = 'topic_$topic';
    await sp.remove(formattedTopic);
    service.subscribedTopics.value.remove(topic);
  }

  void _subscribeToTopic(String manhwaTitle) async {
    final String topic = manhwaTitle
        .trim()
        .replaceAll('`', '')
        .replaceAll('’', '')
        .replaceAll(',', '')
        .replaceAll('\'', '')
        .replaceAll('!', '')
        .split(' ')
        .join('_')
        .toLowerCase();
    fcm.subscribeToTopic(topic);
    await saveSubscribedTopicLocal(topic);
    service.addNewListener(topic);
  }

  void _unsubscribeFromTopic(String manhwaTitle) async {
    final String topic = manhwaTitle
        .trim()
        .replaceAll('`', '')
        .replaceAll('’', '')
        .replaceAll(',', '')
        .replaceAll('\'', '')
        .replaceAll('!', '')
        .split(' ')
        .join('_')
        .toLowerCase();
    fcm.unsubscribeFromTopic(topic);
    await removeSubscribedTopicLocal(topic);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        // height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          color: Color(0xFF222222),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.network(
                  webtoon['cover']!,
                  height: 400,
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
              child: Text(
                webtoon['title']!,
                style: GoogleFonts.overpass(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            if (int.parse(webtoon['chapterNumber']!) > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                child: Text(
                  '${webtoon['chapterNumber']!} chapters',
                  style: GoogleFonts.overpass(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: () => _subscribeToTopic(webtoon['title']!),
              child: Text(
                service.subscribedTopics.value.keys.contains(webtoon['title']!
                        .trim()
                        .replaceAll('`', '')
                        .replaceAll('’', '')
                        .replaceAll(',', '')
                        .replaceAll('\'', '')
                        .replaceAll('!', '')
                        .split(' ')
                        .join('_')
                        .toLowerCase())
                    ? 'Unsubscribe'
                    : 'Subscribe',
                style: GoogleFonts.overpass(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => _unsubscribeFromTopic(webtoon['title']!),
              child: Text(
                'Unsubscribe',
                style: GoogleFonts.overpass(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
