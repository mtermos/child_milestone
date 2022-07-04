import 'package:child_milestone/data/models/tip.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TipItemWidget extends StatefulWidget {
  TipItemWidget({Key? key, required this.item}) : super(key: key);
  final TipModel item;

  @override
  _TipItemWidgetState createState() => _TipItemWidgetState();
}

class _TipItemWidgetState extends State<TipItemWidget> {
  final Color borderColor = Color(0xffE2E2E2);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size.height * 0.015,
        horizontal: size.width * 0.05,
      ),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(textScale * 2, textScale * 4),
            blurRadius: textScale * 8,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        vertical: textScale * 15,
        horizontal: textScale * 20,
      ),
      child: AppText(
        text: widget.item.body,
        color: Colors.black,
        fontSize: textScale * 16,
      ),
      // RichText(
      //   text: TextSpan(
      //     style: TextStyle(
      //       fontSize: textScale * 16,
      //       color: Colors.black,
      //     ),
      //     children: <TextSpan>[
      //       TextSpan(),
      //     ],
      //   ),
      // ),
    );
  }
}
