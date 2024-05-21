part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess(this.user);
}

final class AuthSignOutState extends AuthState {
  final String message;
  const AuthSignOutState({required this.message});
}

final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure({required this.message});
}
