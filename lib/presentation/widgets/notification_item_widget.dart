import 'package:child_milestone/data/models/notification.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationItemWidget extends StatefulWidget {
  NotificationItemWidget({Key? key, required this.item}) : super(key: key);
  final NotificationModel item;

  @override
  _NotificationItemWidgetState createState() => _NotificationItemWidgetState();
}

class _NotificationItemWidgetState extends State<NotificationItemWidget> {
  final Color borderColor = Color(0xffE2E2E2);

  @override
  Widget build(BuildContext context) {
    const String double_arrow_icon = "assets/icons/x-icon.png";
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: size.width * 0.05,
            backgroundImage: Image.asset(widget.item.child.image_path).image,
          ),
          SizedBox(width: size.width * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width * 0.65,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.item.child.name + " ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: widget.item.body),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              AppText(
                text: readable_date(widget.item.issued_time),
                fontSize: textScale * 14,
              )
            ],
          ),
          Spacer(),
          Column(
            children: [
              Image.asset(
                double_arrow_icon,
                width: size.width * 0.05,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String readable_date(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime justNow = DateTime.now().subtract(Duration(minutes: 1));
    DateTime localDateTime = dateTime.toLocal();

    if (!localDateTime.difference(justNow).isNegative) {
      return 'Just now';
    }

    String roughTimeString = DateFormat('jm').format(dateTime);
    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      return roughTimeString;
    }

    DateTime yesterday = now.subtract(Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == yesterday.month &&
        localDateTime.year == yesterday.year) {
      return 'Yesterday, ' + roughTimeString;
    }

    // if (now.difference(localDateTime).inDays < 4) {
    //   String weekday = DateFormat('EEEE').format(localDateTime);

    //   return '$weekday, $roughTimeString';
    // }

    return '${DateFormat('yMd').format(dateTime)}, $roughTimeString';
  }
}
