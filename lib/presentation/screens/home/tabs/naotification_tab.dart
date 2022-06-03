import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/notification.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/components/column_with_seprator.dart';
import 'package:child_milestone/presentation/widgets/notification_item_widget.dart';
import 'package:flutter/material.dart';

class NotificationTab extends StatefulWidget {
  const NotificationTab({Key? key}) : super(key: key);

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationTab> {
  ChildModel tempChild = ChildModel(
      name: "name",
      date_of_birth: DateTime.now(),
      image_path: "assets/images/children/child1.png",
      child_id: "1",
      gender: "gender",
      pregnancy_duration: 12);
  var demoItems = [
    NotificationModel(
      id: 1,
      title: "Temp Temp 1",
      body: "has an appointment with the doctor tomorrow",
      issued_time: DateTime.now(),
      opened: true,
      child: ChildModel(
          name: "Ahmad",
          date_of_birth: DateTime.now(),
          image_path: "assets/images/children/child1.png",
          child_id: "1",
          gender: "gender",
          pregnancy_duration: 12),
    ),
    NotificationModel(
      id: 2,
      title: "Temp Temp 2",
      body: "has an appointment with the doctor tomorrow",
      issued_time: DateTime.now().subtract(Duration(hours: 1)),
      opened: false,
      child: ChildModel(
          name: "name",
          date_of_birth: DateTime.now(),
          image_path: "assets/images/children/child1.png",
          child_id: "1",
          gender: "gender",
          pregnancy_duration: 12),
    ),
    NotificationModel(
      id: 3,
      title: "Temp Temp 3",
      body: "has an appointment with the doctor tomorrow",
      issued_time: DateTime.now().subtract(Duration(days: 1)),
      opened: false,
      child: ChildModel(
          name: "name",
          date_of_birth: DateTime.now(),
          image_path: "assets/images/children/child1.png",
          child_id: "1",
          gender: "gender",
          pregnancy_duration: 12),
    ),
    NotificationModel(
      id: 4,
      title: "Temp Temp 4",
      body: "has an appointment with the doctor tomorrow",
      issued_time: DateTime.now().subtract(Duration(days: 5)),
      opened: false,
      child: ChildModel(
          name: "name",
          date_of_birth: DateTime.now(),
          image_path: "assets/images/children/child1.png",
          child_id: "1",
          gender: "gender",
          pregnancy_duration: 12),
    ),
    NotificationModel(
      id: 4,
      title: "Temp Temp 4",
      body: "has an appointment with the doctor tomorrow",
      issued_time: DateTime.now().subtract(Duration(days: 10)),
      opened: false,
      child: ChildModel(
          name: "name",
          date_of_birth: DateTime.now(),
          image_path: "assets/images/children/child1.png",
          child_id: "1",
          gender: "gender",
          pregnancy_duration: 12),
    ),
  ];

  int age = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String profile_pic_bg = "assets/images/profile_pic_bg.svg";
    const String summary = "assets/images/summary.png";
    const String tips = "assets/images/tips.png";
    const String child_pic = "assets/images/children/child1.png";
    const String double_arrow_icon = "assets/icons/home_page/double_arrows.png";
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            Container(
              alignment: AlignmentDirectional.topStart,
              padding: EdgeInsets.only(left: size.width * 0.05),
              child: const AppText(
                text: "Notifications",
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Column(
              children: getChildrenWithSeperator(
                addToFirstChild: false,
                widgets: demoItems.map((e) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.035,
                    ),
                    width: double.maxFinite,
                    child: NotificationItemWidget(
                      item: e,
                    ),
                  );
                }).toList(),
                seperator: Divider(
                  thickness: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
