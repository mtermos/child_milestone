import 'dart:async';

import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/data_providers/tips_items_list.dart';
import 'package:child_milestone/data/data_providers/notifications_items_list.dart';
import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:child_milestone/logic/blocs/milestone/milestone_bloc.dart';
import 'package:child_milestone/logic/blocs/notification/notification_bloc.dart';
import 'package:child_milestone/logic/blocs/tip/tip_bloc.dart';
import 'package:child_milestone/data/data_providers/milestone_items_list.dart';
import 'package:child_milestone/logic/shared/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    resetData();
    super.initState();

    const delay = Duration(seconds: 1);
    Future.delayed(delay, () => checkUserIsLogged());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: splashScreenIcon(size),
      ),
    );
  }

  void checkUserIsLogged() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(SharedPrefKeys.selectedChildId, 1);
    if ((prefs.getBool(SharedPrefKeys.isLogged) != null) &&
        prefs.getBool(SharedPrefKeys.isLogged)!) {
      Navigator.popAndPushNamed(context, Routes.home);
    } else {
      Navigator.popAndPushNamed(context, Routes.welcome);
    }
  }

  void resetData() {
    final dbProvider = DatabaseProvider.dbProvider;
    dbProvider.deleteDatabase();
    dbProvider.createDatabase();
    NotificationService _notificationService = NotificationService();
    _notificationService.cancelAllNotifications();
    // BlocProvider.of<ChildBloc>(context).add(DeleteAllChildrenEvent());
    addTempChild();
    addTempMilestones();
    addTempTips();
    addTempNotifications();
  }

  addTempChild() {
    ChildModel newChild = ChildModel(
        id: 1,
        name: "رامي",
        date_of_birth: DateTime.now().subtract(Duration(days: 30)),
        image_path: "assets/images/children/child1.png",
        gender: "male",
        pregnancy_duration: 10);
    BlocProvider.of<ChildBloc>(context).add(AddChildEvent(
        context: context,
        child: newChild,
        addNotifications: false,
        whenDone: () {}));
    ChildModel newChild2 = ChildModel(
        id: 2,
        name: "سارة",
        date_of_birth: DateTime.now().subtract(Duration(days: 130)),
        image_path: "assets/images/children/child2.png",
        gender: "female",
        pregnancy_duration: 10);
    BlocProvider.of<ChildBloc>(context).add(AddChildEvent(
        context: context,
        child: newChild2,
        addNotifications: false,
        whenDone: () {}));
  }

  addTempMilestones() {
    for (var milestone in milestoneItemsList) {
      BlocProvider.of<MilestoneBloc>(context)
          .add(AddMilestoneEvent(milestone: milestone));
    }
  }

  addTempTips() {
    for (var tip in tipsItems) {
      BlocProvider.of<TipBloc>(context).add(AddTipEvent(tip: tip));
    }
  }

  addTempNotifications() {
    for (var notification in notificationsItems) {
      BlocProvider.of<NotificationBloc>(context)
          .add(AddNotificationEvent(notification: notification));
    }
  }
}

Widget splashScreenIcon(Size size) {
  // String iconPath = "assets/icons/vaccine-for-children.svg";
  // return SvgPicture.asset(
  //   iconPath,
  //   width: 250,
  // );

  String iconPath = "assets/icons/steps_icon.png";
  return Image.asset(
    iconPath,
    width: size.width * 0.3,
  );
}
