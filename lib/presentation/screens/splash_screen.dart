import 'dart:async';

import 'package:child_milestone/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    const delay = Duration(seconds: 1);
    Future.delayed(delay, () => checkUserIsLogged());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: splashScreenIcon(size),
      ),
    );
  }

  void checkUserIsLogged() async {
    final prefs = await SharedPreferences.getInstance();
    if ((prefs.getBool(SHARED_LOGGED) != null) &&
        prefs.getBool(SHARED_LOGGED)!) {
      Navigator.pushNamed(context, '/home');

      // ApiRepository.get().login(LoginRequest(username: prefs.getString(SHARED_USER), password: prefs.getString(SHARED_PASSWORD))).then((response) {
      //   if (response != null) {
      //     Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      //   }
      // }).catchError((error) {
      //   Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      // });
    } else {
      Navigator.pushNamed(context, '/welcome');
    }
  }
}

Widget splashScreenIcon(Size size) {
  // String iconPath = "assets/icons/vaccine-for-children.svg";
  // return SvgPicture.asset(
  //   iconPath,
  //   width: 250,
  // );

  String iconPath = "assets/icons/steps_icon.png";
  return Image.asset(
    iconPath,
    width: size.width * 0.3,
  );
}
