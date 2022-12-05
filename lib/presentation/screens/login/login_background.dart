import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

    return Container(
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
            ),
          ),
          Positioned(
            top: 0,
            child: Image.asset(smiley_face, width: size.width),
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
