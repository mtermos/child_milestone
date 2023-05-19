import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LoginBackground extends StatelessWidget {
  final Widget child;

  final String smile = "assets/images/smile.svg";
  final String smiley_face = "assets/images/smiley_face.png";
  final String ellipse = "assets/images/ellipse.svg";

  const LoginBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isMOBILE = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    final textScale = isMOBILE
        ? MediaQuery.of(context).size.height * 0.001
        : MediaQuery.of(context).size.height * 0.0011;

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: 0,
            width: size.width,
            child: SvgPicture.asset(
              ellipse,
              alignment: Alignment.topCenter,
              width: size.width,
              height: isMOBILE ? null : size.height * 0.4,
              fit: isMOBILE ? BoxFit.contain : BoxFit.fill,
            ),
          ),
          Positioned(
            top: isMOBILE ? 0 : -size.height * 0.1,
            child: Image.asset(
              smiley_face,
              width: size.width,
              scale: isMOBILE ? 1 : 0.7,
            ),
          ),
          // Positioned(
          //   top: 50,
          //   right: 30,
          //   child:
          //       Image.asset("assets/images/main.png", width: size.width * 0.35),
          // ),
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: Image.asset("assets/images/bottom1.png", width: size.width),
          // ),
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: Image.asset("assets/images/bottom2.png", width: size.width),
          // ),
          child
        ],
      ),
    );
  }
}
