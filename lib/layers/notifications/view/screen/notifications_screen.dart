import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manhwa_alert/core/injector/service_locator.dart';
import 'package:manhwa_alert/layers/notifications/models/notification_model.dart';
import 'package:manhwa_alert/layers/notifications/view/widgets/notification_section_builder.dart';
import 'package:manhwa_alert/layers/notifications/controller/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen>
    with WidgetsBindingObserver {
  final NotificationService service = serviceLocator.get<NotificationService>();
  final DateTime currentTime = DateTime.now().toUtc();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    service.notifications.addListener(_updateNotifications);
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Text(
            'Updates',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: InkWell(
              onTap: () async {
                service.changeTheme();
                // service.clearAllNotifications();
              },
              child: SvgPicture.asset(
                'assets/icons/settings.svg',
                height: 28,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
