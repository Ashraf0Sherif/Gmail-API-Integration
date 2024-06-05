part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserCredential credential;

  AuthSuccess(this.credential);
}

class AuthFailure extends AuthState {
  String errorMessage;

  AuthFailure(this.errorMessage);
}
