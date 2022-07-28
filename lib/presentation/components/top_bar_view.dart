// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:child_milestone/logic/blocs/decision/decision_bloc.dart';
import 'package:child_milestone/logic/cubits/all_previous_decision_taken/all_previous_decision_taken_cubit.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopBarView extends StatefulWidget {
  final bool hasBackBottun;
  final String? backRoute;
  final bool light;
  const TopBarView({
    Key? key,
    this.hasBackBottun = false,
    this.backRoute,
    this.light = false,
  }) : super(key: key);

  @override
  _TopBarViewState createState() => _TopBarViewState();
}

class _TopBarViewState extends State<TopBarView> with TickerProviderStateMixin {
  static const String settingsIcon = "assets/icons/home_page/settings_icon.svg";
  // static const String sideNavIcon =
  //     "assets/icons/home_page/side_nav_icon.svg";

  List<ChildModel>? childrenList;
  ChildModel? selectedChild;
  GlobalKey dropDownKey = GlobalKey();

  @override
  void initState() {
    BlocProvider.of<ChildBloc>(context).add(GetAllChildrenEvent());
    checkChild();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;

    bool isRTL = AppLocalizations.of(context)!.localeName == "ar";
    String chevronDuoLeft = "assets/icons/chevron_duo_left.svg";
    if (isRTL) {
      chevronDuoLeft = "assets/icons/home_page/double_arrows.svg";
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
                            // SvgPicture.asset(sideNavIcon),
                            // SizedBox(
                            //   width: size.width * 0.02,
                            // ),
                            widget.hasBackBottun
                                ? InkWell(
                                    child: SvgPicture.asset(
                                      chevronDuoLeft,
                                      color: widget.light
                                          ? Colors.white
                                          : AppColors.primaryColor,
                                    ),
                                    onTap: () {
                                      if (widget.backRoute != null) {
                                        Navigator.popAndPushNamed(
                                            context, widget.backRoute!);
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: BlocBuilder<ChildBloc, ChildState>(
                          builder: (context, state) {
                            if (state is AllChildrenLoadedState) {
                              childrenList = state.children;
                            } else {
                              childrenList = [];
                              selectedChild = null;
                            }
                            return Center(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<ChildModel>(
                                  key: dropDownKey,
                                  selectedItemBuilder: (context) =>
                                      childrenList!.map<Widget>((e) {
                                    return Center(
                                      child: AppText(
                                        text: e.name,
                                        fontSize: textScale * 24,
                                        color: widget.light
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    );
                                  }).toList(),
                                  value: selectedChild,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: widget.light
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  alignment: AlignmentDirectional.center,
                                  hint: AppText(
                                    text: AppLocalizations.of(context)!
                                        .selectChild,
                                    fontSize: textScale * 20,
                                  ),
                                  isExpanded: true,
                                  items: childrenList!
                                      .map<DropdownMenuItem<ChildModel>>(
                                          (ChildModel value) {
                                    return DropdownMenuItem<ChildModel>(
                                      value: value,
                                      alignment: AlignmentDirectional.center,
                                      child: Row(
                                        children: [
                                          AppText(
                                            text: value.name,
                                            fontSize: textScale * 24,
                                            // color: widget.light
                                            //     ? Colors.white
                                            //     : Colors.black,
                                          ),
                                          const Spacer(),
                                          // SizedBox(width: size.width * 0.1),
                                          InkWell(
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        size.height * 0.005,
                                                    horizontal:
                                                        size.width * 0.02),
                                                decoration: const BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                child: const AppText(
                                                  text: "edit",
                                                  color: Colors.white,
                                                )),
                                            onTap: () {
                                              Navigator.popAndPushNamed(
                                                  context, Routes.editChild,
                                                  arguments: value.id);
                                            },
                                          ),
                                          SizedBox(width: size.width * 0.015),
                                          InkWell(
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        size.height * 0.005,
                                                    horizontal:
                                                        size.width * 0.02),
                                                decoration: const BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                child: const AppText(
                                                  text: "delete",
                                                  color: Colors.white,
                                                )),
                                            onTap: () {
                                              showDeleteConfirmationDialog(
                                                  value.id);
                                            },
                                          ),
                                          // AppButton(label: "delete"),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (ChildModel? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        selectedChild = newValue;
                                      });
                                      BlocProvider.of<CurrentChildCubit>(
                                              context)
                                          .changeCurrentChild(newValue, () {
                                        BlocProvider.of<DecisionBloc>(context)
                                            .add(GetDecisionsByAgeEvent(
                                                dateOfBirth:
                                                    newValue.dateOfBirth,
                                                childId: newValue.id));

                                        BlocProvider.of<
                                                    AllPreviousDecisionTakenCubit>(
                                                context)
                                            .checkIfAllTaken(newValue);
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
                            child: SvgPicture.asset(
                              settingsIcon,
                              color: widget.light
                                  ? Colors.white
                                  : AppColors.primaryColor,
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, Routes.settings);
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

  checkChild() async {
    ChildModel? child =
        await BlocProvider.of<CurrentChildCubit>(context).getCurrentChild();
    if (child != null) {
      BlocProvider.of<AllPreviousDecisionTakenCubit>(context)
          .checkIfAllTaken(child);
      setState(() {
        selectedChild = child;
      });
    }
  }

  showDeleteConfirmationDialog(int id) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              // title:
              //     AppText(text: widget.milestoneItem.description),
              title: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: textScale * 28,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: AppText(
                        text: AppLocalizations.of(context)!.areYouSureDelete,
                        fontSize: textScale * 28,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.close,
                    size: textScale * 28,
                    color: Colors.white,
                  ),
                ],
              ),
              titlePadding: const EdgeInsets.all(0),
              content: Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    bottom: size.height * 0.01),
                child: AppText(
                  text: AppLocalizations.of(context)!.deleteForever,
                  fontSize: textScale * 20,
                  color: AppColors.primaryColorDarker,
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: EdgeInsets.only(bottom: size.height * 0.05),
              actions: [
                InkWell(
                  onTap: () {
                    BlocProvider.of<ChildBloc>(context)
                        .add(DeleteChildEvent(id: id));
                    BlocProvider.of<ChildBloc>(context)
                        .add(GetAllChildrenEvent());
                    Navigator.pop(context);
                    Navigator.pop(dropDownKey.currentContext!);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      color: Colors.red[400],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(textScale * 2, textScale * 4),
                          blurRadius: textScale * 8,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: textScale * 10,
                      horizontal: textScale * 30,
                    ),
                    child: AppText(
                      text: AppLocalizations.of(context)!.yes,
                      textAlign: TextAlign.right,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
