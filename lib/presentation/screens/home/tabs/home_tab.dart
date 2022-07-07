import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/logic/blocs/decision/decision_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/logic/shared/notification_service.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  ChildModel? currentChild;
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
    const String profilePicBg = "assets/images/profile_pic_bg.svg";
    const String summary = "assets/images/summary.png";
    const String tips = "assets/images/tips.png";
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
    NotificationService _notificationService = NotificationService();
    String doubleArrowIcon = "";
    bool isRTL = AppLocalizations.of(context)!.localeName == "ar";

    if (isRTL) {
      doubleArrowIcon = "assets/icons/home_page/double_arrows_to_left.png";
    } else {
      doubleArrowIcon = "assets/icons/home_page/double_arrows.png";
    }

    return Scaffold(
      body: BlocBuilder<CurrentChildCubit, CurrentChildState>(
        builder: (context, state) {
          if (state is CurrentChildChangedState) {
            currentChild = state.new_current_child;
            age =
                DateTime.now().difference(currentChild!.date_of_birth).inDays ~/
                    30;
          }
          return Column(
            children: [
              SizedBox(
                height: size.height * 0.3,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Positioned(
                      top: size.height * 0.02,
                      child: Center(
                        child: SvgPicture.asset(
                          profilePicBg,
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
                              currentChild != null
                                  ? CircleAvatar(
                                      radius: size.width * 0.15,
                                      backgroundImage:
                                          Image.asset(currentChild!.image_path)
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
                            text: currentChild != null
                                ? currentChild!.name
                                : "child's name",
                            color: Colors.white,
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: size.height * 0.01),
                          AppText(
                            text: age.toString() +
                                AppLocalizations.of(context)!.monthsOld,
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
              BlocBuilder<DecisionBloc, DecisionState>(
                builder: (context, state) {
                  if (state is LoadedDecisionsByAgeState) {
                    return InkWell(
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
                                  text: AppLocalizations.of(context)!
                                      .milestoneChecklist,
                                  fontSize: textScale * 20,
                                ),
                                SizedBox(width: size.width * 0.02),
                                Image.asset(
                                  doubleArrowIcon,
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
                                    isRTL: isRTL,
                                    lineHeight: textScale * 15,
                                    animationDuration: 2500,
                                    percent: (state.decisions.length /
                                        state.milestonesLength),
                                    progressColor: Colors.red,
                                  ),
                                ),
                                SizedBox(width: size.width * 0.015),
                                Text(state.decisions.length.toString() +
                                    "/" +
                                    state.milestonesLength.toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/milestone');
                      },
                    );
                  } else {
                    if (currentChild != null) {
                      BlocProvider.of<DecisionBloc>(context).add(
                          GetDecisionsByAgeEvent(
                              dateOfBirth: currentChild!.date_of_birth,
                              childId: currentChild!.id));
                    }
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const Spacer(),
              Row(
                children: [
                  SizedBox(width: size.width * 0.075),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      summary,
                      width: size.width * 0.4,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, childSummaryRoute);
                    },
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      tips,
                      width: size.width * 0.4,
                    ),
                    onTap: () async {
                      await _notificationService.scheduleNotifications(
                        id: 1,
                        title: "title",
                        body: "body",
                        scheduledDate: tz.TZDateTime.now(tz.local)
                            .add(const Duration(seconds: 5)),
                      );
                      // _logout();
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
}
