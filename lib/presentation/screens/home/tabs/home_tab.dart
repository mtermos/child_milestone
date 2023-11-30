import 'dart:io';

import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/log.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:child_milestone/logic/blocs/decision/decision_bloc.dart';
import 'package:child_milestone/logic/blocs/log/log_bloc.dart';
import 'package:child_milestone/logic/cubits/all_previous_decision_taken/all_previous_decision_taken_cubit.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/logic/shared/functions.dart';
import 'package:child_milestone/logic/shared/notification_service.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeTab extends StatefulWidget {
  Function changeIndex;
  HomeTab({Key? key, required this.changeIndex}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  ChildModel? currentChild;
  int age = 0;
  int correctedAge = 0;

  @override
  void initState() {
    BlocProvider.of<CurrentChildCubit>(context).getCurrentChild();
    // BlocProvider.of<ChildBloc>(context).add(CompleteChildEvent());
    BlocProvider.of<ChildBloc>(context).add(GetAllChildrenEvent());
    // BlocProvider.of<LogBloc>(context).add(GetAllLogsEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final NotificationService _notificationService = NotificationService();
    // _notificationService.scheduleNotifications(
    //   id: 1,
    //   title: "title2",
    //   body: "body2",
    //   scheduledDate: tz.TZDateTime.from(
    //       DateTime.now().add(Duration(seconds: 5)), tz.local),
    // );
    const String profilePicBg = "assets/images/profile_pic_bg.svg";
    String summary = "assets/images/summary.png";
    String vaccinesIcon = "assets/images/vaccines_ar.png";
    String tips = "assets/images/tips.png";
    String arrowsDown = "assets/icons/arrows-down.svg";
    Size size = MediaQuery.of(context).size;
    final isMOBILE = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final textScale = isMOBILE
        ? MediaQuery.of(context).size.height * 0.001
        : MediaQuery.of(context).size.height * 0.0011;
    String doubleArrowIcon = "";
    bool isRTL = AppLocalizations.of(context)!.localeName == "ar";

    if (isRTL) {
      doubleArrowIcon = "assets/icons/home_page/double_arrows_to_left.png";
      summary = "assets/images/summary_ar.png";
      tips = "assets/images/tips_ar.png";
    } else {
      doubleArrowIcon = "assets/icons/home_page/double_arrows.png";
      summary = "assets/images/summary.png";
      tips = "assets/images/tips.png";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<CurrentChildCubit, CurrentChildState>(
        builder: (context, state) {
          if (state is CurrentChildChangedState && state.all_children.isEmpty) {
            CircleAvatar circleAvatar = CircleAvatar(
              backgroundColor: Colors.white,
              radius: size.width * 0.16,
            );
            return Column(
              children: [
                Spacer(),
                Center(
                  child: SizedBox(
                    width: size.width * 0.6,
                    child: AppText(
                      text: "للبدء، إضغط لإضافة ملف لطفلك",
                      color: AppColors.primaryColor,
                      fontSize: textScale * 35,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Center(
                  child: SvgPicture.asset(
                    arrowsDown,
                    width: size.width * 0.2,
                    alignment: Alignment.topCenter,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
              ],
            );
          }
          CircleAvatar circleAvatar = CircleAvatar(
            backgroundColor: Colors.white,
            radius: isMOBILE ? size.width * 0.16 : size.width * 0.13,
          );
          if (state is CurrentChildChangedState) {
            currentChild = state.new_current_child;

            DateTime dateOfBirth;
            if (currentChild!.pregnancyDuration.toInt() < 37) {
              int daysCorrected =
                  (37 - currentChild!.pregnancyDuration.toInt()) * 7;
              dateOfBirth =
                  currentChild!.dateOfBirth.add(Duration(days: daysCorrected));
            } else {
              dateOfBirth = currentChild!.dateOfBirth;
            }
            age = DateTime.now().difference(currentChild!.dateOfBirth).inDays ~/
                30;
            correctedAge = DateTime.now().difference(dateOfBirth).inDays ~/ 30;
            try {
              circleAvatar = CircleAvatar(
                radius: isMOBILE ? size.width * 0.15 : size.width * 0.13,
                backgroundColor: Colors.white,
                backgroundImage: currentChild!.imagePath != ""
                    ? Image.file(File(currentChild!.imagePath)).image
                    : Image.asset(noImageAsset(currentChild!)).image,
              );
            } catch (e) {}
          }
          // try {
          //   childImage = Image.asset(currentChild!.imagePath).image;
          // } catch (e) {
          //   try {
          //     childImage = Image.file(File(currentChild!.imagePath)).image;
          //   } catch (e) {}
          // }
          return Column(
            children: [
              SizedBox(
                height: isMOBILE ? size.height * 0.33 : size.height * 0.45,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Positioned(
                      top: size.height * 0.02,
                      child: Center(
                        child: SvgPicture.asset(
                          profilePicBg,
                          width: isMOBILE ? size.width * 0.9 : size.width * 0.8,
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
                              circleAvatar,
                            ],
                          ),
                          SizedBox(height: textScale * 7),
                          AppText(
                            text: currentChild != null
                                ? currentChild!.name
                                : AppLocalizations.of(context)!.childsName,
                            color: Colors.white,
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: textScale * 7),
                          correctedAge > 0
                              ? AppText(
                                  text: AppLocalizations.of(context)!
                                          .chronologicalAge +
                                      ": " +
                                      age.toString() +
                                      (age >= 10 || age == 1
                                          ? AppLocalizations.of(context)!
                                              .monthsOld
                                          : AppLocalizations.of(context)!
                                              .monthsOld2) +
                                      "\t" +
                                      AppLocalizations.of(context)!
                                          .correctedAge +
                                      ": " +
                                      correctedAge.toString() +
                                      (correctedAge >= 10 || correctedAge == 1
                                          ? AppLocalizations.of(context)!
                                              .monthsOld
                                          : AppLocalizations.of(context)!
                                              .monthsOld2),
                                  color: Colors.white,
                                  fontSize: textScale * 15,
                                )
                              : AppText(
                                  text: AppLocalizations.of(context)!
                                          .chronologicalAge +
                                      ": " +
                                      age.toString() +
                                      (age >= 10 || age == 1
                                          ? AppLocalizations.of(context)!
                                              .monthsOld
                                          : AppLocalizations.of(context)!
                                              .monthsOld2),
                                  color: Colors.white,
                                  fontSize: textScale * 15,
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: isMOBILE ? size.height * 0.01 : size.height * 0.005,
              ),
              correctedAge > 0
                  ? BlocBuilder<DecisionBloc, DecisionState>(
                      builder: (context, state) {
                        if (state is LoadedDecisionsByAgeState) {
                          double percentDone =
                              state.decisions.length / state.milestonesLength;
                          return InkWell(
                            child: Container(
                              width: isMOBILE
                                  ? size.width * 0.85
                                  : size.width * 0.75,
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
                                  SizedBox(height: textScale * 14),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: LinearPercentIndicator(
                                          animation: true,
                                          isRTL: isRTL,
                                          lineHeight: textScale * 15,
                                          animationDuration: 2500,
                                          percent: percentDone.isNaN
                                              ? 0
                                              : percentDone,
                                          progressColor: Colors.red,
                                        ),
                                      ),
                                      SizedBox(width: textScale * 10),
                                      AppText(
                                        text: state.decisions.length
                                                .toString() +
                                            "/" +
                                            state.milestonesLength.toString(),
                                        fontSize: textScale * 16,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              BlocProvider.of<LogBloc>(context).add(
                                AddLogEvent(
                                  log: LogModel(
                                    action: "open milestones page",
                                    description:
                                        "The user opened the milestones page from the home tab",
                                    takenAt: DateTime.now(),
                                  ),
                                ),
                              );
                              Navigator.pushNamed(context, Routes.milestone);
                            },
                          );
                        } else {
                          if (currentChild != null) {
                            BlocProvider.of<DecisionBloc>(context).add(
                                GetDecisionsByAgeEvent(child: currentChild!));
                          }
                          return Center(
                            child: SizedBox(
                              width: size.width * 0.3,
                              child: const LoadingIndicator(
                                indicatorType: Indicator.ballPulse,
                                colors: [AppColors.primaryColor],
                                strokeWidth: 1,
                                backgroundColor: Colors.white,
                                pathBackgroundColor: Colors.white,
                              ),
                            ),
                          );
                        }
                      },
                    )
                  : AppText(text: AppLocalizations.of(context)!.notReadyYet),
              const Spacer(),

              correctedAge > 0
                  ? BlocBuilder<AllPreviousDecisionTakenCubit,
                      Map<int, allTaken>>(builder: (context, state) {
                      if (currentChild != null) {
                        if (state[currentChild!.id] != null &&
                            !state[currentChild!.id]!.milestones) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMOBILE
                                  ? size.width * 0.03
                                  : size.width * 0.1,
                              vertical: isMOBILE ? 0 : size.height * 0.01,
                            ),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        summary,
                                        width: isMOBILE
                                            ? size.width * 0.45
                                            : size.width * 0.25,
                                      ),
                                      onTap: () {
                                        BlocProvider.of<LogBloc>(context).add(
                                          AddLogEvent(
                                            log: LogModel(
                                              action: "open childSummary page",
                                              description:
                                                  "The user opened the childSummary page from the home tab",
                                              takenAt: DateTime.now(),
                                            ),
                                          ),
                                        );
                                        Navigator.pushNamed(
                                            context, Routes.childSummary);
                                      },
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 12,
                                          minHeight: 12,
                                        ),
                                        child: Icon(
                                          Icons.crisis_alert,
                                          color: Colors.white,
                                          size: textScale * 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // SizedBox(width: size.width * 0.01),
                                Expanded(child: SizedBox.shrink()),

                                Stack(
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        vaccinesIcon,
                                        width: isMOBILE
                                            ? size.width * 0.45
                                            : size.width * 0.25,
                                      ),
                                      onTap: () {
                                        BlocProvider.of<LogBloc>(context).add(
                                          AddLogEvent(
                                            log: LogModel(
                                              action: "open vaccines page",
                                              description:
                                                  "The user opened the vaccines page from the home tab",
                                              takenAt: DateTime.now(),
                                            ),
                                          ),
                                        );
                                        Navigator.pushNamed(
                                            context, Routes.vaccine);
                                      },
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 12,
                                          minHeight: 12,
                                        ),
                                        child: Icon(
                                          Icons.crisis_alert,
                                          color: Colors.white,
                                          size: textScale * 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Expanded(child: SizedBox.shrink()),
                                // SizedBox(
                                //   width: isMOBILE
                                //       ? size.width * 0.40
                                //       : size.width * 0.45,
                                //   child: Center(
                                //     child: AppText(
                                //       text:
                                //           "لا زال يوحد بعض المتابعات من مراحل سابقة لم يتم الاجابة عنها، نرجو منكم الدخول إلى صفحة للاجابة.",
                                //       color: Colors.red,
                                //       fontSize: textScale * 16,
                                //     ),
                                //   ),
                                // ),
                                // const Spacer(),
                                // InkWell(
                                //   borderRadius: BorderRadius.circular(12),
                                //   child: Image.asset(
                                //     tips,
                                //     width: size.width * 0.4,
                                //   ),
                                //   onTap: () async {
                                //     // launchUrl(Uri.parse(widget.milestoneItem.videoPath!));
                                //     // widget.changeIndex(2);

                                //     BlocProvider.of<DecisionBloc>(context)
                                //         .add(const UploadDecisionsEvent());
                                //     // _logout();
                                //   },
                                // ),
                              ],
                            ),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMOBILE
                                  ? size.width * 0.03
                                  : size.width * 0.1,
                              vertical: isMOBILE ? 0 : size.height * 0.01,
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    summary,
                                    width: isMOBILE
                                        ? size.width * 0.45
                                        : size.width * 0.3,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Routes.childSummary);
                                  },
                                ),
                                Expanded(child: SizedBox.shrink()),
                                InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    vaccinesIcon,
                                    width: isMOBILE
                                        ? size.width * 0.45
                                        : size.width * 0.25,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Routes.vaccine);
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return const SizedBox.shrink();
                    })
                  : const SizedBox.shrink(),
              SizedBox(height: size.height * 0.01),
              // InkWell(
              //   borderRadius: BorderRadius.circular(12),
              //   child: Text("testing"),
              //   onTap: () async {
              //     final NotificationRepository notificationRepository;
              //     final NotificationService _notificationService =
              //         NotificationService();

              //     await _notificationService.showNotifications(
              //       title: "title",
              //       body: "body",
              //     );
              //   },
              // ),
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
