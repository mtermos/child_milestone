import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/decision.dart';
import 'package:child_milestone/logic/blocs/decision/decision_bloc.dart';
import 'package:child_milestone/logic/blocs/milestone/milestone_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MilestoneItemWidget extends StatefulWidget {
  const MilestoneItemWidget(
      {Key? key, required this.item, required this.selectedPeriod})
      : super(key: key);
  final MilestoneWithDecision item;
  final Period selectedPeriod;

  @override
  _MilestoneItemWidgetState createState() => _MilestoneItemWidgetState();
}

class _MilestoneItemWidgetState extends State<MilestoneItemWidget> {
  ChildModel? selected_child;
  int decision = 0;

  @override
  void initState() {
    // check months
    check_child();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isMOBILE = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final textScale = isMOBILE
        ? MediaQuery.of(context).size.height * 0.001
        : MediaQuery.of(context).size.height * 0.0011;
    return Container(
      margin: EdgeInsets.only(
        bottom: size.height * 0.05,
        right: size.width * 0.01,
        left: size.width * 0.01,
      ),
      width: size.width * 0.8,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Positioned(
                child: Center(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    widget.item.milestoneItem.imagePath ?? "",
                    alignment: Alignment.topCenter,
                    color: Colors.white.withOpacity(0.8),
                    colorBlendMode: BlendMode.modulate,
                  ),
                )),
              ),
              Positioned(
                bottom: size.height * 0.01,
                child: Container(
                  width: size.width * 0.7,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(textScale * 2, textScale * 4),
                        blurRadius: textScale * 8,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: textScale * 15,
                    horizontal: textScale * 20,
                  ),
                  child: AppText(
                    text: widget.item.milestoneItem.description,
                    textAlign: TextAlign.right,
                    fontSize: isMOBILE ? textScale * 18 : textScale * 18,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: size.width * 0.05),
              InkWell(
                onTap: () {
                  if (selected_child != null) {
                    setState(() {
                      decision = 1;
                    });
                    BlocProvider.of<DecisionBloc>(context).add(AddDecisionEvent(
                      decision: DecisionModel(
                        childId: selected_child!.id,
                        milestoneId: widget.item.milestoneItem.id,
                        vaccineId: 0,
                        decision: 1,
                        takenAt: DateTime.now(),
                      ),
                      onSuccess: () {
                        BlocProvider.of<MilestoneBloc>(context).add(
                            GetMilestonesWithDecisionsByPeriodEvent(
                                child: selected_child!,
                                periodId: widget.selectedPeriod.id));
                      },
                      appLocalizations: AppLocalizations.of(context)!,
                    ));
                  }
                },
                child: Container(
                  width: size.width * 0.15,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    color: widget.item.decision.decision == 1
                        ? Colors.green[200]
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(textScale * 2, textScale * 4),
                        blurRadius: textScale * 8,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: textScale * 15,
                  ),
                  alignment: Alignment.center,
                  child: AppText(
                    text: AppLocalizations.of(context)!.yes,
                    textAlign: TextAlign.right,
                    fontSize: isMOBILE ? textScale * 20 : textScale * 18,
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.01),
              InkWell(
                onTap: () {
                  if (selected_child != null) {
                    setState(() {
                      decision = 2;
                    });
                    BlocProvider.of<DecisionBloc>(context).add(AddDecisionEvent(
                      decision: DecisionModel(
                        childId: selected_child!.id,
                        milestoneId: widget.item.milestoneItem.id,
                        vaccineId: 0,
                        decision: 2,
                        takenAt: DateTime.now(),
                      ),
                      onSuccess: () {
                        BlocProvider.of<MilestoneBloc>(context).add(
                            GetMilestonesWithDecisionsByPeriodEvent(
                                child: selected_child!,
                                periodId: widget.selectedPeriod.id));
                      },
                      appLocalizations: AppLocalizations.of(context)!,
                    ));
                    // BlocProvider.of<DecisionBloc>(context).add(
                    //     GetDecisionsByAgeEvent(
                    //         dateOfBirth: selected_child!.dateOfBirth));
                  }
                },
                child: Container(
                  width: size.width * 0.15,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    color: widget.item.decision.decision == 2
                        ? Colors.red[200]
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(textScale * 2, textScale * 4),
                        blurRadius: textScale * 8,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: textScale * 15,
                  ),
                  alignment: Alignment.center,
                  child: AppText(
                    text: AppLocalizations.of(context)!.no,
                    textAlign: TextAlign.right,
                    fontSize: isMOBILE ? textScale * 20 : textScale * 18,
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.01),
              InkWell(
                onTap: () {
                  if (selected_child != null) {
                    setState(() {
                      decision = 3;
                    });
                    BlocProvider.of<DecisionBloc>(context).add(AddDecisionEvent(
                      decision: DecisionModel(
                        childId: selected_child!.id,
                        milestoneId: widget.item.milestoneItem.id,
                        vaccineId: 0,
                        decision: 3,
                        takenAt: DateTime.now(),
                      ),
                      onSuccess: () {
                        BlocProvider.of<MilestoneBloc>(context).add(
                            GetMilestonesWithDecisionsByPeriodEvent(
                                child: selected_child!,
                                periodId: widget.selectedPeriod.id));
                      },
                      appLocalizations: AppLocalizations.of(context)!,
                    ));
                  }
                },
                child: Container(
                  width: size.width * 0.15,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    color: widget.item.decision.decision == 3
                        ? Colors.yellow[200]
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(textScale * 2, textScale * 4),
                        blurRadius: textScale * 8,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: textScale * 15,
                  ),
                  child: AppText(
                    text: AppLocalizations.of(context)!.maybe,
                    textAlign: TextAlign.right,
                    fontSize: isMOBILE ? textScale * 20 : textScale * 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  check_child() async {
    ChildModel? child =
        await BlocProvider.of<CurrentChildCubit>(context).getCurrentChild();
    if (child != null) {
      BlocProvider.of<DecisionBloc>(context).add(
          GetDecisionByChildAndMilestoneEvent(
              childId: child.id, milestoneId: widget.item.milestoneItem.id));
      setState(() {
        selected_child = child;
      });
    }
  }
}
