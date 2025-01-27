import 'dart:async';
import 'dart:io';

import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/data_providers/tips_items_list.dart';
import 'package:child_milestone/data/data_providers/notifications_items_list.dart';
import 'package:child_milestone/data/data_providers/vaccine_items_list.dart';
import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/log.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:child_milestone/logic/blocs/log/log_bloc.dart';
import 'package:child_milestone/logic/blocs/milestone/milestone_bloc.dart';
import 'package:child_milestone/logic/blocs/notification/notification_bloc.dart';
import 'package:child_milestone/logic/blocs/rating/rating_bloc.dart';
import 'package:child_milestone/logic/blocs/tip/tip_bloc.dart';
import 'package:child_milestone/data/data_providers/milestone_items_list.dart';
import 'package:child_milestone/logic/blocs/vaccine/vaccine_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/logic/shared/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // resetData();
    const delay = Duration(seconds: 1);
    Future.delayed(delay, () => checkUserIsLogged());
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LogBloc>(context).add(
      AddLogEvent(
        log: LogModel(
          action: "open app",
          description: "The user opened the application",
          takenAt: DateTime.now(),
        ),
      ),
    );
    BlocProvider.of<ChildBloc>(context).add(
        UploadChildrenEvent(appLocalizations: AppLocalizations.of(context)!));
    BlocProvider.of<LogBloc>(context).add(const UploadLogsEvent());
    BlocProvider.of<RatingBloc>(context).add(
        UploadRatingsEvent(appLocalizations: AppLocalizations.of(context)!));
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
    // await prefs.setInt(SharedPrefKeys.selectedChildId, 1);
    // await prefs.setBool(SharedPrefKeys.isLogged, true);
    // await prefs.clear();

    if ((prefs.getBool(SharedPrefKeys.isLogged) != null) &&
        prefs.getBool(SharedPrefKeys.isLogged)!) {
      BlocProvider.of<CurrentChildCubit>(context).changeCurrentChildById(
          prefs.getInt(SharedPrefKeys.selectedChildId) ?? 0);

      Navigator.popAndPushNamed(context, Routes.home);
    } else {
      await addTempMilestones();
      await addTempTips();
      await addTempVaccines();
      // remove the next line when adding login service
      // await prefs.setBool(SharedPrefKeys.isLogged, true);
      Navigator.popAndPushNamed(context, Routes.welcome);
    }
  }

  resetData() async {
    final dbProvider = DatabaseProvider.dbProvider;
    // await dbProvider.deleteDatabase();
    await dbProvider.createDatabase();
    final db = await dbProvider.database;
    await db.delete(childrenTABLE);
    await db.delete(milestonesTABLE);
    await db.delete(vaccinesTABLE);
    await db.delete(tipsTABLE);
    await db.delete(notificationsTABLE);
    await db.delete(decisionsTABLE);
    await db.delete(ratingsTABLE);
    await db.delete(logsTABLE);
    NotificationService _notificationService = NotificationService();
    await _notificationService.cancelAllNotifications();
    BlocProvider.of<ChildBloc>(context).add(DeleteAllChildrenEvent());
    // await addTempChild();
    await addTempMilestones();
    await addTempVaccines();
    await addTempTips();

    // await addTempNotifications();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  addTempChild() async {
    final appDir = await getApplicationDocumentsDirectory();

    String imagePath1 = "assets/images/children/child1.png";
    String imagePath2 = "assets/images/children/child2.png";

    String fileName = path.basename(imagePath1);
    String imagePath = '${appDir.path}/$fileName';

    ByteData byteData = await rootBundle.load(imagePath1);
    File file = File(imagePath);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    ChildModel newChild = ChildModel(
        id: 1,
        name: "رامي",
        dateOfBirth: DateTime.now().subtract(const Duration(days: 180)),
        imagePath: imagePath,
        gender: "Male",
        pregnancyDuration: 37);
    BlocProvider.of<ChildBloc>(context).add(
      AddChildEvent(
        appLocalizations: AppLocalizations.of(context)!,
        child: newChild,
        addNotifications: false,
        whenDone: () {},
      ),
    );

    fileName = path.basename(imagePath2);
    imagePath = '${appDir.path}/$fileName';

    byteData = await rootBundle.load(imagePath2);
    file = File(imagePath);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    ChildModel newChild2 = ChildModel(
        id: 2,
        name: "سارة",
        dateOfBirth: DateTime.now().subtract(const Duration(days: 70)),
        imagePath: imagePath,
        gender: "Female",
        pregnancyDuration: 10);
    BlocProvider.of<ChildBloc>(context).add(AddChildEvent(
        appLocalizations: AppLocalizations.of(context)!,
        child: newChild2,
        addNotifications: false,
        whenDone: () {}));

    ChildModel newChild3 = ChildModel(
        id: 3,
        name: "الثالث",
        dateOfBirth: DateTime.now().subtract(const Duration(days: 144)),
        imagePath: imagePath,
        gender: "Male",
        pregnancyDuration: 27);
    BlocProvider.of<ChildBloc>(context).add(AddChildEvent(
        appLocalizations: AppLocalizations.of(context)!,
        child: newChild3,
        addNotifications: false,
        whenDone: () {}));

    ChildModel newChild4 = ChildModel(
        id: 4,
        name: "الرابع",
        dateOfBirth: DateTime.now().subtract(const Duration(days: 244)),
        imagePath: imagePath,
        gender: "Male",
        pregnancyDuration: 27);
    BlocProvider.of<ChildBloc>(context).add(AddChildEvent(
        appLocalizations: AppLocalizations.of(context)!,
        child: newChild4,
        addNotifications: false,
        whenDone: () {}));
  }

  addTempMilestones() {
    for (var milestone in milestoneItemsList) {
      BlocProvider.of<MilestoneBloc>(context)
          .add(AddMilestoneEvent(milestone: milestone));
    }
  }

  addTempVaccines() {
    for (var vaccine in vaccinesList) {
      BlocProvider.of<VaccineBloc>(context)
          .add(AddVaccineEvent(vaccine: vaccine));
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
