import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  //One instance, needs factory
  static AppColors? _instance;
  factory AppColors() => _instance ?? AppColors._();

  AppColors._();

  static const primaryColor = Color.fromRGBO(57, 138, 185, 1);
  static const primaryColorDarker = Color.fromRGBO(28, 102, 141, 1);
  static const unselectedColor = Color.fromRGBO(227, 220, 212, 1);
  static const darkGrey = Color(0xff7C7C7C);
}
