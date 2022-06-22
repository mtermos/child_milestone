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
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/data/data_providers/milestone_items_list.dart';
import 'package:flutter/material.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    reset_data();
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
    await prefs.setInt(SELECTED_CHILD_ID, 1);
    if ((prefs.getBool(SHARED_LOGGED) != null) &&
        prefs.getBool(SHARED_LOGGED)!) {
      Navigator.pushNamed(context, '/home');

      // ApiRepository.get().login(LoginRequest(username: prefs.getString(SHARED_USER), password: prefs.getString(SHARED_PASSWORD))).then((response) {
      //   if (response != null) {
      //     Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      //   }
      // }).catchError((error) {
      //   Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      // });
    } else {
      Navigator.pushNamed(context, '/welcome');
    }
  }

  void reset_data() {
    final dbProvider = DatabaseProvider.dbProvider;
    dbProvider.deleteDatabase();
    dbProvider.createDatabase();
    // BlocProvider.of<ChildBloc>(context).add(DeleteAllChildrenEvent());
    add_temp_child();
    add_temp_milestones();
    add_temp_tips();
    add_temp_notifications();
  }

  add_temp_child() {
    ChildModel newChild = ChildModel(
        id: 1,
        name: "Tester",
        date_of_birth: DateTime.now().subtract(Duration(days: 30)),
        image_path: "assets/images/children/child1.png",
        gender: "male",
        pregnancy_duration: 10);
    BlocProvider.of<ChildBloc>(context)
        .add(AddChildEvent(child: newChild, whenDone: () {}));
    ChildModel newChild2 = ChildModel(
        id: 2,
        name: "Tester2",
        date_of_birth: DateTime.now().subtract(Duration(days: 130)),
        image_path: "assets/images/children/child2.png",
        gender: "female",
        pregnancy_duration: 10);
    BlocProvider.of<ChildBloc>(context)
        .add(AddChildEvent(child: newChild2, whenDone: () {}));
  }

  add_temp_milestones() {
    for (var milestone in milestoneItemsList) {
      BlocProvider.of<MilestoneBloc>(context)
          .add(AddMilestoneEvent(milestone: milestone));
    }
  }

  add_temp_tips() {
    for (var tip in tipsItems) {
      BlocProvider.of<TipBloc>(context).add(AddTipEvent(tip: tip));
    }
  }

  add_temp_notifications() {
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
