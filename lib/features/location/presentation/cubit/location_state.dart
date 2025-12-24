part of 'location_cubit.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}

final class LocationLoaded extends LocationState {
  final Location location;

  const LocationLoaded({required this.location});

  @override
  List<Object> get props => [location];
}

final class LocationFailure extends LocationState {
  final String message;

  const LocationFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class PermissionDenied extends LocationState {
  final String message;

  const PermissionDenied(this.message);

  @override
  List<Object> get props => [message];
}
