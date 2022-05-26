import 'package:child_milestone/logic/blocs/auth/auth_bloc.dart';
import 'package:child_milestone/logic/blocs/auth/auth_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_milestone/data/repositories/child_repository.dart';
import 'package:child_milestone/logic/blocs/internet/internet_bloc.dart';
import 'package:child_milestone/logic/blocs/town/town_bloc.dart';
import 'package:child_milestone/logic/cubits/price_estimation/price_estimation_cubit.dart';
import 'package:child_milestone/presentation/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(Application(
    appRouter: AppRouter(),
    connectivity: Connectivity(),
  ));
}

class Application extends StatelessWidget {
  final AppRouter appRouter;
  final Connectivity connectivity;

  const Application({
    Key? key,
    required this.appRouter,
    required this.connectivity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ChildRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InternetBloc>(
            create: (internetBlocContext) =>
                InternetBloc(connectivity: connectivity),
          ),
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            // accentColor: Colors.blue,
            visualDensity: VisualDensity.standard,
          ),
          onGenerateRoute: appRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
