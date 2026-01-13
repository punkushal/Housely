import 'package:flutter/material.dart';

class PropertyFilterParams {
  final String? searchQuery;
  final List<String> propertyTypes;
  final RangeValues? priceRange;
  final List<String>? facilities;
  final List<String> propertyStatus;

  PropertyFilterParams({
    this.searchQuery,
    this.propertyTypes = const [],
    this.priceRange,
    this.facilities,
    this.propertyStatus = const [],
  });

  // Helper to check if filters are active
  bool get hasActiveFilters =>
      (searchQuery?.isNotEmpty ?? false) && propertyTypes.isNotEmpty ||
      priceRange != null &&
          (facilities != null || facilities!.isNotEmpty) &&
          propertyStatus.isNotEmpty;

  PropertyFilterParams copyWith({
    String? searchQuery,
    List<String>? propertyTypes,
    RangeValues? priceRange,
    List<String>? facilities,
    List<String>? propertyStatus,
  }) {
    return PropertyFilterParams(
      searchQuery: searchQuery ?? this.searchQuery,
      propertyTypes: propertyTypes ?? this.propertyTypes,
      priceRange: priceRange ?? this.priceRange,
      facilities: facilities ?? this.facilities,
      propertyStatus: propertyStatus ?? this.propertyStatus,
    );
  }
}
