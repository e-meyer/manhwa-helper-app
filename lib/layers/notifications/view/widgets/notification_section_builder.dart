import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:manhwa_alert/core/injector/service_locator.dart';
import 'package:manhwa_alert/layers/notifications/models/notification_model.dart';
import 'package:manhwa_alert/layers/notifications/controller/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final String timeWithoutZ =
      DateTime.now().toUtc().toIso8601String().replaceAll('Z', '');

  @override
  Widget build(BuildContext context) {
    final DateTime currentTime = DateTime.parse(timeWithoutZ);
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
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            : Container(),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredNotifications.length,
          itemBuilder: (context, index) {
            final notification = filteredNotifications[index];
            final bool isRead = notification.isRead;
            final Color backgroundColor =
                isRead ? Colors.transparent : const Color(0xFF282828);

            final timeDifference =
                currentTime.difference(notification.notificationTimestamp);
            final formattedTimeDifference =
                _formatTimeDifference(timeDifference);

            return InkWell(
              onTap: () async {
                service.markAsRead(notification.chapterUrl);
                await service.saveNotificationsToCache();
                await _launchUrl(Uri.parse(notification.chapterUrl));
              },
              child: Container(
                color: backgroundColor,
                padding: (sectionTitle == 'New' && !isRead)
                    ? const EdgeInsets.fromLTRB(0, 14, 20, 14)
                    : const EdgeInsets.fromLTRB(20, 14, 20, 14),
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
                                color: Theme.of(context).primaryColor,
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
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20.0,
                                ),
                                child: TwoRotatingArc(
                                  size: 40,
                                  color: Theme.of(context).primaryColor,
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
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF676767),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 14.0),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  notification.manhwaTitle,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  maxLines: 3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  notification.chapterNumber,
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                                Text(
                                  formattedTimeDifference,
                                  style: Theme.of(context).textTheme.labelSmall,
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
              color: Theme.of(context).scaffoldBackgroundColor,
            );
          },
        ),
      ],
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
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
