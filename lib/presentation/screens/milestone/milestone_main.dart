// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/milestone_category.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/logic/blocs/milestone/milestone_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/components/top_bar_view.dart';
import 'package:child_milestone/presentation/screens/milestone/milestone_item_widget.dart';
import 'package:child_milestone/presentation/widgets/category_box_widget.dart';

class MilestoneScreen extends StatefulWidget {
  int? category;
  MilestoneScreen({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  _MilestoneScreenState createState() => _MilestoneScreenState();
}

class _MilestoneScreenState extends State<MilestoneScreen> {
  int _selected = 1;
  ChildModel? current_child;
  List<MilestoneWithDecision> items = [];
  @override
  void initState() {
    _selected = widget.category ?? 1;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;

// cagtegories:
//   1: movement
//   2: perception
//   3: communication
//   4: interaction
    List<MilestoneCategoryModel> cagtegories = [
      MilestoneCategoryModel(
        id: 1,
        name: AppLocalizations.of(context)!.movement,
        icon_path: "assets/icons/milestone_page/movement_category.png",
      ),
      MilestoneCategoryModel(
        id: 2,
        name: AppLocalizations.of(context)!.perception,
        icon_path: "assets/icons/milestone_page/cognitive_category.png",
      ),
      MilestoneCategoryModel(
        id: 3,
        name: AppLocalizations.of(context)!.communication,
        icon_path: "assets/icons/milestone_page/language_category.png",
      ),
      MilestoneCategoryModel(
        id: 4,
        name: AppLocalizations.of(context)!.interaction,
        icon_path: "assets/icons/milestone_page/social_category.png",
      ),
    ];

    return Scaffold(
      body: BlocBuilder<CurrentChildCubit, CurrentChildState>(
        builder: (context, state) {
          if (state is CurrentChildChangedState) {
            current_child = state.new_current_child;
            BlocProvider.of<MilestoneBloc>(context).add(
                GetMilestonesWithDecisionsByAgeEvent(child: current_child!));
          }
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              TopBarView(backRoute: true),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.02),
                      Container(
                        alignment: AlignmentDirectional.topStart,
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: AppText(
                          text:
                              AppLocalizations.of(context)!.milestoneChecklist,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.02),
                        child: Row(
                          children: cagtegories.map((e) {
                            return Expanded(
                              flex: 1,
                              child: InkWell(
                                highlightColor: null,
                                onTap: () {
                                  setState(() {
                                    _selected = e.id;
                                  });
                                },
                                child: CategoryBoxWidget(
                                  item: e,
                                  selected: _selected,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      BlocBuilder<MilestoneBloc, MilestoneState>(
                        builder: (context, state) {
                          if (state
                              is LoadedMilestonesWithDecisionsByAgeState) {
                            items = state.items;
                          }
                          return Column(
                            children: items
                                .where((element) =>
                                    element.milestoneItem.category == _selected)
                                .map((e) => MilestoneItemWidget(item: e))
                                .toList(),
                          );
                        },
                      )
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
}
