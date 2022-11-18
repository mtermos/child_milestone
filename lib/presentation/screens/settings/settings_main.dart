import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/logic/blocs/auth/auth_bloc.dart';
import 'package:child_milestone/logic/blocs/auth/auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_milestone/logic/cubits/language/Language_cubit.dart';
import 'package:child_milestone/presentation/common_widgets/app_button.dart';
import 'package:child_milestone/presentation/common_widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:child_milestone/presentation/screens/settings/settings_background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
      body: SettingsBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: size.width * 0.8,
              margin: const EdgeInsets.symmetric(horizontal: 40),
            ),
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
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
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
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: size.height * 0.1),
          ],
        ),
      ),
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
        Navigator.popAndPushNamed(context, Routes.splashScreen);
      },
    ));
  }
}
