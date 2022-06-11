import 'package:bloc/bloc.dart';
import 'package:child_milestone/constants/strings.dart';
import 'package:child_milestone/logic/shared/api_auth.dart';
import 'package:child_milestone/logic/shared/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_state.dart';
import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(UnlogedState()) {
    on<LoginEvent>(_login);
    on<LogoutEvent>(_logout);
  }

  @override
  get initialState => UnlogedState();

  bool _isLoged = false;

  void _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(LoadingLoginState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SHARED_LOGGED, true);
    await prefs.setString(SHARED_USER, event.username);
    await prefs.setString(SHARED_PASSWORD, event.password);
    await Future.delayed(Duration(seconds: 1));
    event.onSuccess();
    // await Locator.instance.get<ApiAuth>().login();

    emit(LogedState());
  }

  void _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(LoadingLogoutState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SHARED_LOGGED, false);
    await prefs.setString(SHARED_USER, "");
    await prefs.setString(SHARED_PASSWORD, "");
    await prefs.setInt(SELECTED_CHILD_ID, -1);
    await Future.delayed(Duration(milliseconds: 500));
    event.onSuccess();
    // await Locator.instance.get<ApiAuth>().login();

    emit(UnlogedState());
  }

  // @override
  // Stream<AuthState> mapEventToState(AuthEvent event) async* {
  //   try {
  //     if (event is LoginEvent) {
  //       yield LoadingLoginState();
  //       print('LoadingLoginState');
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setBool(SHARED_LOGGED, true);
  //       await prefs.setString(SHARED_USER, "email@test.com");
  //       await prefs.setString(SHARED_PASSWORD, "password");

  //       await Locator.instance.get<ApiAuth>().login();

  //       yield LogedState();
  //     } else if (event is LogoutEvent) {
  //       yield LoadingLogoutState();
  //       print('LoadingLogoutState');

  //       // await Locator.instance.get<ApiAuth>().logout();

  //       yield UnlogedState();
  //     } else if (event is ForceLoginEvent) {
  //       yield ForcingLoginState();

  //       // verify if is loged
  //       await Future.delayed(Duration(seconds: 1));

  //       yield _isLoged ? LogedState() : UnlogedState();

  //       yield LoginErrorState();
  //     } else if (event is SignUpEvent) {
  //       yield LoadingSignUpState();
  //       print('LoadingSignUpState');

  //       // await Locator.instance.get<ApiAuth>().signUp();

  //       yield LoadedSignUpState();
  //     } else if (event is ForgotPasswordEvent) {
  //       yield LoadingForgotPasswordState();
  //       print('LoadingForgotPasswordState');

  //       // await Locator.instance.get<ApiAuth>().changePassword();

  //       yield LoadedForgotPasswordState();
  //     } else if (event is ResendCodeEvent) {
  //       yield LoadingResendCodeState();
  //       print('LoadingResendCodeState');

  //       // await Locator.instance.get<ApiAuth>().resendCode(email: event.email);

  //       yield LoadedResendCodeState();
  //     } else {
  //       yield UnlogedState();
  //     }
  //   } catch (e) {
  //     yield LoginErrorState();
  //   }
  // }
}
