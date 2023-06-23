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
  List<Map<String, dynamic>> _notifications = [];
  int pageSize = 10;
  DocumentSnapshot? lastDocument;
  final DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _notifications = service.loadCachedNotifications();
    getSnapshotData();
    listenForNewNotifications();
  }

  void listenForNewNotifications() {
    final Map<String, String> localTopics = service.getLocalSubscribedTopics();

    for (final key in localTopics.keys) {
      String value = localTopics[key]!;
      String? latestNotificationTimestamp =
          service.loadLatestNotificationTimestamp();

      _db
          .collection("notifications")
          .doc(key)
          .collection("notifications")
          .where('notification_timestamp',
              isGreaterThan: (latestNotificationTimestamp != '' &&
                      latestNotificationTimestamp != null)
                  ? latestNotificationTimestamp
                  : value)
          .orderBy('notification_timestamp', descending: true)
          .snapshots()
          .listen((querySnapshot) async {
        List<NotificationModel> newNotifications = [];

        for (var docSnapshot in querySnapshot.docs) {
          newNotifications.add(NotificationModel.fromMap(docSnapshot.data()));
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }

        service.addNotifications(newNotifications);

        await service.saveNotificationsToCache(_notifications);
        await service.saveLatestNotificationTimestamp();
      });
    }
  }

  Future<void> getSnapshotData() async {
    final Map<String, String> localTopics = service.getLocalSubscribedTopics();
    List<NotificationModel> newNotifications = [];

    String? latestNotificationTimestamp =
        service.loadLatestNotificationTimestamp();

    for (final key in localTopics.keys) {
      String value = localTopics[key]!;
      Query query = _db
          .collection("notifications")
          .doc(key)
          .collection("notifications")
          .where('notification_timestamp',
              isGreaterThan: (latestNotificationTimestamp != '' &&
                      latestNotificationTimestamp != null)
                  ? latestNotificationTimestamp
                  : value) // Add this line
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
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      }
    }
    service.addNotifications(newNotifications);

    await service.saveNotificationsToCache(_notifications);
    await service.saveLatestNotificationTimestamp();
  }

  void refreshNotifications(List<Map<String, dynamic>> newNotifications) {
    setState(() {
      _notifications.addAll(newNotifications);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      // body: SingleChildScrollView(
      //   physics: BouncingScrollPhysics(),
      //   child: ValueListenableBuilder<List<NotificationModel>>(
      //     valueListenable: service.notifications,
      //     builder: (context, value, child) {
      //       return Container();
      //     },
      //   ),
      // ),
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_notifications[index]['manhwa_title']),
            subtitle: Text(_notifications[index]['notification_timestamp']),
          );
        },
      ),
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
