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
  final DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    service.notifications.addListener(_updateNotifications);
    service.getLocalSubscribedTopics();
    // service.getSnapshotData();
    service.listenForNewNotifications();
  }

  void _updateNotifications() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<NotificationModel> newNotifications = service.notifications.value
        .where((notification) =>
            currentTime.difference(notification.notificationTimestamp).inDays <=
            1)
        .toList();

    final List<NotificationModel> previousNotifications = service
        .notifications.value
        .where((notification) =>
            currentTime.difference(notification.notificationTimestamp).inDays >
            1)
        .toList();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Color(0xFF222222),
        title: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Column(
            children: [
              Text(
                '${service.latestNotificationTimestamp}',
                style: GoogleFonts.overpass(
                  fontWeight: FontWeight.bold,
                  // fontSize: 24,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              Text(
                '${service.subscribedTopics.value['player_who_returned_10000_years_later']}',
                style: GoogleFonts.overpass(
                  fontWeight: FontWeight.bold,
                  // fontSize: 24,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () async {
                await service.subscribeToPlayer();
              },
              child: SvgPicture.asset(
                'assets/icons/sync.svg',
                colorFilter: ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: InkWell(
              onTap: () async {
                await service.clearAllNotifications();
              },
              child: SvgPicture.asset(
                'assets/icons/settings.svg',
                height: 28,
                colorFilter: ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFF222222),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: ValueListenableBuilder<List<NotificationModel>>(
          valueListenable: service.notifications,
          builder: (context, value, child) {
            return Column(
              children: [
                NotificationSectionBuilder(
                    sectionTitle: 'New', notifications: newNotifications),
                NotificationSectionBuilder(
                    sectionTitle: 'Previous',
                    notifications: previousNotifications),
              ],
            );
          },
        ),
      ),
    );
  }
}
