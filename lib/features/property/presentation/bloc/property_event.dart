part of 'property_bloc.dart';

sealed class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object> get props => [];
}

final class GetAllProperties extends PropertyEvent {}

final class GetOwnerProperties extends PropertyEvent {
  final String propertyId;

  const GetOwnerProperties({required this.propertyId});
}

final class DeleteProperty extends PropertyEvent {
  final String propertyId;

  const DeleteProperty({required this.propertyId});
}
