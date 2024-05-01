// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class AuthState {}

class LoadingLogoutState extends AuthState {}

class LoadingLoginState extends AuthState {}

class ForcingLoginState extends AuthState {}

class UnlogedState extends AuthState {}

class LogedState extends AuthState {}

class LoginErrorState extends AuthState {
  String error;
  LoginErrorState({
    required this.error,
  });
  
}

class LoadingSignUpState extends AuthState {}

class LoadedSignUpState extends AuthState {}

class ErrorSignUpState extends AuthState {}

class LoadingForgotPasswordState extends AuthState {}

class LoadedForgotPasswordState extends AuthState {}

class ErrorForgotPasswordState extends AuthState {}

class LoadingResendCodeState extends AuthState {}

class LoadedResendCodeState extends AuthState {}

class ErrorResendCodeState extends AuthState {}
