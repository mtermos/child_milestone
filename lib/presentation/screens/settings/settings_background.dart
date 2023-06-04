import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SettingsBackground extends StatelessWidget {
  final Widget child;

  final String smile = "assets/images/smile.svg";
  final String smiley_face = "assets/images/smiley_face.png";
  final String settings = "assets/icons/home_page/settings_icon.svg";
  final String ellipse = "assets/images/ellipse_settings.svg";
  final String iconPath = "assets/icons/steps_icon.png";

  const SettingsBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isMOBILE = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final textScale = isMOBILE
        ? MediaQuery.of(context).size.height * 0.001
        : MediaQuery.of(context).size.height * 0.0011;

    return Container(
      width: size.width,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              height: size.height * 0.2,
              width: size.width,
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
            ),
          ),
          Positioned(
            top: size.height * 0.085,
            child: Row(
              children: [
                SvgPicture.asset(
                  settings,
                  width: isMOBILE ? size.width * 0.1 : size.width * 0.08,
                  alignment: Alignment.center,
                  color: Colors.white,
                ),
                SizedBox(width: size.width * 0.05),
                AppText(
                  text: AppLocalizations.of(context)!.settingsCap,
                  fontSize: textScale * 45,
                  fontWeight: FontWeight.w600,
                  // color: Colors.white,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Positioned(
            top: size.height * 0.2,
            right: 0,
            width: size.width,
            height: size.height * 0.8,
            child: child,
          ),
        ],
      ),
    );
  }
}
