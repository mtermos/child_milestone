import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:math' as math;
import 'dart:math' as math;

import 'package:flutter_svg/svg.dart';

class HomepageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator HomepageWidget - FRAME
    return Container(
        width: 412,
        height: 846,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Stack(children: <Widget>[
          Positioned(
              top: -490,
              left: -253,
              child: Container(
                  width: 1114.705078125,
                  height: 1520.48193359375,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 563.8848266601562,
                        child: Transform.rotate(
                          angle: -29.9999987377448 * (math.pi / 180),
                          child: SvgPicture.asset(
                              'assets/images/rectangle2.svg',
                              semanticsLabel: 'rectangle2'),
                        )),
                    Positioned(
                        top: 773,
                        left: 602,
                        child: Container(
                            width: 2596,
                            height: 2050,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/Vectarytexture.png'),
                                  fit: BoxFit.fitWidth),
                            ))),
                    Positioned(
                        top: 1520.48193359375,
                        left: 713.5401611328125,
                        child: Transform.rotate(
                          angle: 175.87844589584415 * (math.pi / 180),
                          child: SvgPicture.asset(
                              'assets/images/rectangle3.svg',
                              semanticsLabel: 'rectangle3'),
                        )),
                  ]))),
          Positioned(
              top: 565,
              left: 32,
              child: Text(
                'NAME',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(77, 75, 75, 1),
                    fontFamily: 'Lato',
                    fontSize: 36,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 423,
              left: 90.430908203125,
              child: Transform.rotate(
                angle: -37.28945601524257 * (math.pi / 180),
                child: Container(
                    width: 103,
                    height: 108,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/Steps1.png'),
                          fit: BoxFit.fitWidth),
                    )),
              )),
          Positioned(
              top: 773,
              left: 602,
              child: Container(
                  width: 2596,
                  height: 2050,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Vectarytexture.png'),
                        fit: BoxFit.fitWidth),
                  ))),
          Positioned(
              top: 0,
              left: 19,
              child: Container(
                  width: 375,
                  height: 44,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 375,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(32, 45, 59, 0),
                            ),
                            child: Stack(children: <Widget>[
                              Positioned(
                                  top: 17.33333396911621,
                                  left: 336.33331298828125,
                                  child: Container(
                                      width: 24.32803726196289,
                                      height: 11.333333015441895,
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                                width: 22,
                                                height: 11.333333015441895,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        2.6666667461395264),
                                                    topRight: Radius.circular(
                                                        2.6666667461395264),
                                                    bottomLeft: Radius.circular(
                                                        2.6666667461395264),
                                                    bottomRight:
                                                        Radius.circular(
                                                            2.6666667461395264),
                                                  ),
                                                  border: Border.all(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                    width: 1,
                                                  ),
                                                ))),
                                        Positioned(
                                            top: 3.6666667461395264,
                                            left: 23,
                                            child: SvgPicture.asset(
                                                'assets/images/cap.svg',
                                                semanticsLabel: 'cap')),
                                        Positioned(
                                            top: 1.9999998807907104,
                                            left: 2,
                                            child: Container(
                                                width: 18,
                                                height: 7.333333492279053,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        1.3333333730697632),
                                                    topRight: Radius.circular(
                                                        1.3333333730697632),
                                                    bottomLeft: Radius.circular(
                                                        1.3333333730697632),
                                                    bottomRight:
                                                        Radius.circular(
                                                            1.3333333730697632),
                                                  ),
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                ))),
                                      ]))),
                              Positioned(
                                  top: 17.330673217773438,
                                  left: 316,
                                  child: Text("asd")),
                              Positioned(
                                  top: 17.666667938232422,
                                  left: 294,
                                  child: Text("asd")),
                              Positioned(
                                  top: 6,
                                  left: 0,
                                  child: Container(
                                      width: 54,
                                      height: 21,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                      child: Stack(children: <Widget>[
                                        Positioned(
                                            top: 6,
                                            left: 0,
                                            child: Text(
                                              '9:41',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  fontFamily: 'Lato',
                                                  fontSize: 15,
                                                  letterSpacing:
                                                      -0.23999999463558197,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1.3333333333333333),
                                            )),
                                      ]))),
                            ]))),
                  ]))),
          Positioned(
              top: 753,
              left: 232,
              child: Container(
                  width: 150,
                  height: 52,
                  child: Stack(children: <Widget>[
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: 140,
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        0, 0, 0, 0.05999999865889549),
                                    offset: Offset(0, 4),
                                    blurRadius: 4)
                              ],
                              color: Color.fromRGBO(238, 238, 238, 1),
                            ))),
                    Positioned(
                        top: 14,
                        left: 12,
                        child: Text(
                          'Get Started',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color.fromRGBO(57, 138, 185, 1),
                              fontFamily: 'Lato',
                              fontSize: 22,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        )),
                  ]))),
        ]));
  }
}
