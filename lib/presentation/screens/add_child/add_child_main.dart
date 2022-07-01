import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/screens/add_child/add_child_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return Container(
      color: Colors.white,
      child: Scaffold(
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
                  AddChildForm(),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _addChildBackground(context, size),
                  ),
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
          Navigator.pop(context);
        },
        child: AppText(
          text: AppLocalizations.of(context)!.cancel,
          fontSize: size.height * 0.025,
        ),
      ),
    );
  }

  Widget _addChildBackground(BuildContext context, Size size) {
    const String add_child_bg_item_1 = "assets/images/add_child_bg_item_1.svg";
    return SvgPicture.asset(
      add_child_bg_item_1,
      width: size.width * 0.5,
    );
  }
}
