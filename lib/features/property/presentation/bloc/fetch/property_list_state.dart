part of 'property_list_bloc.dart';

/// Enum to identify which property section is being loaded/failed
enum PropertySection { all, recommended, nearby, my }

sealed class PropertyListState extends Equatable {
  const PropertyListState();

  @override
  List<Object?> get props => [];
}

final class PropertyListInitial extends PropertyListState {}

final class PropertyListLoading extends PropertyListState {
  /// Indicates which section is loading
  final PropertySection section;

  const PropertyListLoading({required this.section});

  @override
  List<Object?> get props => [section];
}

final class PropertyListLoaded extends PropertyListState {
  final List<Property>? allProperties;
  final List<Property>? myProperties;
  final DocumentSnapshot? lastDoc;
  final List<Property>? recommendedProperties;
  final List<Property>? nearbyProperties;
  final DocumentSnapshot? allPropertiesLastDoc;
  final DocumentSnapshot? recommendedLastDoc;
  final DocumentSnapshot? nearbyLastDoc;
  final DocumentSnapshot? myPropertiesLastDoc;
  const PropertyListLoaded({
    this.allProperties,
    this.lastDoc,
    this.nearbyProperties,
    this.recommendedProperties,
    this.allPropertiesLastDoc,
    this.myPropertiesLastDoc,
    this.nearbyLastDoc,
    this.recommendedLastDoc,
    this.myProperties,
  });

  PropertyListLoaded copyWith({
    List<Property>? allProperties,
    List<Property>? recommendedProperties,
    List<Property>? nearbyProperties,
    List<Property>? myProperties,
    DocumentSnapshot? allPropertiesLastDoc,
    DocumentSnapshot? recommendedLastDoc,
    DocumentSnapshot? nearbyLastDoc,
    DocumentSnapshot? myPropertiesLastDoc,
  }) {
    return PropertyListLoaded(
      allProperties: allProperties ?? this.allProperties,
      recommendedProperties:
          recommendedProperties ?? this.recommendedProperties,
      nearbyProperties: nearbyProperties ?? this.nearbyProperties,
      allPropertiesLastDoc: allPropertiesLastDoc ?? this.allPropertiesLastDoc,
      recommendedLastDoc: recommendedLastDoc ?? this.recommendedLastDoc,
      nearbyLastDoc: nearbyLastDoc ?? this.nearbyLastDoc,
      myPropertiesLastDoc: myPropertiesLastDoc ?? this.myPropertiesLastDoc,
      myProperties: myProperties ?? this.myProperties,
    );
  }

  @override
  List<Object?> get props => [
    allProperties,
    myPropertiesLastDoc,
    recommendedLastDoc,
    nearbyLastDoc,
    allPropertiesLastDoc,
    nearbyProperties,
    recommendedProperties,
    myProperties,
  ];
}

final class PropertyRecommendedListLoaded extends PropertyListState {
  final List<Property> allProperties;
  final DocumentSnapshot? lastDoc;

  const PropertyRecommendedListLoaded({
    required this.allProperties,
    this.lastDoc,
  });

  @override
  List<Object?> get props => [allProperties, lastDoc];
}

final class PropertyListFailure extends PropertyListState {
  final String message;
  final PropertySection section;

  const PropertyListFailure(this.message, {required this.section});

  @override
  List<Object> get props => [message, section];
}
