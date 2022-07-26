import 'package:child_milestone/data/models/milestone_category.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter/material.dart';

class CategoryBoxWidget extends StatefulWidget {
  CategoryBoxWidget({Key? key, required this.item, required this.selected})
      : super(key: key);
  final MilestoneCategoryModel item;
  int selected;

  @override
  _CategoryBoxWidgetState createState() => _CategoryBoxWidgetState();
}

class _CategoryBoxWidgetState extends State<CategoryBoxWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size.height * 0.015,
        horizontal: size.width * 0.015,
      ),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        color: widget.item.id == widget.selected
            ? AppColors.primaryColor
            : AppColors.unselectedColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(textScale * 2, textScale * 4),
            blurRadius: textScale * 8,
          ),
        ],
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: textScale * 15,
        horizontal: textScale * 10,
      ),
      child: Column(
        children: [
          Image.asset(
            widget.item.icon_path,
            width: size.width * 0.1,
          ),
          SizedBox(height: textScale * 10),
          AppText(
            text: widget.item.name,
            fontSize: textScale * 18,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
