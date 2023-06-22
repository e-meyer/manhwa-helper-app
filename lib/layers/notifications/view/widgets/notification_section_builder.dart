import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manhwa_alert/core/injector/service_locator.dart';
import 'package:manhwa_alert/layers/notifications/models/notification_model.dart';
import 'package:manhwa_alert/layers/notifications/controller/notification_service.dart';

import '../../../common/widgets/arc/two_rotating_arc.dart';

class NotificationSectionBuilder extends StatelessWidget {
  final String sectionTitle;
  final List<NotificationModel> notifications;

  NotificationSectionBuilder({
    super.key,
    required this.notifications,
    required this.sectionTitle,
  });

  final NotificationService service = serviceLocator.get<NotificationService>();
  final DateTime currentTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = notifications
        .where((notification) => sectionTitle == 'New'
            ? currentTime
                    .difference(notification.notificationTimestamp)
                    .inDays <=
                1
            : currentTime
                    .difference(notification.notificationTimestamp)
                    .inDays >
                1)
        .toList();

    filteredNotifications.sort(
        (a, b) => b.notificationTimestamp.compareTo(a.notificationTimestamp));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        filteredNotifications.isNotEmpty
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  sectionTitle,
                  style: GoogleFonts.overpass(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            : Container(),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: filteredNotifications.length,
          itemBuilder: (context, index) {
            final notification = filteredNotifications[index];
            final bool isRead = notification.isRead;
            final Color backgroundColor =
                isRead ? Colors.transparent : Color(0xFF282828);

            final timeDifference =
                currentTime.difference(notification.notificationTimestamp);
            final formattedTimeDifference =
                _formatTimeDifference(timeDifference);

            return InkWell(
              onTap: () {
                service.markNotificationAsRead(notification);
                print(notification.chapterUrl);
              },
              child: Container(
                color: backgroundColor,
                padding: (sectionTitle == 'New' && !isRead)
                    ? EdgeInsets.fromLTRB(0, 14, 20, 14)
                    : EdgeInsets.fromLTRB(20, 14, 20, 14),
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
                          notification.coverUrl,
                          height: 80,
                          width: 80,
                          fit: BoxFit.fitWidth,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return const Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20.0,
                                ),
                                child: TwoRotatingArc(
                                  size: 40,
                                  color: Color(0xFFFF6812),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icons/image-placeholder.svg',
                                  height: 40,
                                  colorFilter: ColorFilter.mode(
                                    Color(0xFF676767),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            );
                          },
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
                                  notification.manhwaTitle,
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
                                  notification.chapterNumber,
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
    } else if (timeDifference.inMinutes > 0) {
      return '${timeDifference.inMinutes} ${timeDifference.inMinutes > 1 ? 'minutes' : 'minute'} ago';
    } else if (timeDifference.inSeconds > 0) {
      return '${timeDifference.inSeconds} ${timeDifference.inSeconds > 1 ? 'seconds' : 'second'} ago';
    } else {
      return 'just now';
    }
  }
}
