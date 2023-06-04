import 'package:flutter/material.dart';
import 'package:child_milestone/presentation/styles/colors.dart';

String gilroyFontFamily = "Gilroy";

ThemeData themeData = ThemeData(
  colorScheme:
      ColorScheme.fromSwatch().copyWith(secondary: AppColors.primaryColor),

  // colorScheme: AppColors.primaryColor,
  fontFamily: gilroyFontFamily,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
