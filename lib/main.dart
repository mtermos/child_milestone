import 'package:child_milestone/bloc_providers.dart';
import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/logic/cubits/language/Language_cubit.dart';
import 'package:child_milestone/logic/shared/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_milestone/presentation/router/app_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); //
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String startLang = prefs.getString(SharedPrefKeys.langCode) ?? "ar";

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(Application(
        appRouter: AppRouter(),
        startLang: Locale(startLang),
      )));
}

class Application extends StatelessWidget {
  final AppRouter appRouter;
  final Locale startLang;

  const Application({
    Key? key,
    required this.appRouter,
    required this.startLang,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: RepositoryProviders.getProviders(context),
      child: MultiBlocProvider(
        providers: BlocProviders.getProviders(context, startLang),
        child: BlocBuilder<LanguageCubit, Locale>(
          builder: (context, lang) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: MaterialApp(
                builder: (context, child) => ResponsiveBreakpoints.builder(
                  child: ClampingScrollWrapper.builder(context, child!),
                  breakpoints: const [
                    Breakpoint(start: 0, end: 450, name: MOBILE),
                    Breakpoint(start: 451, end: 800, name: TABLET),
                    Breakpoint(start: 801, end: double.infinity, name: DESKTOP),
                  ],
                ),
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  // accentColor: Colors.blue,
                  visualDensity: VisualDensity.standard,
                ),
                locale: lang,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                onGenerateRoute: appRouter.onGenerateRoute,
              ),
            );
          },
        ),
      ),
    );
  }
}
