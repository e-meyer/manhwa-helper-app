import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manhwa_alert/core/injector/service_locator.dart';
import 'package:manhwa_alert/layers/notifications/models/notification_model.dart';
import 'package:manhwa_alert/layers/notifications/view/widgets/notification_section_builder.dart';
import 'package:manhwa_alert/layers/notifications/controller/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen>
    with WidgetsBindingObserver {
  final NotificationService service = serviceLocator.get<NotificationService>();
  final FirebaseFirestore _db = serviceLocator.get<FirebaseFirestore>();
  int pageSize = 10;
  DocumentSnapshot? lastDocument;
  final DateTime currentTime = DateTime.now();
  String _latestNotificationTimestamp = '';

  @override
  void initState() {
    service.loadCachedNotifications();
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    service.notifications.addListener(_updateNotifications);
    service.getLocalSubscribedTopics();
    getSnapshotData();
    listenForNewNotifications();
  }

  void _updateNotifications() {
    setState(() {});
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _listener;

  void listenForNewNotifications() {
    final Map<String, String> localTopics = service.subscribedTopics.value;

    for (final key in localTopics.keys) {
      String value = localTopics[key]!;

      // Cancel the previous listener if it exists
      if (_listener != null) {
        _listener!.cancel();
      }

      // Set up a new listener with the updated query
      _listener = _db
          .collection("notifications")
          .doc(key)
          .collection("notifications")
          .where('notification_timestamp',
              isGreaterThan: _latestNotificationTimestamp)
          .snapshots()
          .listen((querySnapshot) async {
        List<NotificationModel> newNotifications = [];

        for (var docSnapshot in querySnapshot.docs) {
          newNotifications.add(NotificationModel.fromMap(docSnapshot.data()));
          print(
              'listenForNewNotifications: ${docSnapshot.id} => ${docSnapshot.data()}');
        }
        service.addNotifications(newNotifications);
        await service.saveNotificationsToCache();
        if (newNotifications.isNotEmpty) {
          DateTime highestDate = newNotifications
              .reduce((curr, next) =>
                  curr.notificationTimestamp.isAfter(next.notificationTimestamp)
                      ? curr
                      : next)
              .notificationTimestamp;

          print("Highest date in the list: $highestDate");
          _latestNotificationTimestamp = highestDate.toIso8601String();
          await service
              .saveLatestNotificationTimestamp(_latestNotificationTimestamp);

          // Call listenForNewNotifications() again to set up a new listener with the updated query
          listenForNewNotifications();
        } else {
          await service
              .saveLatestNotificationTimestamp(_latestNotificationTimestamp);
        }
      });
    }
  }

  Future<void> getSnapshotData() async {
    final Map<String, String> localTopics = service.subscribedTopics.value;
    print('snapshot : ' + localTopics.toString());
    List<NotificationModel> newNotifications = [];

    for (final key in localTopics.keys) {
      String value = localTopics[key]!;
      Query query = _db
          .collection("notifications")
          .doc(key)
          .collection("notifications")
          .where('notification_timestamp',
              isGreaterThan: _latestNotificationTimestamp)
          .orderBy('notification_timestamp', descending: true)
          .limit(pageSize);

      if (lastDocument != null) {
        query = query.startAfter([lastDocument!['notification_timestamp']]);
      }

      QuerySnapshot querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;
        for (var docSnapshot in querySnapshot.docs) {
          newNotifications.add(NotificationModel.fromMap(
              docSnapshot.data() as Map<String, dynamic>));
          print('getSnapshotData: ${docSnapshot.id} => ${docSnapshot.data()}');
        }
      }
    }
    service.addNotifications(newNotifications);
    await service.saveNotificationsToCache();
    if (newNotifications.isNotEmpty) {
      DateTime highestDate = newNotifications
          .reduce((curr, next) =>
              curr.notificationTimestamp.isAfter(next.notificationTimestamp)
                  ? curr
                  : next)
          .notificationTimestamp;

      print("Highest date in the list: $highestDate");
      _latestNotificationTimestamp = highestDate.toIso8601String();
      _latestNotificationTimestamp = await service
          .saveLatestNotificationTimestamp(_latestNotificationTimestamp);
      return;
    }

    _latestNotificationTimestamp = await service
        .saveLatestNotificationTimestamp(_latestNotificationTimestamp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: InkWell(
              onTap: () {
                print(_latestNotificationTimestamp);
              },
              child: Icon(Icons.settings),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: ValueListenableBuilder<List<NotificationModel>>(
          valueListenable: service.notifications,
          builder: (context, value, child) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: value.length,
              itemBuilder: (context, index) {
                final notification = value[index];
                return ListTile(
                  title: Text(
                      '${notification.manhwaTitle} - ${notification.chapterNumber}'),
                );
              },
            );
          },
        ),
      ),
      // body: ListView.builder(
      //   itemCount: _notifications.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     return ListTile(
      //       title: Text(_notifications[index]['manhwa_title']),
      //       subtitle: Text(_notifications[index]['notification_timestamp']),
      //     );
      //   },
      // ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   final List<NotificationModel> newNotifications = service.notifications.value
  //       .where((notification) =>
  //           currentTime.difference(notification.notificationTimestamp).inDays <=
  //           1)
  //       .toList();

  //   final List<NotificationModel> previousNotifications = service
  //       .notifications.value
  //       .where((notification) =>
  //           currentTime.difference(notification.notificationTimestamp).inDays >
  //           1)
  //       .toList();
  //   return Scaffold(
  //     appBar: AppBar(
  //       titleSpacing: 0,
  //       shadowColor: Colors.transparent,
  //       backgroundColor: Color(0xFF222222),
  //       title: Padding(
  //         padding: const EdgeInsets.only(left: 14),
  //         child: Text(
  //           'Updates',
  //           style: GoogleFonts.overpass(
  //             fontWeight: FontWeight.bold,
  //             fontSize: 24,
  //             color: Colors.white,
  //           ),
  //         ),
  //       ),
  //       actions: [
  //         Padding(
  //           padding: const EdgeInsets.only(right: 20.0),
  //           child: InkWell(
  //             onTap: () {},
  //             child: SvgPicture.asset(
  //               'assets/icons/sync.svg',
  //               colorFilter: ColorFilter.mode(
  //                 Colors.white,
  //                 BlendMode.srcIn,
  //               ),
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(right: 14.0),
  //           child: InkWell(
  //             onTap: () {
  //               service.clearAllNotifications();
  //             },
  //             child: SvgPicture.asset(
  //               'assets/icons/settings.svg',
  //               height: 28,
  //               colorFilter: ColorFilter.mode(
  //                 Colors.white,
  //                 BlendMode.srcIn,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     backgroundColor: Color(0xFF222222),
  //     body: SingleChildScrollView(
  //       physics: BouncingScrollPhysics(),
  //       child: ValueListenableBuilder<List<NotificationModel>>(
  //         valueListenable: service.notifications,
  //         builder: (context, value, child) {
  //           return Column(
  //             children: [
  //               NotificationSectionBuilder(
  //                   sectionTitle: 'New', notifications: newNotifications),
  //               NotificationSectionBuilder(
  //                   sectionTitle: 'Previous',
  //                   notifications: previousNotifications),
  //             ],
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }
}
