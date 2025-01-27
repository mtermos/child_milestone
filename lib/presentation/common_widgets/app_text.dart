import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final bool? link;
  final TextAlign? textAlign;
  final TextStyle? style;

  const AppText({
    required this.text,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.link = false,
    this.textAlign,
    this.style,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.center,
      style: style ??
          TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: link! ? Colors.blue : color,
          ),
    );
  }
}
