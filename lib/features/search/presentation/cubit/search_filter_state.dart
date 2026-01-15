part of 'search_filter_cubit.dart';

class SearchFilterState {
  final Map<String, bool> lookingFor;
  final Map<String, bool> propertyType;
  final RangeValues? priceRange;
  final Set<String> facilities;

  const SearchFilterState({
    required this.lookingFor,
    required this.propertyType,
    this.priceRange,
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
      priceRange: null,
      facilities: <String>{},
    );
  }

  List<String> get selectedLookingFor => lookingFor.entries
      .where((entry) => entry.value) // Filter only true values
      .map((entry) => entry.key)
      .toList();

  // Getter to get selected "Property Type" keys
  List<String> get selectedPropertyTypes => propertyType.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList();

  bool get isPriceRangeActive => priceRange != null;

  SearchFilterState copyWith({
    Map<String, bool>? lookingFor,
    Map<String, bool>? propertyType,
    RangeValues? priceRange,
    bool clearPriceRange = false,
    Set<String>? facilities,
  }) {
    return SearchFilterState(
      lookingFor: lookingFor ?? this.lookingFor,
      propertyType: propertyType ?? this.propertyType,
      priceRange: clearPriceRange ? null : (priceRange ?? this.priceRange),
      facilities: facilities ?? this.facilities,
    );
  }
}
