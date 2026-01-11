part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class Authenticated extends AuthState {
  final AppUser? currentUser;

  const Authenticated(this.currentUser);
}

final class UnAuthenticated extends AuthState {}
