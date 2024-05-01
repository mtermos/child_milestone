import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/dao/child_dao.dart';
import 'package:child_milestone/data/dao/decision_dao.dart';
import 'package:child_milestone/data/dao/log_dao.dart';
import 'package:child_milestone/data/dao/milestone_dao.dart';
import 'package:child_milestone/data/dao/notification_dao.dart';
import 'package:child_milestone/data/dao/rating_dao.dart';
import 'package:child_milestone/data/dao/tip_dao.dart';
import 'package:child_milestone/data/dao/vaccine_dao.dart';
import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/models/child_model.dart';
import 'package:child_milestone/data/models/log.dart';
import 'package:child_milestone/data/repositories/decision_repository.dart';
import 'package:child_milestone/data/repositories/log_repository.dart';
import 'package:child_milestone/data/repositories/milestone_repository.dart';
import 'package:child_milestone/data/repositories/notification_repository.dart';
import 'package:child_milestone/data/repositories/rating_repository.dart';
import 'package:child_milestone/data/repositories/tip_repository.dart';
import 'package:child_milestone/data/repositories/vaccine_repository.dart';
import 'package:child_milestone/logic/blocs/auth/auth_bloc.dart';
import 'package:child_milestone/logic/blocs/child/child_bloc.dart';
import 'package:child_milestone/logic/blocs/decision/decision_bloc.dart';
import 'package:child_milestone/logic/blocs/log/log_bloc.dart';
import 'package:child_milestone/logic/blocs/milestone/milestone_bloc.dart';
import 'package:child_milestone/logic/blocs/notification/notification_bloc.dart';
import 'package:child_milestone/logic/blocs/rating/rating_bloc.dart';
import 'package:child_milestone/logic/blocs/tip/tip_bloc.dart';
import 'package:child_milestone/logic/blocs/vaccine/vaccine_bloc.dart';
import 'package:child_milestone/logic/cubits/all_previous_decision_taken/all_previous_decision_taken_cubit.dart';
import 'package:child_milestone/logic/cubits/current_child/current_child_cubit.dart';
import 'package:child_milestone/logic/cubits/language/Language_cubit.dart';
import 'package:child_milestone/logic/shared/notification_service.dart';
import 'package:child_milestone/logic/shared/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_milestone/data/repositories/child_repository.dart';
import 'package:child_milestone/presentation/router/app_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

const EVENTS_KEY = "fetch_events";

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

  // runApp(Application(
  //   appRouter: AppRouter(),
  //   connectivity: Connectivity(),
  //   startLang: Locale(startLang),
  // ));
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
      providers: [
        RepositoryProvider<ChildRepository>(
            create: (context) => ChildRepository(ChildDao())),
        RepositoryProvider<MilestoneRepository>(
            create: (context) => MilestoneRepository(MilestoneDao())),
        RepositoryProvider<TipRepository>(
            create: (context) => TipRepository(TipDao())),
        RepositoryProvider<DecisionRepository>(
            create: (context) => DecisionRepository(DecisionDao())),
        RepositoryProvider<NotificationRepository>(
            create: (context) => NotificationRepository(
                NotificationDao(), ChildDao(), MilestoneDao())),
        RepositoryProvider<RatingRepository>(
            create: (context) => RatingRepository(RatingDao())),
        RepositoryProvider<VaccineRepository>(
            create: (context) => VaccineRepository(VaccineDao())),
        RepositoryProvider<LogRepository>(
            create: (context) => LogRepository(LogDao())),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              childRepository: RepositoryProvider.of<ChildRepository>(context),
              ratingRepository:
                  RepositoryProvider.of<RatingRepository>(context),
              decisionRepository:
                  RepositoryProvider.of<DecisionRepository>(context),
              notificationRepository:
                  RepositoryProvider.of<NotificationRepository>(context),
            ),
          ),
          BlocProvider<ChildBloc>(
            create: (context) => ChildBloc(
              childRepository: RepositoryProvider.of<ChildRepository>(context),
              notificationRepository:
                  RepositoryProvider.of<NotificationRepository>(context),
              decisionRepository:
                  RepositoryProvider.of<DecisionRepository>(context),
              milestoneRepository:
                  RepositoryProvider.of<MilestoneRepository>(context),
              vaccineRepository:
                  RepositoryProvider.of<VaccineRepository>(context),
              ratingRepository:
                  RepositoryProvider.of<RatingRepository>(context),
            ),
          ),
          BlocProvider<MilestoneBloc>(
            create: (context) => MilestoneBloc(
              milestoneRepository:
                  RepositoryProvider.of<MilestoneRepository>(context),
              decisionRepository:
                  RepositoryProvider.of<DecisionRepository>(context),
            ),
          ),
          BlocProvider<VaccineBloc>(
            create: (context) => VaccineBloc(
              vaccineRepository:
                  RepositoryProvider.of<VaccineRepository>(context),
              decisionRepository:
                  RepositoryProvider.of<DecisionRepository>(context),
            ),
          ),
          BlocProvider<TipBloc>(
            create: (context) => TipBloc(
              tipRepository: RepositoryProvider.of<TipRepository>(context),
            ),
          ),
          BlocProvider<DecisionBloc>(
            create: (context) => DecisionBloc(
              decisionRepository:
                  RepositoryProvider.of<DecisionRepository>(context),
              notificationRepository:
                  RepositoryProvider.of<NotificationRepository>(context),
              childRepository: RepositoryProvider.of<ChildRepository>(context),
              milestoneRepository:
                  RepositoryProvider.of<MilestoneRepository>(context),
              childBloc: BlocProvider.of<ChildBloc>(context),
              vaccineRepository:
                  RepositoryProvider.of<VaccineRepository>(context),
            ),
          ),
          BlocProvider<NotificationBloc>(
            create: (context) => NotificationBloc(
              notificationRepository:
                  RepositoryProvider.of<NotificationRepository>(context),
            ),
          ),
          BlocProvider<LogBloc>(
            create: (context) => LogBloc(
              logRepository: RepositoryProvider.of<LogRepository>(context),
            ),
          ),
          BlocProvider<RatingBloc>(
            create: (context) => RatingBloc(
              ratingRepository:
                  RepositoryProvider.of<RatingRepository>(context),
            ),
          ),
          BlocProvider<CurrentChildCubit>(
            create: (context) => CurrentChildCubit(
              childRepository: RepositoryProvider.of(context),
            ),
          ),
          BlocProvider<LanguageCubit>(
            create: (context) => LanguageCubit(startLang),
          ),
          BlocProvider<AllPreviousDecisionTakenCubit>(
            create: (context) => AllPreviousDecisionTakenCubit(
              milestoneRepository:
                  RepositoryProvider.of<MilestoneRepository>(context),
              vaccineRepository:
                  RepositoryProvider.of<VaccineRepository>(context),
              decisionRepository:
                  RepositoryProvider.of<DecisionRepository>(context),
            ),
          ),
        ],
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
