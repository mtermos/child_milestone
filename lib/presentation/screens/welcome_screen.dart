import 'package:child_milestone/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  final String imagePath = "assets/images/welcome_image.png";
  final String backgtound2 = "assets/images/rectangle2.svg";
  final String backgtound3 = "assets/images/rectangle3.svg";

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;

    return Scaffold(
      // backgroundColor: AppColors.primaryColor,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SvgPicture.asset(
            backgtound2,
            alignment: Alignment.topCenter,
          ),
          SvgPicture.asset(
            backgtound3,
            alignment: Alignment.bottomCenter,
          ),
          Positioned(
            left: 0,
            child: Image.asset(
              imagePath,
              alignment: Alignment.topLeft,
              fit: BoxFit.fitWidth,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Spacer(),
                icon(size),
                SizedBox(
                  height: size.height * 0.015,
                ),
                welcomeTextWidget(context, textScale),
                SizedBox(
                  height: size.height * 0.01,
                ),
                sloganText(),
                SizedBox(
                  height: size.height * 0.015,
                ),
                getButton(context),
                SizedBox(
                  height: size.height * 0.07,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget icon(Size size) {
    String iconPath = "assets/icons/steps_icon.png";
    return Image.asset(
      iconPath,
      width: size.width * 0.3,
    );
    // String iconPath = "assets/icons/vaccine-for-children.svg";
    // return SvgPicture.asset(
    //   iconPath,
    //   color: const Color.fromRGBO(78, 76, 76, 1),
    //   width: 100,
    // );
  }

  Widget welcomeTextWidget(BuildContext context, double textScale) {
    return Column(
      children: [
        AppText(
          text: AppLocalizations.of(context)!.welcome,
          fontSize: textScale * 48,
          fontWeight: FontWeight.w600,
          // color: Colors.white,
          color: const Color.fromRGBO(78, 76, 76, 1),
        ),
        AppText(
          text: AppLocalizations.of(context)!.toChildMilestone,
          fontSize: textScale * 28,
          fontWeight: FontWeight.w600,
          color: const Color.fromRGBO(78, 76, 76, 1),
        ),
      ],
    );
  }

  Widget sloganText() {
    return AppText(
      text: "Application Description",
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: const Color(0xffFCFCFC).withOpacity(0.7),
    );
  }

  Widget getButton(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      child: AppButton(
        label: AppLocalizations.of(context)!.getStarted,
        fontWeight: FontWeight.w600,
        padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
        onPressed: () {
          onGetStartedClicked(context);
        },
      ),
    );
  }

  void onGetStartedClicked(BuildContext context) {
    // Navigator.popAndPushNamed(context, Routes.login);

    // remove the next line when adding login service
    Navigator.popAndPushNamed(context, Routes.home);

    // BlocProvider.of<AuthBloc>(context).add(LoginEvent());
    // Navigator.of(context).pushReplacement(new MaterialPageRoute(
    //   builder: (BuildContext context) {
    //     return DashboardScreen();
    //   },
    // ));
  }
}
