import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TipsRating extends StatefulWidget {
  TipsRating({Key? key}) : super(key: key);

  @override
  State<TipsRating> createState() => _TipsRatingState();
}

class _TipsRatingState extends State<TipsRating> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final textScale = MediaQuery.of(context).size.height * 0.001;
    return Container(
      child: AppText(text: AppLocalizations.of(context)!.tipsRate),
    );
  }
}
