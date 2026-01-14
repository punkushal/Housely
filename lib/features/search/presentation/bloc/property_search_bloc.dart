import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/entities/property_filter_params.dart';
import 'package:housely/features/property/domain/usecases/search_and_filter.dart';
import 'package:rxdart/rxdart.dart';

part 'property_search_event.dart';
part 'property_search_state.dart';

// Event Transformer for Debouncing (prevents API spam)
EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class PropertySearchBloc
    extends Bloc<PropertySearchEvent, PropertySearchState> {
  final SearchAndFilter searchAndFilter;
  PropertySearchBloc(this.searchAndFilter) : super(PropertySearchInitial()) {
    on<GetSearchAndFilterProperties>(
      _fetchSearchAndFilters,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<PropertySearchAndFilterReset>(_resetSearchAndFilterState);
    on<LoadMoreProperties>(_onLoadMore);
  }

  Future<void> _fetchSearchAndFilters(
    GetSearchAndFilterProperties event,
    Emitter<PropertySearchState> emit,
  ) async {
    emit(PropertySearchLoading());
    final result = await searchAndFilter(
      SearchAndFilterParam(
        filterParams: event.filterParams,
        lastDoc: event.lastDoc,
      ),
    );
    result.fold((f) => emit(PropertySearchError(f.message)), (data) {
      emit(
        PropertySearchAndFilterLoaded(
          allProperties: data.$1,
          lastDoc: data.$2,
          activeFilters: PropertyFilterParams(),
          hasReachedMax: data.$1.length < 10,
        ),
      );
    });
  }

  // Handle Pagination
  Future<void> _onLoadMore(
    LoadMoreProperties event,
    Emitter<PropertySearchState> emit,
  ) async {
    // Only proceed if we are currently in a Loaded state
    if (state is PropertySearchAndFilterLoaded) {
      final currentState = state as PropertySearchAndFilterLoaded;
      if (currentState.hasReachedMax) return; // Stop if end reached

      final result = await searchAndFilter(
        SearchAndFilterParam(
          filterParams: currentState.activeFilters,
          lastDoc: currentState.lastDoc,
        ),
      );

      result.fold((f) => emit(PropertySearchError(f.message)), (data) {
        if (data.$1.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(
            currentState.copyWith(
              properties: List.of(currentState.allProperties)..addAll(data.$1),
              hasReachedMax: data.$1.length < 10,
              lastDoc: data.$2,
            ),
          );
        }
      });
    }
  }

  void _resetSearchAndFilterState(
    PropertySearchAndFilterReset event,
    Emitter<PropertySearchState> emit,
  ) {
    emit(PropertySearchInitial());
  }
}
