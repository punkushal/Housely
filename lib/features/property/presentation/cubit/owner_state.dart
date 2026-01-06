part of 'owner_cubit.dart';

sealed class OwnerState extends Equatable {
  const OwnerState();

  @override
  List<Object> get props => [];
}

final class OwnerInitial extends OwnerState {}

final class OwnerLoading extends OwnerState {}

final class OwnerCreated extends OwnerState {
  final PropertyOwner owner;

  const OwnerCreated(this.owner);
}

final class OwnerProfileUploaded extends OwnerState {
  const OwnerProfileUploaded();
}

final class OwnerLoaded extends OwnerState {
  final PropertyOwner? owner;

  const OwnerLoaded({this.owner});
}

final class OwnerError extends OwnerState {
  final String message;

  const OwnerError(this.message);
}
