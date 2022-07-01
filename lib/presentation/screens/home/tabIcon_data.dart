import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.title = '',
    this.slug = '',
    this.index = 0,
    this.selectedColor = AppColors.primaryColor,
    this.notSelectedColor = Colors.grey,
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String title;
  String slug;
  Color selectedColor;
  Color notSelectedColor;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/icons/home_page/home_icon.svg',
      title: 'Home',
      slug: 'home',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/icons/home_page/notification_icon.svg',
      title: 'Notifications',
      slug: 'notifications',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/icons/home_page/insights_icon.svg',
      title: 'Tips',
      slug: 'tips',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/icons/home_page/star_icon.svg',
      title: 'App Rate',
      slug: 'appRate',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
