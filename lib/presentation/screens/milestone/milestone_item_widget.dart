import 'dart:io';
import 'package:child_milestone/data/models/milestone_item.dart';
import 'package:flutter/material.dart';

class MilestoneItemWidget extends StatefulWidget {
  const MilestoneItemWidget({Key? key, required this.item}) : super(key: key);
  final MilestoneItem item;

  @override
  _MilestoneItemWidgetState createState() => _MilestoneItemWidgetState();
}

class _MilestoneItemWidgetState extends State<MilestoneItemWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
    return Container(
      margin: EdgeInsets.only(
        bottom: size.height * 0.05,
        right: size.width * 0.01,
        left: size.width * 0.01,
      ),
      width: size.width * 0.8,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Positioned(
                child: Center(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    widget.item.imagePath ?? "asd",
                    alignment: Alignment.topCenter,
                    color: Colors.white.withOpacity(0.8),
                    colorBlendMode: BlendMode.modulate,
                  ),
                )),
              ),
              Positioned(
                bottom: size.height * 0.01,
                child: Container(
                  width: size.width * 0.7,
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
                  child: Text(
                    widget.item.description,
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(width: size.width * 0.05),
              Container(
                width: size.width * 0.15,
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
                child: Text(
                  "كلا",
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(width: size.width * 0.01),
              Container(
                width: size.width * 0.15,
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
                child: Text(
                  "نعم",
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(width: size.width * 0.01),
              Container(
                width: size.width * 0.15,
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
                child: Text(
                  "ربما",
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
