import 'package:child_milestone/logic/blocs/rating/rating_bloc.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppRateWelcome extends StatefulWidget {
  const AppRateWelcome({super.key});

  @override
  State<AppRateWelcome> createState() => _AppRateWelcomeState();
}

class _AppRateWelcomeState extends State<AppRateWelcome> {
  @override
  void initState() {
    BlocProvider.of<RatingBloc>(context).add(GetAllRatingsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isMOBILE = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final textScale = isMOBILE
        ? MediaQuery.of(context).size.height * 0.001
        : MediaQuery.of(context).size.height * 0.0011;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.1),
            AppText(
              text: AppLocalizations.of(context)!.appRateSubTitle,
              fontSize: textScale * 24,
            ),
            SizedBox(height: size.height * 0.05),
            BlocBuilder<RatingBloc, RatingState>(
              builder: (context, state) {
                if (state is AllRatingsLoadedState &&
                    state.ratings.length == 8) {
                  return AppText(
                    text: AppLocalizations.of(context)!.remakeRating,
                    fontSize: textScale * 24,
                    color: Colors.green,
                  );
                } else {
                  return AppText(
                    text: AppLocalizations.of(context)!.appRateClickToStart,
                    fontSize: textScale * 22,
                  );
                }
                // TODO: implement listener
              },
            ),
            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }
}
