import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manhwa_alert/layers/notifications/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  final DateTime currentTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final List<NotificationModel> notifications = getNotifications();

    final List<NotificationModel> newNotifications = notifications
        .where((notification) =>
            currentTime.difference(notification.date).inDays <= 1)
        .toList();

    final List<NotificationModel> previousNotifications = notifications
        .where((notification) =>
            currentTime.difference(notification.date).inDays > 1)
        .toList();
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Color(0xFF222222),
        title: Text(
          'Updates',
          style: GoogleFonts.overpass(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Color(0xFF222222),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildSection('New', newNotifications),
            _buildSection('Previous', previousNotifications),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      String sectionTitle, List<NotificationModel> notifications) {
    final filteredNotifications = notifications
        .where((notification) => sectionTitle == 'New'
            ? currentTime.difference(notification.date).inDays <= 1
            : currentTime.difference(notification.date).inDays > 1)
        .toList();

    filteredNotifications.sort((a, b) => b.date.compareTo(a.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            sectionTitle,
            style: GoogleFonts.overpass(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: filteredNotifications.length,
          itemBuilder: (context, index) {
            final notification = filteredNotifications[index];
            final bool isRead = notification.isRead;
            final Color backgroundColor =
                isRead ? Colors.transparent : Color(0xFF282828);

            final timeDifference = currentTime.difference(notification.date);
            final formattedTimeDifference =
                _formatTimeDifference(timeDifference);

            return Container(
              color: backgroundColor,
              padding: (sectionTitle == 'New' && !isRead)
                  ? EdgeInsets.fromLTRB(0, 20, 20, 10)
                  : EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (sectionTitle == 'New' && !isRead)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        child: Center(
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Color(0xFFFF6812),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        notification.trailingImageLink,
                        height: 80,
                        width: 80,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(width: 14.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // color: Colors.red,
                            height: 40,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                notification.title,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.overpass(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 3,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                notification.subtitle,
                                style: GoogleFonts.overpass(
                                  color: Color(0xFFBEBEBE),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                formattedTimeDifference,
                                style: GoogleFonts.overpass(
                                  color: Color(0xFFFF6812),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 2,
              color: Color(0xFF222222),
            );
          },
        ),
      ],
    );
  }

  String _formatTimeDifference(Duration timeDifference) {
    if (timeDifference.inDays > 0) {
      return '${timeDifference.inDays} ${timeDifference.inDays > 1 ? 'days' : 'day'} ago';
    } else if (timeDifference.inHours > 0) {
      return '${timeDifference.inHours} ${timeDifference.inHours > 1 ? 'hours' : 'hour'} ago';
    } else {
      return '${timeDifference.inMinutes} ${timeDifference.inMinutes > 1 ? 'minutes' : 'minute'} ago';
    }
  }
}
