import 'package:bloc/bloc.dart';
import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/data/database/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_state.dart';
import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final storage = const FlutterSecureStorage();

  AuthBloc() : super(UnlogedState()) {
    on<LoginEvent>(_login);
    on<LogoutEvent>(_logout);
  }

  void _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(LoadingLoginState());

    // final response = await http.post(Uri.parse(Urls.backendUrl + Urls.loginUrl),
    //     body: {"email": event.username, "password": event.password});
    // var responseBody = json.decode(response.body);
    // if (response.statusCode == 200) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefKeys.isLogged, true);
    // await prefs.setString(SharedPrefKeys.accessToken, responseBody["token"]);
    await prefs.setString(SharedPrefKeys.accessToken, "token");
    await storage.write(key: StorageKeys.username, value: event.username);
    await storage.write(key: StorageKeys.password, value: event.password);
    event.onSuccess();

    emit(LogedState());
    // } else {
    //   emit(LoginErrorState(error: jsonDecode(response.body)["message"]));
    // }
  }

  void _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(LoadingLogoutState());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    final dbProvider = DatabaseProvider.dbProvider;
    final db = await dbProvider.database;
    await db.delete(childrenTABLE);
    await db.delete(milestonesTABLE);
    await db.delete(tipsTABLE);
    await db.delete(notificationsTABLE);
    await db.delete(decisionsTABLE);
    await db.delete(ratingsTABLE);
    event.onSuccess();

    emit(UnlogedState());
  }
}
