import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/logic/blocs/auth/auth_bloc.dart';
import 'package:child_milestone/logic/blocs/auth/auth_event.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/logic/shared/notification_service.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
// import 'package:flutter_bloc_login_example/bloc/auth/auth_bloc.dart';
// import 'package:flutter_bloc_login_example/bloc/auth/auth_event.dart';
// import 'package:flutter_bloc_login_example/bloc/auth/auth_state.dart';
// import 'package:flutter_bloc_login_example/screens/home/main.dart';
// import 'package:flutter_bloc_login_example/screens/login/signUp.dart';
// import 'package:flutter_bloc_login_example/shared/colors.dart';
// import 'package:flutter_bloc_login_example/shared/components.dart';
// import 'package:flutter_bloc_login_example/shared/screen_transitions/slide.transition.dart';
// import 'package:flutter_bloc_login_example/shared/styles.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  ChildModel? current_child;
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
    const String double_arrow_icon = "assets/icons/home_page/double_arrows.png";
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
    NotificationService _notificationService = NotificationService();

    return Scaffold(
      body: BlocBuilder<CurrentChildCubit, CurrentChildState>(
        builder: (context, state) {
          if (state is CurrentChildChangedState) {
            current_child = state.new_current_child;
            age = (DateTime.now()
                        .difference(current_child!.date_of_birth)
                        .inDays /
                    30)
                .toInt();
          }
          return Column(
            children: [
              Container(
                height: size.height * 0.3,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Positioned(
                      top: size.height * 0.02,
                      child: Center(
                        child: SvgPicture.asset(
                          profile_pic_bg,
                          width: size.width * 0.9,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.045,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: size.width * 0.16,
                              ),
                              current_child != null
                                  ? CircleAvatar(
                                      radius: size.width * 0.15,
                                      backgroundImage:
                                          Image.asset(current_child!.image_path)
                                              .image
                                      // child_pic).image,
                                      )
                                  : CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: size.width * 0.16,
                                    ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          AppText(
                            text: current_child != null
                                ? current_child!.name
                                : "asd",
                            color: Colors.white,
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: size.height * 0.01),
                          AppText(
                            text: age.toString() + " months old!",
                            color: Colors.white,
                            fontSize: size.height * 0.015,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              InkWell(
                child: Container(
                  width: size.width * 0.85,
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.08,
                      vertical: size.height * 0.03),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: textScale * 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          AppText(
                            text: "Milestone checklist",
                            fontSize: textScale * 20,
                          ),
                          SizedBox(width: size.width * 0.02),
                          Image.asset(
                            double_arrow_icon,
                            width: size.width * 0.05,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.025),
                      Row(
                        children: [
                          Expanded(
                            child: LinearPercentIndicator(
                              animation: true,
                              lineHeight: textScale * 15,
                              animationDuration: 2500,
                              percent: 0.2,
                              progressColor: Colors.red,
                            ),
                          ),
                          SizedBox(width: size.width * 0.015),
                          Text("2/10"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Row(
                children: [
                  SizedBox(width: size.width * 0.075),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(summary),
                    onTap: () async {
                      await _notificationService.scheduleNotifications(
                        id: 1,
                        title: "title",
                        body: "body",
                        scheduledDate: tz.TZDateTime.now(tz.local)
                            .add(const Duration(seconds: 5)),
                      );
                    },
                  ),
                  Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(tips),
                    onTap: () {
                      _logout();
                    },
                  ),
                  SizedBox(width: size.width * 0.075),
                ],
              ),
              // Container(
              //   width: size.width * 0.5,
              //   child: AppButton(
              //     label: "Logout",
              //     onPressed: () {
              //       _logout();
              //     },
              //   ),
              // )
              SizedBox(height: size.height * 0.025),
            ],
          );
        },
      ),
    );
  }

  _logout() async {
    BlocProvider.of<AuthBloc>(context).add(LogoutEvent(
      () {
        Navigator.pushNamed(context, '/');
      },
    ));
  }
}
