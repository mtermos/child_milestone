import 'package:flutter/material.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final BuildContext context;
  final String username;
  final String password;

  Function onSuccess;

  LoginEvent(this.context, this.username, this.password, this.onSuccess);
}

class ForceLoginEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {
  Function onSuccess;
  LogoutEvent(this.onSuccess);
}

class SignUpEvent extends AuthEvent {}

class ForgotPasswordEvent extends AuthEvent {}

class ResendCodeEvent extends AuthEvent {
  final email;
  ResendCodeEvent({required this.email});
}

class ResetStateEvent extends AuthEvent {}
