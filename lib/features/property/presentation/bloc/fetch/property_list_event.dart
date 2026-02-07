part of 'property_list_bloc.dart';

sealed class PropertyListEvent extends Equatable {
  const PropertyListEvent();

  @override
  List<Object?> get props => [];
}

final class GetAllProperties extends PropertyListEvent {
  final DocumentSnapshot? lastDoc;

  const GetAllProperties({this.lastDoc});

  @override
  List<Object?> get props => [lastDoc];
}

final class GetRecommendedProperties extends PropertyListEvent {
  final DocumentSnapshot? lastDoc;

  const GetRecommendedProperties({this.lastDoc});

  @override
  List<Object?> get props => [lastDoc];
}

final class GetNearbyProperties extends PropertyListEvent {
  final DocumentSnapshot? lastDoc;
  final double latitude;
  final double longitude;

  const GetNearbyProperties({
    this.lastDoc,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [lastDoc, latitude, longitude];
}

final class GetMyProperties extends PropertyListEvent {
  final String userId;
  final DocumentSnapshot? lastDoc;
  const GetMyProperties({required this.userId, this.lastDoc});

  @override
  List<Object?> get props => [userId, lastDoc];
}

final class GetPropertyById extends PropertyListEvent {
  final String propertyId;

  const GetPropertyById(this.propertyId);

  @override
  List<Object> get props => [propertyId];
}

class RefreshSingleProperty extends PropertyListEvent {
  final Property updatedProperty;
  const RefreshSingleProperty(this.updatedProperty);
  @override
  List<Object> get props => [updatedProperty];
}
