import 'dart:ui';

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
  late TutorialCoachMark tutorialCoachMark;

  GlobalKey keyButton = GlobalKey();

  @override
  void initState() {
    createTutorial();
    Future.delayed(Duration.zero, showTutorial);
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    service.notifications.addListener(_updateNotifications);
    WidgetsBinding.instance.addObserver(this);
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  @override
  void dispose() {
    service.notifications.removeListener(_updateNotifications);
    super.dispose();
  }

  void _updateNotifications() {
    setState(() {});
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        // radius: 16,
        identify: "keyButton",
        keyTarget: keyButton,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Sync",
                    style: GoogleFonts.overpass(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Notifications are sent and stored directly to your phone.",
                      style: GoogleFonts.overpass(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "If you lost connection and want to retrieve notifications from that period of time, you may want to use this button. ",
                      style: GoogleFonts.overpass(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10.0),
                  //   child: Text(
                  //     "Only the last notification sent from that period will be recieved. The remaining ones will only show if you press the button.",
                  //     style: GoogleFonts.overpass(
                  //       color: Colors.white,
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return targets;
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      textStyleSkip: GoogleFonts.overpass(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 16,
      ),
      textSkip: "Ok",
      paddingFocus: 14,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.reload();
      service.loadLocalNotifications();
      // SharedPreferences sp = await SharedPreferences.getInstance();
      // await sp.reload();
      // setState(() {
      //   service.loadLocalNotifications();
      // });
    }
  }

  final DateTime currentTime = DateTime.now();
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
          child: Text(
            'Updates',
            style: GoogleFonts.overpass(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              key: keyButton,
              onTap: () {},
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
              onTap: () {
                service.clearAllNotifications();
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
