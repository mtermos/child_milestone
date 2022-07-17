import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MilestoneSummaryItem extends StatelessWidget {
  final MilestoneItem milestoneItem;
  final bool editable;
  const MilestoneSummaryItem(
      {required this.milestoneItem, required this.editable, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
    const String editIcon = "assets/icons/edit_icon.svg";
    return Container(
      width: size.width * 0.75,
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.65,
            child: AppText(
              text: milestoneItem.description,
              textAlign: TextAlign.start,
            ),
          ),
          const Spacer(),
          editable
              ? InkWell(
                  onTap: () => {
                    Navigator.pushNamed(context, Routes.milestone,
                        arguments: milestoneItem.category)
                  },
                  child: SvgPicture.asset(
                    editIcon,
                    width: size.width * 0.05,
                    alignment: Alignment.center,
                    color: Colors.black,
                  ),
                )
              : Container(),
        ],
      ),
      // child: Text(milestoneItem.description),
    );
  }
}
