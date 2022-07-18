import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:child_milestone/constants/strings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

    event.onSuccess();

    emit(LogedState());
    // final response = await http.post(Uri.parse(Urls.backendUrl + Urls.loginUrl),
    //     body: {"email": event.username, "password": event.password});
    // var responseBody = json.decode(response.body);
    // if (response.statusCode == 200) {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   await prefs.setBool(SharedPrefKeys.isLogged, true);
    //   await prefs.setString(SharedPrefKeys.accessToken, responseBody["token"]);
    //   await storage.write(key: StorageKeys.username, value: event.username);
    //   await storage.write(key: StorageKeys.password, value: event.password);
    //   event.onSuccess();

    //   emit(LogedState());
    // } else {
    //   emit(LoginErrorState(error: jsonDecode(response.body)["message"]));
    // }
  }

  void _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(LoadingLogoutState());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    event.onSuccess();

    emit(UnlogedState());
  }
}
