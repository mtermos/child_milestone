import 'dart:io';

import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/logic/blocs/notification/notification_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/logic/shared/functions.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class NotificationItemWidget extends StatefulWidget {
  const NotificationItemWidget({super.key, required this.item});
  final NotificationWithChildAndMilestone item;

  @override
  _NotificationItemWidgetState createState() => _NotificationItemWidgetState();
}

class _NotificationItemWidgetState extends State<NotificationItemWidget> {
  final Color borderColor = const Color(0xffE2E2E2);

  @override
  Widget build(BuildContext context) {
    const String xIcon = "assets/icons/x-icon.png";
    Size size = MediaQuery.of(context).size;
    final isMOBILE = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final textScale = isMOBILE
        ? MediaQuery.of(context).size.height * 0.001
        : MediaQuery.of(context).size.height * 0.0011;
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Row(
              children: [
                CircleAvatar(
                  radius: size.width * 0.05,
                  backgroundColor: Colors.white,
                  backgroundImage: widget.item.child.imagePath != ""
                      ? Image.file(File(widget.item.child.imagePath)).image
                      : Image.asset(noImageAsset(widget.item.child)).image,
                ),
                SizedBox(width: size.width * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.65,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: textScale * 18,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: widget.item.child.name + " ",
                                style: TextStyle(
                                    fontSize: textScale * 18,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(text: widget.item.notification.body),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    AppText(
                      text: readableDate(widget.item.notification.issuedAt),
                      fontSize: textScale * 14,
                    )
                  ],
                ),
              ],
            ),
            onTap: () {
              BlocProvider.of<CurrentChildCubit>(context)
                  .changeCurrentChild(widget.item.child, () {
                Navigator.pushNamed(context, widget.item.notification.route,
                    arguments: widget.item.notification.period);
              });
            },
          ),
          const Spacer(),
          Column(
            children: [
              InkWell(
                child: Image.asset(
                  xIcon,
                  width: size.width * 0.035,
                ),
                onTap: () {
                  BlocProvider.of<NotificationBloc>(context).add(
                      DismissNotificationEvent(
                          notification: widget.item.notification));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String readableDate(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime justNow = DateTime.now().subtract(const Duration(minutes: 1));
    DateTime localDateTime = dateTime.toLocal();

    if (!localDateTime.difference(justNow).isNegative) {
      return AppLocalizations.of(context)!.justNow;
    }

    String roughTimeString = DateFormat('jm').format(dateTime);
    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return roughTimeString;
    }

    DateTime yesterday = now.subtract(const Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == yesterday.month &&
        localDateTime.year == yesterday.year) {
      return AppLocalizations.of(context)!.yesterday + roughTimeString;
    }

    // if (now.difference(localDateTime).inDays < 4) {
    //   String weekday = DateFormat('EEEE').format(localDateTime);

    //   return '$weekday, $roughTimeString';
    // }

    return '${DateFormat('yMd').format(dateTime)}, $roughTimeString';
  }
}
