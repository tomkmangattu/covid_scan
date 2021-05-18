part of 'userdata_cubit.dart';

@immutable
abstract class UserdataState {}

class UserdataInitial extends UserdataState {}

class UserdataLoading extends UserdataState {}

class UserdataError extends UserdataState {
  final String error;
  UserdataError({this.error});
}

class UserdataSucess extends UserdataState {
  final String message;
  UserdataSucess({this.message});
}
