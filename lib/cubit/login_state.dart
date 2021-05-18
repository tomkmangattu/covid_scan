part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginOtp extends LoginState {}

class LoginSucess extends LoginState {}

class LoginFail extends LoginState {
  final String reason;
  LoginFail({this.reason});
}

class NewUser extends LoginState {}

class OldUser extends LoginState {}
