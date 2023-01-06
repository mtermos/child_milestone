import 'dart:io';

import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/constants/monthly_periods.dart';
import 'package:child_milestone/constants/yearly_periods.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/logic/blocs/milestone/milestone_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/logic/shared/functions.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/components/top_bar_view.dart';
import 'package:child_milestone/presentation/screens/child_summary/milestone_summary_widget.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';

class ChildSummaryScreen extends StatefulWidget {
  const ChildSummaryScreen({Key? key}) : super(key: key);

  @override
  _ChildSummaryScreenState createState() => _ChildSummaryScreenState();
}

class _ChildSummaryScreenState extends State<ChildSummaryScreen> {
  ChildModel? currentChild;
  Period? currentPeriod;
  Period? selectedPeriod;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
    Image tipsBg = Image.asset(
      "assets/images/tips_bg.png",
      alignment: Alignment.topCenter,
      width: size.width,
    );

    return Scaffold(
      body: BlocBuilder<CurrentChildCubit, CurrentChildState>(
        builder: (context, state) {
          if (state is CurrentChildChangedState) {
            currentChild = state.new_current_child;
            currentPeriod = periodCalculator(currentChild!);
            if (selectedPeriod == null ||
                currentPeriod!.id < selectedPeriod!.id) {
              selectedPeriod = currentPeriod;
            }
            BlocProvider.of<MilestoneBloc>(context).add(
                GetMilestonesForSummaryEvent(
                    child: state.new_current_child,
                    periodId: selectedPeriod!.id));
          }
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: MediaQuery.of(context).padding.top,
                color: AppColors.primaryColorDarker,
              ),
              Container(
                color: AppColors.primaryColorDarker,
                child: const TopBarView(
                    hasBackBottun: true, hasDropDown: false, light: true),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: size.width,
                        height: size.width * 0.85,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Positioned(
                              top: 0,
                              right: 0,
                              child: tipsBg,
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
                                              backgroundColor: Colors.white,
                                              backgroundImage: currentChild!
                                                          .imagePath !=
                                                      ""
                                                  ? Image.file(File(
                                                          currentChild!
                                                              .imagePath))
                                                      .image
                                                  : Image.asset(noImageAsset(
                                                          currentChild!))
                                                      .image)
                                          : CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: size.width * 0.16,
                                            ),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.035),
                                  AppText(
                                    text: AppLocalizations.of(context)!
                                        .childSummary,
                                    color: Colors.white,
                                    fontSize: size.height * 0.03,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      periodDropDownList(currentPeriod!.id, size, textScale),
                      SizedBox(height: size.height * 0.04),
                      AppText(
                        text: AppLocalizations.of(context)!.milestones,
                        fontSize: textScale * 32,
                        color: Colors.black,
                      ),
                      SizedBox(height: size.height * 0.02),
                      BlocBuilder<MilestoneBloc, MilestoneState>(
                        builder: (context, state) {
                          if (state is LoadedMilestonesForSummaryState) {
                            List<MilestoneWithDecision> yesDecisions = state
                                .items
                                .where(
                                    (element) => element.decision.decision == 1)
                                .toList();
                            List<MilestoneWithDecision> noDecisions = state
                                .items
                                .where(
                                    (element) => element.decision.decision == 2)
                                .toList();
                            List<MilestoneWithDecision> maybeDecisions = state
                                .items
                                .where(
                                    (element) => element.decision.decision == 3)
                                .toList();
                            List<MilestoneWithDecision> unansweredDecisions =
                                state.items
                                    .where((element) =>
                                        element.decision.decision != 1 &&
                                        element.decision.decision != 2 &&
                                        element.decision.decision != 3)
                                    .toList();
                            return Column(
                              children: [
                                Container(
                                  width: size.width * 0.8,
                                  padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.015,
                                    horizontal: size.width * 0.05,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: AppText(
                                      text: AppLocalizations.of(context)!
                                          .unansweredTitle,
                                      textAlign: TextAlign.center,
                                      fontSize: textScale * 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.02),
                                Column(
                                  children: unansweredDecisions.isEmpty
                                      ? [SizedBox(height: size.height * 0.03)]
                                      : unansweredDecisions
                                          .mapIndexed(
                                            (index, e) => MilestoneSummaryItem(
                                              milestoneItem: e.milestoneItem,
                                              child: currentChild!,
                                              redFlag: e.milestoneItem.period !=
                                                  state.period,
                                              decision: -1,
                                              editable: true,
                                              topBar: index != 0,
                                              key: ValueKey(e.milestoneItem.id
                                                  .toString()),
                                            ),
                                          )
                                          .toList(),
                                ),
                                SizedBox(height: size.height * 0.02),
                                Container(
                                  width: size.width * 0.8,
                                  padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.015,
                                    horizontal: size.width * 0.05,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: AppText(
                                      text: AppLocalizations.of(context)!
                                          .yesTitle,
                                      textAlign: TextAlign.center,
                                      fontSize: textScale * 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.02),
                                Column(
                                  children: yesDecisions.isEmpty
                                      ? [SizedBox(height: size.height * 0.03)]
                                      : yesDecisions
                                          .mapIndexed(
                                            (index, e) => MilestoneSummaryItem(
                                              milestoneItem: e.milestoneItem,
                                              child: currentChild!,
                                              redFlag: e.milestoneItem.period !=
                                                  state.period,
                                              decision: 1,
                                              editable: true,
                                              topBar: index != 0,
                                              key: ValueKey(e.milestoneItem.id
                                                  .toString()),
                                            ),
                                          )
                                          .toList(),
                                ),
                                SizedBox(height: size.height * 0.02),
                                Container(
                                  width: size.width * 0.8,
                                  padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.015,
                                    horizontal: size.width * 0.05,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.red[900],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: AppText(
                                      text:
                                          AppLocalizations.of(context)!.noTitle,
                                      textAlign: TextAlign.center,
                                      fontSize: textScale * 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.02),
                                Column(
                                  children: noDecisions.isEmpty
                                      ? [SizedBox(height: size.height * 0.03)]
                                      : noDecisions
                                          .mapIndexed(
                                            (index, e) => MilestoneSummaryItem(
                                              milestoneItem: e.milestoneItem,
                                              child: currentChild!,
                                              redFlag: e.milestoneItem.period !=
                                                  state.period,
                                              decision: 2,
                                              editable: true,
                                              topBar: index != 0,
                                              key: ValueKey(e.milestoneItem.id
                                                  .toString()),
                                            ),
                                          )
                                          .toList(),
                                ),
                                SizedBox(height: size.height * 0.02),
                                Container(
                                  width: size.width * 0.8,
                                  padding: EdgeInsets.symmetric(
                                    vertical: size.height * 0.015,
                                    horizontal: size.width * 0.05,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: AppText(
                                      text: AppLocalizations.of(context)!
                                          .maybeTitle,
                                      textAlign: TextAlign.center,
                                      fontSize: textScale * 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.02),
                                Column(
                                  children: maybeDecisions.isEmpty
                                      ? [SizedBox(height: size.height * 0.03)]
                                      : maybeDecisions
                                          .mapIndexed(
                                            (index, e) => MilestoneSummaryItem(
                                              milestoneItem: e.milestoneItem,
                                              child: currentChild!,
                                              redFlag: e.milestoneItem.period !=
                                                  state.period,
                                              decision: 3,
                                              editable: true,
                                              topBar: index != 0,
                                              key: ValueKey(e.milestoneItem.id
                                                  .toString()),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
                      SizedBox(height: size.height * 0.05),
                      Container(
                        alignment: Alignment.center,
                        width: size.width * 0.8,
                        margin:
                            EdgeInsets.symmetric(horizontal: size.width * 0.25),
                        child: AppButton(
                          label: AppLocalizations.of(context)!.homePage,
                          color: AppColors.primaryColorDarker,
                          fontWeight: FontWeight.w600,
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.02),
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.popAndPushNamed(context, Routes.home);
                          },
                        ),
                      ),
                      SizedBox(height: size.height * 0.1),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget periodDropDownList(int maxPeriod, Size size, double textScale) {
    List<Period> periods = [];
    if (maxPeriod <= 10) {
      periods = monthlyPeriods.sublist(0, maxPeriod);
    } else if (maxPeriod == 11) {
      periods.addAll(monthlyPeriods);
      periods.add(yearlyPeriods[0]);
    } else if (maxPeriod == 12) {
      periods.addAll(monthlyPeriods);
      periods.addAll(yearlyPeriods);
    }
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, //Center Row contents horizontally,
      crossAxisAlignment:
          CrossAxisAlignment.center, //Center Row contents vertically,

      children: [
        SizedBox(width: size.width * 0.05),
        AppText(
          text: AppLocalizations.of(context)!.period + ":",
          fontSize: textScale * 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        Expanded(
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Period>(
                selectedItemBuilder: (context) => periods.map<Widget>((e) {
                  return Center(
                    child: AppText(
                      text: e.arabicNameNumbers,
                      fontSize: textScale * 24,
                      color: Colors.black,
                    ),
                  );
                }).toList(),
                value: selectedPeriod,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                // alignment: AlignmentDirectional.center,
                hint: AppText(
                  text: AppLocalizations.of(context)!.selectPeriod,
                  fontSize: textScale * 20,
                ),
                isExpanded: true,
                items: periods.map<DropdownMenuItem<Period>>((Period value) {
                  return DropdownMenuItem<Period>(
                    value: value,
                    alignment: AlignmentDirectional.center,
                    child: Row(
                      children: [
                        AppText(
                          text: value.arabicNameNumbers,
                          fontSize: textScale * 24,
                          // color: widget.light
                          //     ? Colors.white
                          //     : Colors.black,
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (Period? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedPeriod = newValue;
                    });
                  }
                },
              ),
            ),
          ),
        ),
        SizedBox(width: size.width * 0.1),
      ],
    );
  }
}
