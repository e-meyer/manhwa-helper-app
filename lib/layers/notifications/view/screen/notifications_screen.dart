import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manhwa_alert/core/injector/service_locator.dart';
import 'package:manhwa_alert/layers/notifications/models/notification_model.dart';
import 'package:manhwa_alert/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen>
    with WidgetsBindingObserver {
  final NotificationService service = serviceLocator.get<NotificationService>();
  final DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    service.notifications.addListener(_updateNotifications);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    service.notifications.removeListener(_updateNotifications);
    super.dispose();
  }

  void _updateNotifications() {
    setState(() {});
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
        actions: [
          ElevatedButton(
            onPressed: () async {
              service.clearAllNotifications();
            },
            child: Icon(
              Icons.settings,
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
                _buildSection('New', newNotifications),
                _buildSection('Previous', previousNotifications),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(
      String sectionTitle, List<NotificationModel> notifications) {
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
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20.0,
                                ),
                                child: twoRotatingArc(
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

  static Widget twoRotatingArc({
    required Color color,
    required double size,
    Key? key,
  }) {
    return TwoRotatingArc(
      color: color,
      size: size,
      key: key,
    );
  }
}

class TwoRotatingArc extends StatefulWidget {
  final double size;
  final Color color;
  const TwoRotatingArc({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  _TwoRotatingArcState createState() => _TwoRotatingArcState();
}

class _TwoRotatingArcState extends State<TwoRotatingArc>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final Cubic firstCurve = Curves.easeInQuart;
  final Cubic secondCurve = Curves.easeOutQuart;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;
    final double strokeWidth = size / 10;
    final Color color = widget.color;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __) => Stack(
        children: <Widget>[
          Visibility(
            visible: _animationController.value <= 0.5,
            child: Transform.rotate(
              angle: Tween<double>(
                begin: 0.0,
                end: 3 * math.pi / 4,
              )
                  .animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(
                        0.0,
                        0.5,
                        curve: firstCurve,
                      ),
                    ),
                  )
                  .value,
              child: Arc.draw(
                color: color,
                size: size,
                strokeWidth: strokeWidth,
                startAngle: -math.pi / 2,
                // endAngle: math.pi / (size * size),
                endAngle: Tween<double>(
                  begin: math.pi / (size * size),
                  end: -math.pi / 2,
                )
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          0.0,
                          0.5,
                          curve: firstCurve,
                        ),
                      ),
                    )
                    .value,
              ),
            ),
          ),
          Visibility(
            visible: _animationController.value >= 0.5,
            child: Transform.rotate(
              angle: Tween<double>(
                begin: math.pi / 4,
                end: math.pi,
              )
                  .animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(
                        0.5,
                        1.0,
                        curve: secondCurve,
                      ),
                    ),
                  )
                  .value,
              child: Arc.draw(
                color: color,
                size: size,
                strokeWidth: strokeWidth,
                startAngle: -math.pi / 2,
                // endAngle: math.pi / (size * size),
                endAngle: Tween<double>(
                  begin: math.pi / 2,
                  end: math.pi / (size * size),
                )
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          0.5,
                          1.0,
                          curve: secondCurve,
                        ),
                      ),
                    )
                    .value,
              ),
            ),
          ),

          ///
          ///second one
          ///
          ///
          Visibility(
            visible: _animationController.value <= 0.5,
            child: Transform.rotate(
              angle: Tween<double>(begin: -math.pi, end: -math.pi / 4)
                  .animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(0.0, 0.5, curve: firstCurve),
                    ),
                  )
                  .value,
              child: Arc.draw(
                color: color,
                size: size,
                strokeWidth: strokeWidth,
                startAngle: -math.pi / 2,
                // endAngle: math.pi / (size * size),
                endAngle: Tween<double>(
                  begin: math.pi / (size * size),
                  end: -math.pi / 2,
                )
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          0.0,
                          0.5,
                          curve: firstCurve,
                        ),
                      ),
                    )
                    .value,
              ),
            ),
          ),
          Visibility(
            visible: _animationController.value >= 0.5,
            child: Transform.rotate(
              angle: Tween<double>(
                begin: -3 * math.pi / 4,
                end: 0.0,
              )
                  .animate(
                    CurvedAnimation(
                      parent: _animationController,
                      curve: Interval(
                        0.5,
                        1.0,
                        curve: secondCurve,
                      ),
                    ),
                  )
                  .value,
              child: Arc.draw(
                color: color,
                size: size,
                strokeWidth: strokeWidth,
                startAngle: -math.pi / 2,
                // endAngle: math.pi / (size * size),
                endAngle: Tween<double>(
                  begin: math.pi / 2,
                  end: math.pi / (size * size),
                )
                    .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          0.5,
                          1.0,
                          curve: secondCurve,
                        ),
                      ),
                    )
                    .value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class Arc extends CustomPainter {
  final Color _color;
  final double _strokeWidth;
  final double _sweepAngle;
  final double _startAngle;

  Arc._(
    this._color,
    this._strokeWidth,
    this._startAngle,
    this._sweepAngle,
  );

  static Widget draw({
    required Color color,
    required double size,
    required double strokeWidth,
    required double startAngle,
    required double endAngle,
  }) =>
      SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: Arc._(
            color,
            strokeWidth,
            startAngle,
            endAngle,
          ),
        ),
      );

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.height / 2,
    );

    const bool useCenter = false;
    final Paint paint = Paint()
      ..color = _color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth;

    canvas.drawArc(rect, _startAngle, _sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
