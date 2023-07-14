import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manhwa_alert/layers/notifications/controller/notification_service.dart';
import 'package:manhwa_alert/core/injector/service_locator.dart';
import 'package:manhwa_alert/layers/search/models/scanlator_model.dart';

class ManhwaAlertDialog extends StatefulWidget {
  final Map<String, String> webtoon;
  final ScanlatorModel scanlator;

  const ManhwaAlertDialog({
    super.key,
    required this.webtoon,
    required this.scanlator,
  });

  @override
  State<ManhwaAlertDialog> createState() => _ManhwaAlertDialogState();
}

class _ManhwaAlertDialogState extends State<ManhwaAlertDialog> {
  final FirebaseMessaging fcm = serviceLocator.get<FirebaseMessaging>();
  final StreamController<bool> _buttonController = StreamController<bool>();
  final NotificationService service = serviceLocator.get<NotificationService>();

  void _subscribeToTopic(String manhwaTitle) async {
    _buttonController.add(true);
    final String topic = cleanTopic(widget.scanlator.name, manhwaTitle);
    fcm.subscribeToTopic(topic);
    await service.saveSubscribedTopicLocal(topic);
    service.addTopicSnapshotListener(topic);
    setState(() {});
    _buttonController.add(true);
  }

  void _unsubscribeFromTopic(String manhwaTitle) async {
    _buttonController.add(false);
    final String topic = cleanTopic(widget.scanlator.name, manhwaTitle);
    fcm.unsubscribeFromTopic(topic);
    await service.removeSubscribedTopicLocal(topic);
    await service.removeAListener(topic);
    setState(() {});
    _buttonController.add(true);
  }

  @override
  void dispose() {
    _buttonController.close();
    super.dispose();
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
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.network(
                  widget.webtoon['cover_url']!,
                  height: 400,
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 6),
              child: Text(
                widget.webtoon['title']!,
                style: GoogleFonts.oswald(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            if (widget.webtoon['latest_chapter'] != null &&
                int.parse(widget.webtoon['latest_chapter']!) > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                child: Text(
                  '${widget.webtoon['latest_chapter']!} chapters',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(20,
                  widget.webtoon['latest_chapter'] != null ? 0 : 15, 20, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ValueListenableBuilder(
                      valueListenable: service.subscribedTopics,
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        bool isUserSubscribed = service
                            .subscribedTopics.value.keys
                            .contains(cleanTopic(widget.scanlator.name,
                                widget.webtoon['title']!));
                        return StreamBuilder<bool>(
                          stream: _buttonController.stream,
                          initialData: true,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            bool isButtonEnabled = snapshot.data!;
                            return InkWell(
                              onTap: isButtonEnabled
                                  ? () {
                                      if (isUserSubscribed) {
                                        _unsubscribeFromTopic(
                                            widget.webtoon['title']!);
                                      } else {
                                        _subscribeToTopic(
                                            widget.webtoon['title']!);
                                      }
                                    }
                                  : null,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: SvgPicture.asset(
                                      'assets/icons/notifications-bell.svg',
                                      height: 18,
                                      colorFilter: ColorFilter.mode(
                                        isUserSubscribed
                                            ? const Color(0xFF646464)
                                            : const Color(0xFFFF6812),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isUserSubscribed
                                        ? 'Unsubscribe'
                                        : 'Subscribe',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: isUserSubscribed
                                          ? const Color(0xFF646464)
                                          : const Color(0xFFFF6812),
                                      fontSize: 16,
                                      fontWeight: isUserSubscribed
                                          ? FontWeight.w500
                                          : FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        // Your onPressed logic for the new button
                      },
                      child: const Text(
                        'See more',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFFFF6812),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String cleanTopic(String scanlatorName, String topic) {
    String cleanedString = topic.replaceAll(RegExp(r'[^A-Za-z0-9\s]'), '');
    List<String> words = cleanedString.split(RegExp(r'\s+'));
    String joinedString = words.join('_');
    String transformedString = joinedString.toLowerCase();
    return '${scanlatorName.trim().toLowerCase()}_$transformedString';
  }
}
