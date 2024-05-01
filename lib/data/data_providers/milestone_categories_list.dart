import 'package:child_milestone/data/models/milestone_category.dart';

List<MilestoneCategoryModel> categories = [
  MilestoneCategoryModel(
    id: 1,
    name: "الحركة",
    icon_path: "assets/icons/milestone_page/movement_category.png",
  ),
  MilestoneCategoryModel(
    id: 2,
    name: "الادراك",
    icon_path: "assets/icons/milestone_page/cognitive_category.png",
  ),
  MilestoneCategoryModel(
    id: 3,
    name: "التواصل",
    icon_path: "assets/icons/milestone_page/language_category.png",
  ),
  MilestoneCategoryModel(
    id: 4,
    name: "التفاعل",
    // name: AppLocalizations.of(context)!.interaction,
    icon_path: "assets/icons/milestone_page/social_category.png",
  ),
];
