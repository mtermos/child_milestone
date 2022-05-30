import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class TopBarView extends StatefulWidget {
  const TopBarView({Key? key}) : super(key: key);

  @override
  _TopBarViewState createState() => _TopBarViewState();
}

class _TopBarViewState extends State<TopBarView> with TickerProviderStateMixin {
  static const String settings_icon =
      "assets/icons/home_page/settings_icon.svg";
  static const String side_nav_icon =
      "assets/icons/home_page/side_nav_icon.svg";

  List<ChildModel>? childrenList;
  ChildModel? selected_user;

  @override
  void initState() {
    // BlocProvider.of<ChildBloc>(context).add(DeleteAllChildrenEvent());
    BlocProvider.of<ChildBloc>(context).add(GetAllChildrenEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(0.0, 0.0, 0.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 62,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: SvgPicture.asset(side_nav_icon),
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
                              child: DropdownButton<ChildModel>(
                                value: selected_user,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                                      selected_user = newValue;
                                    });
                                    BlocProvider.of<CurrentChildCubit>(context)
                                        .change_current_child(newValue);
                                    print(newValue);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SvgPicture.asset(settings_icon),
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
}
