import 'dart:io';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/decision.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/logic/blocs/decision/decision_bloc.dart';
import 'package:child_milestone/logic/blocs/milestone/milestone_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MilestoneItemWidget extends StatefulWidget {
  const MilestoneItemWidget({Key? key, required this.item}) : super(key: key);
  final MilestoneItem item;

  @override
  _MilestoneItemWidgetState createState() => _MilestoneItemWidgetState();
}

class _MilestoneItemWidgetState extends State<MilestoneItemWidget> {
  ChildModel? selected_child;
  int decision = 0;

  @override
  void initState() {
    check_child();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
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
                    widget.item.imagePath ?? "",
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
                    borderRadius: BorderRadius.all(Radius.circular(6)),
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
                  child: Text(
                    widget.item.description,
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
          BlocListener<DecisionBloc, DecisionState>(
              listener: (context, state) {
                if (state is LoadedDecisionByChildAndMilestoneState &&
                    state.decision.milestoneId == widget.item.id) {
                  if (selected_child != null &&
                      state.decision.childId == selected_child!.id) {
                    setState(() {
                      decision = state.decision.decision;
                    });
                  }
                } else if (state is AddedDecisionState &&
                    state.decision.milestoneId == widget.item.id) {
                  setState(() {
                    decision = state.decision.decision;
                  });
                }
              },
              child: Row(
                children: [
                  SizedBox(width: size.width * 0.05),
                  InkWell(
                    onTap: () {
                      if (selected_child != null) {
                        setState(() {
                          decision = 1;
                        });
                        BlocProvider.of<DecisionBloc>(context)
                            .add(AddDecisionEvent(
                          decision: DecisionModel(
                            childId: selected_child!.id,
                            milestoneId: widget.item.id,
                            decision: 1,
                            takenAt: DateTime.now(),
                          ),
                        ));
                      }
                    },
                    child: Container(
                      width: size.width * 0.15,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: decision == 1 ? Colors.green[200] : Colors.white,
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
                      child: Text(
                        AppLocalizations.of(context)!.yes,
                        textAlign: TextAlign.right,
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
                        BlocProvider.of<DecisionBloc>(context)
                            .add(AddDecisionEvent(
                          decision: DecisionModel(
                            childId: selected_child!.id,
                            milestoneId: widget.item.id,
                            decision: 2,
                            takenAt: DateTime.now(),
                          ),
                        ));
                        // BlocProvider.of<DecisionBloc>(context).add(
                        //     GetDecisionsByAgeEvent(
                        //         dateOfBirth: selected_child!.date_of_birth));
                      }
                    },
                    child: Container(
                      width: size.width * 0.15,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: decision == 2 ? Colors.red[200] : Colors.white,
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
                      child: Text(
                        AppLocalizations.of(context)!.no,
                        textAlign: TextAlign.right,
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
                        BlocProvider.of<DecisionBloc>(context)
                            .add(AddDecisionEvent(
                          decision: DecisionModel(
                            childId: selected_child!.id,
                            milestoneId: widget.item.id,
                            decision: 3,
                            takenAt: DateTime.now(),
                          ),
                        ));
                      }
                    },
                    child: Container(
                      width: size.width * 0.15,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: decision == 3 ? Colors.blue[200] : Colors.white,
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
                      child: Text(
                        AppLocalizations.of(context)!.maybe,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  check_child() async {
    ChildModel? child =
        await BlocProvider.of<CurrentChildCubit>(context).get_current_child();
    if (child != null) {
      BlocProvider.of<DecisionBloc>(context).add(
          GetDecisionByChildAndMilestoneEvent(
              childId: child.id, milestoneId: widget.item.id));
      setState(() {
        selected_child = child;
      });
    }
  }
}
