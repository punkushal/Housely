part of 'google_signin_cubit.dart';

sealed class GoogleSigninState extends Equatable {
  const GoogleSigninState();

  @override
  List<Object> get props => [];
}

final class GoogleSigninInitial extends GoogleSigninState {}

final class GoogleSigninLoading extends GoogleSigninState {}

final class GoogleSigninSuccess extends GoogleSigninState {}

final class GoogleSigninFailure extends GoogleSigninState {
  final String message;
  const GoogleSigninFailure(this.message);

  @override
  List<Object> get props => [message];
}
