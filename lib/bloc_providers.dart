import 'package:child_milestone/data/dao/child_dao.dart';
import 'package:child_milestone/data/repositories/child_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:child_milestone/data/repositories/decision_repository.dart';
import 'package:child_milestone/data/repositories/log_repository.dart';
import 'package:child_milestone/data/repositories/milestone_repository.dart';
import 'package:child_milestone/data/repositories/notification_repository.dart';
import 'package:child_milestone/data/repositories/rating_repository.dart';
import 'package:child_milestone/data/repositories/tip_repository.dart';
import 'package:child_milestone/data/repositories/vaccine_repository.dart';

import 'package:child_milestone/data/dao/decision_dao.dart';
import 'package:child_milestone/data/dao/log_dao.dart';
import 'package:child_milestone/data/dao/milestone_dao.dart';
import 'package:child_milestone/data/dao/notification_dao.dart';
import 'package:child_milestone/data/dao/rating_dao.dart';
import 'package:child_milestone/data/dao/tip_dao.dart';
import 'package:child_milestone/data/dao/vaccine_dao.dart';

class BlocProviders {
  static List<BlocProvider> getProviders(
      BuildContext context, Locale startLang) {
    return [
      BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          childRepository: RepositoryProvider.of<ChildRepository>(context),
          ratingRepository: RepositoryProvider.of<RatingRepository>(context),
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
          vaccineRepository: RepositoryProvider.of<VaccineRepository>(context),
          ratingRepository: RepositoryProvider.of<RatingRepository>(context),
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
          vaccineRepository: RepositoryProvider.of<VaccineRepository>(context),
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
          vaccineRepository: RepositoryProvider.of<VaccineRepository>(context),
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
          ratingRepository: RepositoryProvider.of<RatingRepository>(context),
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
          vaccineRepository: RepositoryProvider.of<VaccineRepository>(context),
          decisionRepository:
              RepositoryProvider.of<DecisionRepository>(context),
        ),
      ),
    ];
  }
}

class RepositoryProviders {
  static List<RepositoryProvider> getProviders(BuildContext context) {
    return [
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
    ];
  }
}
