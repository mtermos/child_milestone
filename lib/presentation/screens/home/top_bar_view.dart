import 'package:flutter/material.dart';
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

  @override
  void initState() {
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
                        child: Text(
                          "Ahmad <",
                          textAlign: TextAlign.center,
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
