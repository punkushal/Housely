part of 'property_bloc.dart';

sealed class PropertyState extends Equatable {
  const PropertyState();

  @override
  List<Object> get props => [];
}

final class PropertyInitial extends PropertyState {}

final class PropertyLoading extends PropertyState {}

final class PropertyLoaded extends PropertyState {
  final List<Property> allProperties;

  const PropertyLoaded(this.allProperties);
}

final class PropertyError extends PropertyState {
  final String message;

  const PropertyError(this.message);
}
