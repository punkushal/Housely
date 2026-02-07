part of 'password_reset_cubit.dart';

sealed class PasswordResetState extends Equatable {
  const PasswordResetState();

  @override
  List<Object> get props => [];
}

final class PasswordResetInitial extends PasswordResetState {}

final class PasswordResetLoading extends PasswordResetState {}

final class PasswordResetSuccess extends PasswordResetState {}

final class PasswordResetFailure extends PasswordResetState {
  final String message;

  const PasswordResetFailure(this.message);

  @override
  List<Object> get props => [message];
}
