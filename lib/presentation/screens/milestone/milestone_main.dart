import 'package:child_milestone/data/models/milestone_category.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/common_widgets/column_with_seprator.dart';
import 'package:child_milestone/presentation/components/top_bar_view.dart';
import 'package:child_milestone/presentation/widgets/category_box_widget.dart';
import 'package:child_milestone/presentation/widgets/notification_item_widget.dart';
import 'package:flutter/material.dart';

class MilestoneScreen extends StatefulWidget {
  const MilestoneScreen({Key? key}) : super(key: key);

  @override
  _MilestoneScreenState createState() => _MilestoneScreenState();
}

class _MilestoneScreenState extends State<MilestoneScreen> {
  int age = 0;
  int _selected = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;

    List<MilestoneCategoryModel> cagtegories = [
      MilestoneCategoryModel(
        id: 1,
        name: "Social",
        icon_path: "assets/icons/milestone_page/social_category.png",
      ),
      MilestoneCategoryModel(
        id: 2,
        name: "Language",
        icon_path: "assets/icons/milestone_page/language_category.png",
      ),
      MilestoneCategoryModel(
        id: 3,
        name: "Movement",
        icon_path: "assets/icons/milestone_page/movement_category.png",
      ),
      MilestoneCategoryModel(
        id: 4,
        name: "Cognitive",
        icon_path: "assets/icons/milestone_page/cognitive_category.png",
      ),
    ];

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          TopBarView(back_route: true),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.02),
                Container(
                  alignment: AlignmentDirectional.topStart,
                  padding: EdgeInsets.only(left: size.width * 0.05),
                  child: const AppText(
                    text: "Milestone Checklist",
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                  child: Row(
                    children: cagtegories.map((e) {
                      return Expanded(
                        flex: 1,
                        child: InkWell(
                          highlightColor: null,
                          onTap: () {
                            setState(() {
                              _selected = e.id;
                            });
                          },
                          child: CategoryBoxWidget(
                            item: e,
                            selected: _selected,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
