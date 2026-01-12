part of 'search_filter_cubit.dart';

class SearchFilterState {
  final Map<String, bool> lookingFor;
  final Map<String, bool> propertyType;
  final RangeValues priceRange;
  final Set<String> facilities;

  const SearchFilterState({
    required this.lookingFor,
    required this.propertyType,
    required this.priceRange,
    required this.facilities,
  });

  factory SearchFilterState.initial() {
    return SearchFilterState(
      lookingFor: {
        PropertyStatus.rent.name.toLowerCase(): false,
        PropertyStatus.sale.name.toLowerCase(): false,
      },
      propertyType: {
        PropertyType.apartment.name: false,
        PropertyType.house.name: false,
        PropertyType.hotel.name: false,
        PropertyType.villa.name: false,
        PropertyType.penthouse.name: false,
      },
      priceRange: const RangeValues(10, 1000),
      facilities: <String>{},
    );
  }

  SearchFilterState copyWith({
    Map<String, bool>? lookingFor,
    Map<String, bool>? propertyType,
    RangeValues? priceRange,
    Set<String>? facilities,
  }) {
    return SearchFilterState(
      lookingFor: lookingFor ?? this.lookingFor,
      propertyType: propertyType ?? this.propertyType,
      priceRange: priceRange ?? this.priceRange,
      facilities: facilities ?? this.facilities,
    );
  }
}
