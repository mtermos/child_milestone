import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/logic/blocs/auth/auth_bloc.dart';
import 'package:child_milestone/logic/blocs/auth/auth_event.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:child_milestone/logic/blocs/log/log_bloc.dart';
import 'package:child_milestone/logic/blocs/rating/rating_bloc.dart';
import 'package:child_milestone/presentation/styles/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:child_milestone/presentation/screens/settings/settings_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final String uploadSVG = "assets/icons/upload.svg";
  final String logoutSVG = "assets/icons/logout.svg";

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
    final isMOBILE = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final textScale = isMOBILE
        ? MediaQuery.of(context).size.height * 0.001
        : MediaQuery.of(context).size.height * 0.0011;

    return BlocConsumer<ChildBloc, ChildState>(
      listener: (context, state) {
        if (state is ErrorUploadingChildrenState) {
          var snackBar = SnackBar(
            content:
                Text(AppLocalizations.of(context)!.checkInternetConnection),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      builder: (context, state) {
        if (state is UploadingChildrenState) {
          return Scaffold(
            body: SettingsBackground(
              child: Center(
                child: SizedBox(
                  width: isMOBILE ? size.width * 0.35 : size.width * 0.35,
                  child: const LoadingIndicator(
                    indicatorType: Indicator.circleStrokeSpin,
                    colors: [AppColors.primaryColor],
                    strokeWidth: 4,
                    backgroundColor: Colors.white,
                    pathBackgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: SettingsBackground(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: size.width * 0.8,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                ),
                SizedBox(height: size.height * 0.04),
                Container(
                  alignment: Alignment.center,
                  width: size.width * 0.8,
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.25),
                  child: AppButton(
                    label: AppLocalizations.of(context)!.uploadData,
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.w600,
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    SVGLink: uploadSVG,
                    onPressed: () {
                      // ignore: avoid_print
                      BlocProvider.of<ChildBloc>(context).add(
                          UploadChildrenEvent(
                              appLocalizations: AppLocalizations.of(context)!));
                      // uploadData(context);

                      BlocProvider.of<LogBloc>(context)
                          .add(const UploadLogsEvent());

                      BlocProvider.of<RatingBloc>(context).add(
                          UploadRatingsEvent(
                              appLocalizations: AppLocalizations.of(context)!));
                    },
                  ),
                ),
                // upload data

                // SizedBox(height: size.height * 0.02),
                // Container(
                //   alignment: Alignment.center,
                //   width: size.width * 0.8,
                //   margin: const EdgeInsets.symmetric(horizontal: 40),
                //   child: Row(
                //     children: [
                //       AppText(
                //         text: AppLocalizations.of(context)!.selectLanguage,
                //         fontSize: textScale * 24,
                //       ),
                //       const Spacer(),
                //       DropdownButton(
                //         value: BlocProvider.of<LanguageCubit>(context).state,
                //         onChanged: (Locale? val) {
                //           BlocProvider.of<LanguageCubit>(context)
                //               .changeLang(val!.languageCode);
                //         },
                //         items: AppLocalizations.supportedLocales
                //             .map((e) => DropdownMenuItem(
                //                   value: e,
                //                   child: Text(languageName(e.languageCode)),
                //                 ))
                //             .toList(),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: size.height * 0.05),
                Container(
                  alignment: Alignment.center,
                  width: size.width * 0.8,
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.25),
                  child: AppButton(
                    label: AppLocalizations.of(context)!.logout,
                    fontWeight: FontWeight.w600,
                    fontSize: textScale * 20,
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    SVGLink: logoutSVG,
                    onPressed: () {
                      _logout();
                    },
                  ),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.center,
                  width: size.width * 0.8,
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.25),
                  child: AppButton(
                    label: AppLocalizations.of(context)!.goBack,
                    fontWeight: FontWeight.w600,
                    fontSize: textScale * 20,
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    onPressed: () {
                      // Navigator.pop(context);
                      Navigator.popAndPushNamed(context, Routes.home);
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.1),
              ],
            ),
          ),
        );
      },
    );
  }

  String languageName(String languageCode) {
    switch (languageCode) {
      case "ar":
        return "العربية";
      case "en":
        return "English";
      case "es":
        return "Español";
      default:
        return "";
    }
  }

  _logout() async {
    BlocProvider.of<AuthBloc>(context).add(LogoutEvent(
      () {
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //     Routes.splashScreen, (Route<dynamic> route) => false);
        // Navigator.of(context).popUntil(ModalRoute.withName('/root'));
        Navigator.popAndPushNamed(context, Routes.splashScreen);
      },
    ));
  }
}
