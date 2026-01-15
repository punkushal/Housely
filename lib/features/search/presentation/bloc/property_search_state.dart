part of 'property_search_bloc.dart';

sealed class PropertySearchState extends Equatable {
  const PropertySearchState();

  @override
  List<Object> get props => [];
}

final class PropertySearchInitial extends PropertySearchState {}

final class PropertySearchLoading extends PropertySearchState {}

final class PropertySearchAndFilterLoaded extends PropertySearchState {
  final List<Property> allProperties;
  final bool hasReachedMax;
  final DocumentSnapshot? lastDoc;
  final PropertyFilterParams activeFilters;
  const PropertySearchAndFilterLoaded({
    required this.allProperties,
    this.hasReachedMax = false,
    this.lastDoc,
    required this.activeFilters,
  });

  PropertySearchAndFilterLoaded copyWith({
    List<Property>? properties,
    bool? hasReachedMax,
    DocumentSnapshot? lastDoc,
    PropertyFilterParams? activeFilters,
  }) {
    return PropertySearchAndFilterLoaded(
      allProperties: properties ?? allProperties,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastDoc: lastDoc ?? this.lastDoc,
      activeFilters: activeFilters ?? this.activeFilters,
    );
  }
}

final class PropertySearchError extends PropertySearchState {
  final String message;

  const PropertySearchError(this.message);

  @override
  List<Object> get props => [message];
}
