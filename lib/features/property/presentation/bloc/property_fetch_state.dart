part of 'property_bloc.dart';

sealed class PropertyFetchState extends Equatable {
  const PropertyFetchState();

  @override
  List<Object> get props => [];
}

final class PropertyInitial extends PropertyFetchState {}

final class PropertyFetchLoading extends PropertyFetchState {}

final class PropertyLoaded extends PropertyFetchState {
  final List<Property> allProperties;

  const PropertyLoaded(this.allProperties);
}

final class PropertyFetchError extends PropertyFetchState {
  final String message;

  const PropertyFetchError(this.message);
}
