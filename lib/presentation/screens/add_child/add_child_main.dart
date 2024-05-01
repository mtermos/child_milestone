import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/screens/add_child/add_child_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AddChildScreen extends StatefulWidget {
  @override
  _AddChildScreenState createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isMOBILE = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final textScale = isMOBILE
        ? MediaQuery.of(context).size.height * 0.001
        : MediaQuery.of(context).size.height * 0.0011;

    return Container(
      color: Colors.white,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            _addChildTopBar(context, size),
            SizedBox(
              height: size.height * 0.02,
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _addChildBackground(context, size, isMOBILE),
                  ),
                  const AddChildForm(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _addChildTopBar(BuildContext context, Size size) {
    return Container(
      padding: EdgeInsets.only(
        left: size.width * 0.07,
        top: size.height * 0.02,
      ),
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: () {
          Navigator.popAndPushNamed(context, Routes.home);
          // Navigator.pop(context);
        },
        child: AppText(
          text: AppLocalizations.of(context)!.cancel,
          fontSize: size.height * 0.025,
        ),
      ),
    );
  }

  Widget _addChildBackground(BuildContext context, Size size, bool isMOBILE) {
    const String addChildBgItem1 = "assets/images/add_child_bg_item_1.svg";
    return SvgPicture.asset(
      addChildBgItem1,
      width: isMOBILE ? size.width * 0.5 : size.width * 0.35,
    );
  }
}
