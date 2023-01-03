import 'dart:io';

import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:child_milestone/logic/blocs/decision/decision_bloc.dart';
import 'package:child_milestone/logic/cubits/all_previous_decision_taken/all_previous_decision_taken_cubit.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/logic/shared/functions.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    BlocProvider.of<ChildBloc>(context).add(GetAllChildrenEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String profilePicBg = "assets/images/profile_pic_bg.svg";
    String summary = "assets/images/summary.png";
    String tips = "assets/images/tips.png";
    String arrowsDown = "assets/icons/arrows-down.svg";
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
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
      body: BlocBuilder<ChildBloc, ChildState>(
        builder: (context, state) {
          if (state is! AllChildrenLoadedState) {
            return const SizedBox.shrink();
          }
          if (state.children.isEmpty) {
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
          return BlocBuilder<CurrentChildCubit, CurrentChildState>(
            builder: (context, state) {
              CircleAvatar circleAvatar = CircleAvatar(
                backgroundColor: Colors.white,
                radius: size.width * 0.16,
              );
              if (state is CurrentChildChangedState) {
                currentChild = state.new_current_child;
                int daysCorrected =
                    (37 - currentChild!.pregnancyDuration.toInt()) * 7;
                DateTime dateOfBirth = currentChild!.dateOfBirth
                    .add(Duration(days: daysCorrected));
                age = DateTime.now()
                        .difference(currentChild!.dateOfBirth)
                        .inDays ~/
                    30;
                correctedAge =
                    DateTime.now().difference(dateOfBirth).inDays ~/ 30;
                try {
                  circleAvatar = CircleAvatar(
                    radius: size.width * 0.15,
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
                    height: size.width * 0.65,
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
                                          (correctedAge >= 10 ||
                                                  correctedAge == 1
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
                    height: size.height * 0.01,
                  ),
                  correctedAge > 0
                      ? BlocBuilder<DecisionBloc, DecisionState>(
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
                                          Text(state.decisions.length
                                                  .toString() +
                                              "/" +
                                              state.milestonesLength
                                                  .toString()),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, Routes.milestone);
                                },
                              );
                            } else {
                              if (currentChild != null) {
                                BlocProvider.of<DecisionBloc>(context).add(
                                    GetDecisionsByAgeEvent(
                                        child: currentChild!));
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
                      : AppText(
                          text: AppLocalizations.of(context)!.notReadyYet),
                  const Spacer(),

                  correctedAge > 0
                      ? BlocBuilder<AllPreviousDecisionTakenCubit,
                          Map<int, bool>>(builder: (context, state) {
                          if (currentChild != null) {
                            if (state[currentChild!.id] != null &&
                                !state[currentChild!.id]!) {
                              return Row(
                                children: [
                                  SizedBox(width: size.width * 0.035),
                                  Stack(
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          summary,
                                          width: size.width * 0.45,
                                        ),
                                        onTap: () {
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
                                  SizedBox(width: size.width * 0.03),
                                  SizedBox(
                                    width: size.width * 0.45,
                                    child: Center(
                                      child: AppText(
                                        text:
                                            "لا زال يوحد بعض المتابعات من مراحل سابقة لم يتم الاجابة عنها، نرجو منكم الدخول إلى صفحة للاجابة.",
                                        color: Colors.red,
                                        fontSize: textScale * 18,
                                      ),
                                    ),
                                  ),
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
                                  SizedBox(width: size.width * 0.035),
                                ],
                              );
                            } else {
                              return Center(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    summary,
                                    width: size.width * 0.45,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Routes.childSummary);
                                  },
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }
                          return const SizedBox.shrink();
                        })
                      : SizedBox.shrink(),
                  SizedBox(height: size.height * 0.01),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    child: Text("testing"),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.splashScreen);
                    },
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
          );
        },
      ),
    );
  }
}
