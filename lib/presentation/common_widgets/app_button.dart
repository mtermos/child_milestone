import 'package:flutter/material.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter_svg/svg.dart';

class AppButton extends StatelessWidget {
  final String label;
  final double roundness;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsets padding;
  final Widget? trailingWidget;
  final Color? color;
  final Function? onPressed;
  final String? SVGLink;

  const AppButton({
    required this.label,
    this.roundness = 18,
    this.fontSize = 18,
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(vertical: 18),
    this.trailingWidget,
    this.color = AppColors.primaryColor,
    this.onPressed,
    this.SVGLink,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.0),
          foregroundColor: MaterialStateProperty.all(color),
          backgroundColor: MaterialStateProperty.all(color),
          padding: MaterialStateProperty.all(padding),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(roundness),
            ),
          ),
        ),
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  ),
                  SVGLink != null
                      ? SizedBox(width: fontSize)
                      : SizedBox.shrink(),
                  SVGLink != null
                      ? SvgPicture.asset(
                          SVGLink!,
                          width: fontSize * 2,
                          alignment: Alignment.center,
                          color: Colors.white,
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
            if (trailingWidget != null)
              Positioned(
                top: 0,
                right: 25,
                child: trailingWidget!,
              )
          ],
        ),
        onPressed: () {
          if (onPressed != null) onPressed!();
        },
      ),
    );
  }
}
