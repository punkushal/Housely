import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/property/domain/entities/property.dart';

part 'search_filter_state.dart';

class SearchFilterCubit extends Cubit<SearchFilterState> {
  SearchFilterCubit() : super(SearchFilterState.initial());

  // property status selection
  void togglePropertyStatus(String key) {
    final updated = Map<String, bool>.from(state.lookingFor);
    updated[key] = !(updated[key] ?? false);
    emit(state.copyWith(lookingFor: updated));
  }

  // property selection
  void togglePropertyType(String key) {
    final updated = Map<String, bool>.from(state.propertyType);
    updated[key] = !(updated[key] ?? false);
    emit(state.copyWith(propertyType: updated));
  }

  //price range selection
  void updatePriceRange(RangeValues range) {
    emit(state.copyWith(priceRange: range));
  }

  // FACILITIES (multi chip select)
  void toggleFacility(String facility) {
    final updated = Set<String>.from(state.facilities);

    if (updated.contains(facility)) {
      updated.remove(facility);
    } else {
      updated.add(facility);
    }

    emit(state.copyWith(facilities: updated));
  }

  // RESET
  void resetFilters() {
    emit(SearchFilterState.initial());
  }
}
