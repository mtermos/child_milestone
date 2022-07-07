import 'package:child_milestone/constants/classes.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/logic/blocs/decision/decision_bloc.dart';
import 'package:child_milestone/logic/blocs/milestone/milestone_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/components/top_bar_view.dart';
import 'package:child_milestone/presentation/screens/add_child/add_child_form.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChildSummaryScreen extends StatefulWidget {
  const ChildSummaryScreen({Key? key}) : super(key: key);

  @override
  _ChildSummaryScreenState createState() => _ChildSummaryScreenState();
}

class _ChildSummaryScreenState extends State<ChildSummaryScreen> {
  ChildModel? currentChild;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
    Image tips_bg = Image.asset(
      "assets/images/tips_bg.png",
      alignment: Alignment.topCenter,
      width: size.width,
    );

    return Scaffold(
      body: BlocBuilder<CurrentChildCubit, CurrentChildState>(
        builder: (context, state) {
          if (state is CurrentChildChangedState) {
            currentChild = state.new_current_child;
            BlocProvider.of<MilestoneBloc>(context).add(
                GetMilestonesWithDecisionsByChildEvent(
                    child: state.new_current_child));
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top,
                  color: AppColors.primaryColorDarker,
                ),
                Container(
                  color: AppColors.primaryColorDarker,
                  child: TopBarView(backRoute: true, light: true),
                ),
                SizedBox(
                  width: size.width,
                  height: size.width * 0.85,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        right: 0,
                        child: tips_bg,
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
                                        backgroundImage: Image.asset(
                                                currentChild!.image_path)
                                            .image)
                                    : CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: size.width * 0.16,
                                      ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.035),
                            AppText(
                              text: AppLocalizations.of(context)!.childSummary,
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
                SizedBox(height: size.height * 0.05),
                BlocBuilder<MilestoneBloc, MilestoneState>(
                  builder: (context, state) {
                    if (state is LoadedMilestonesWithDecisionsByChildState) {
                      List<MilestoneWithDecision> yesDecisions = state.items
                          .where((element) => element.decision.decision == 1)
                          .toList();
                      List<MilestoneWithDecision> noDecisions = state.items
                          .where((element) => element.decision.decision == 2)
                          .toList();
                      List<MilestoneWithDecision> maybeDecisions = state.items
                          .where((element) => element.decision.decision == 3)
                          .toList();
                      return Column(
                        children: [
                          AppText(text: "YES"),
                          Column(
                            children: yesDecisions
                                .map((e) =>
                                    AppText(text: e.milestoneItem.description))
                                .toList(),
                          ),
                          AppText(text: "No"),
                          Column(
                            children: noDecisions
                                .map((e) =>
                                    AppText(text: e.milestoneItem.description))
                                .toList(),
                          ),
                          AppText(text: "MAYBE"),
                          Column(
                            children: maybeDecisions
                                .map((e) =>
                                    AppText(text: e.milestoneItem.description))
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
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.25),
                  child: AppButton(
                    label: AppLocalizations.of(context)!.goBack,
                    color: AppColors.primaryColorDarker,
                    fontWeight: FontWeight.w600,
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.1),
              ],
            ),
          );
        },
      ),
    );
  }
}
