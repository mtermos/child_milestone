import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.title = '',
    this.index = 0,
    this.selectedColor = AppColors.primaryColor,
    this.notSelectedColor = Colors.grey,
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String title;
  Color selectedColor;
  Color notSelectedColor;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/icons/home_page/home_icon.svg',
      title: 'Home',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/icons/home_page/notification_icon.svg',
      title: 'Notifications',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/icons/home_page/insights_icon.svg',
      title: 'Tips',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/icons/home_page/star_icon.svg',
      title: 'App Rate',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
