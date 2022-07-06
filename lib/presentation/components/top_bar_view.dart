// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:child_milestone/logic/blocs/decision/decision_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopBarView extends StatefulWidget {
  bool? back_route;
  TopBarView({
    Key? key,
    bool? this.back_route = false,
  }) : super(key: key);

  @override
  _TopBarViewState createState() => _TopBarViewState();
}

class _TopBarViewState extends State<TopBarView> with TickerProviderStateMixin {
  static const String settings_icon =
      "assets/icons/home_page/settings_icon.svg";
  static const String side_nav_icon =
      "assets/icons/home_page/side_nav_icon.svg";

  List<ChildModel>? childrenList;
  ChildModel? selected_child;

  @override
  void initState() {
    BlocProvider.of<ChildBloc>(context).add(GetAllChildrenEvent());
    check_child();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;

    bool isRTL = AppLocalizations.of(context)!.localeName == "ar";
    String chevron_duo_left = "assets/icons/chevron_duo_left.svg";
    if (isRTL) {
      chevron_duo_left = "assets/icons/home_page/double_arrows.svg";
    }

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(0.0, 0.0, 0.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: size.height * 0.06,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.04,
                    right: size.width * 0.04,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            // SvgPicture.asset(side_nav_icon),
                            // SizedBox(
                            //   width: size.width * 0.02,
                            // ),
                            widget.back_route!
                                ? InkWell(
                                    child: SvgPicture.asset(
                                      chevron_duo_left,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: BlocBuilder<ChildBloc, ChildState>(
                          builder: (context, state) {
                            if (state is AllChildrenLoadedState) {
                              childrenList = state.children;
                            } else {
                              childrenList = [];
                            }
                            return Center(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<ChildModel>(
                                  value: selected_child,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  alignment: AlignmentDirectional.center,
                                  hint: Text("select a child"),
                                  items: childrenList!
                                      .map<DropdownMenuItem<ChildModel>>(
                                          (ChildModel value) {
                                    return DropdownMenuItem<ChildModel>(
                                      value: value,
                                      alignment: AlignmentDirectional.center,
                                      child: Text(value.name),
                                    );
                                  }).toList(),
                                  onChanged: (ChildModel? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        selected_child = newValue;
                                      });
                                      BlocProvider.of<CurrentChildCubit>(
                                              context)
                                          .changeCurrentChild(newValue, () {
                                        BlocProvider.of<DecisionBloc>(context)
                                            .add(GetDecisionsByAgeEvent(
                                                dateOfBirth:
                                                    newValue.date_of_birth,
                                                childId: newValue.id));
                                      });
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: InkWell(
                            child: SvgPicture.asset(settings_icon),
                            onTap: () {
                              Navigator.pushNamed(context, "/settings");
                            },
                          ),
                          alignment: AlignmentDirectional.centerEnd,
                        ),
                        // child: Text(""),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  check_child() async {
    ChildModel? child =
        await BlocProvider.of<CurrentChildCubit>(context).getCurrentChild();
    if (child != null) {
      setState(() {
        selected_child = child;
      });
    }
  }
}
