import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/tip.dart';
import 'package:child_milestone/logic/blocs/tip/tip_bloc.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:child_milestone/presentation/screens/home/tabs/appRate/sections/tips_rating.dart';
import 'package:child_milestone/presentation/widgets/tip_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppRateTab extends StatefulWidget {
  const AppRateTab({Key? key}) : super(key: key);

  @override
  _AppRateState createState() => _AppRateState();
}

class _AppRateState extends State<AppRateTab> {
  List<Widget> sections = [TipsRating()];

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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            Container(
              alignment: AlignmentDirectional.topStart,
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.05),
              child: AppText(
                text: AppLocalizations.of(context)!.appRate,
                fontSize: textScale * 36,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: size.height * 0.015,
                horizontal: size.width * 0.05,
              ),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(15)),
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
              child: Row(
                  children: sections
                      .map((e) => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03,
                                vertical: size.height * 0.01),
                            child: e,
                          ))
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
