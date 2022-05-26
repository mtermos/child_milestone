import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/logic/blocs/auth/auth_bloc.dart';
import 'package:child_milestone/logic/blocs/auth/auth_event.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/screens/login/login_background.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_bloc_login_example/bloc/auth/auth_bloc.dart';
// import 'package:flutter_bloc_login_example/bloc/auth/auth_event.dart';
// import 'package:flutter_bloc_login_example/bloc/auth/auth_state.dart';
// import 'package:flutter_bloc_login_example/screens/home/main.dart';
// import 'package:flutter_bloc_login_example/screens/login/signUp.dart';
// import 'package:flutter_bloc_login_example/shared/colors.dart';
// import 'package:flutter_bloc_login_example/shared/components.dart';
// import 'package:flutter_bloc_login_example/shared/screen_transitions/slide.transition.dart';
// import 'package:flutter_bloc_login_example/shared/styles.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String profile_pic_bg = "assets/images/profile_pic_bg.svg";
    const String child_pic = "assets/images/children/child1.png";
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: size.height * 0.3,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Positioned(
                  top: size.height * 0.02,
                  child: Center(
                    child: SvgPicture.asset(
                      profile_pic_bg,
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
                          CircleAvatar(
                            radius: size.width * 0.15,
                            backgroundImage: Image.asset(child_pic).image,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      AppText(
                        text: "Ahmad",
                        color: Colors.white,
                        fontSize: size.height * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: size.height * 0.01),
                      AppText(
                        text: "3 months old!",
                        color: Colors.white,
                        fontSize: size.height * 0.015,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            width: size.width * 0.5,
            child: AppButton(
              label: "Logout",
              onPressed: () {
                _logout();
              },
            ),
          )
        ],
      ),
    );
  }

  _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SHARED_LOGGED, false);
    Navigator.pushNamed(context, '/');
  }
}
