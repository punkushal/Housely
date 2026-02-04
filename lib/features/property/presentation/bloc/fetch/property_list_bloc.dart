import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/property/domain/usecases/fetch/get_my_properties_use_case.dart';
import 'package:housely/features/property/domain/usecases/fetch/get_recommended_properties_use_case.dart';
import 'package:housely/features/property/domain/usecases/fetch_all_properties.dart';

import '../../../domain/entities/property.dart';

part 'property_list_event.dart';
part 'property_list_state.dart';

class PropertyListBloc extends Bloc<PropertyListEvent, PropertyListState> {
  final FetchAllProperties fetchAllProperties;
  final GetRecommendedPropertiesUseCase getRecommendedPropertiesUseCase;
  final GetMyPropertiesUseCase getMyPropertiesUseCase;
  PropertyListBloc({
    required this.fetchAllProperties,
    required this.getRecommendedPropertiesUseCase,
    required this.getMyPropertiesUseCase,
  }) : super(PropertyListInitial()) {
    on<GetRecommendedProperties>(_onLoadRecommendedProperties);
    on<GetMyProperties>(_onLoadMyProperties);
    on<GetAllProperties>(_onLoadAllProperties);
  }

  // load all properties
  Future<void> _onLoadAllProperties(
    GetAllProperties event,
    Emitter<PropertyListState> emit,
  ) async {
    emit(PropertyListLoading(section: .all));
    final result = await fetchAllProperties(FetchParam(event.lastDoc));

    result.fold((f) => emit(PropertyListFailure(f.message, section: .all)), (
      value,
    ) {
      final currentState = state is PropertyListLoaded
          ? (state as PropertyListLoaded)
          : const PropertyListLoaded();
      emit(
        currentState.copyWith(
          allProperties: value.data,
          allPropertiesLastDoc: value.lastDoc,
        ),
      );
    });
  }

  // load recommended properties
  Future<void> _onLoadRecommendedProperties(
    GetRecommendedProperties event,
    Emitter<PropertyListState> emit,
  ) async {
    emit(PropertyListLoading(section: .recommended));
    final result = await getRecommendedPropertiesUseCase(
      GetRecommendedParam(event.lastDoc),
    );

    result.fold(
      (f) => emit(PropertyListFailure(f.message, section: .recommended)),
      (value) {
        final currentState = state is PropertyListLoaded
            ? (state as PropertyListLoaded)
            : const PropertyListLoaded();
        emit(
          currentState.copyWith(
            recommendedProperties: value.data,
            recommendedLastDoc: value.lastDoc,
          ),
        );
      },
    );
  }

  // load my properties
  Future<void> _onLoadMyProperties(
    GetMyProperties event,
    Emitter<PropertyListState> emit,
  ) async {
    emit(PropertyListLoading(section: .all));
    final result = await getMyPropertiesUseCase(
      MyPropertyParam(userId: event.userId, lastDoc: event.lastDoc),
    );

    result.fold((f) => emit(PropertyListFailure(f.message, section: .all)), (
      value,
    ) {
      final currentState = state is PropertyListLoaded
          ? (state as PropertyListLoaded)
          : const PropertyListLoaded();
      emit(
        currentState.copyWith(
          allProperties: value.data,
          allPropertiesLastDoc: value.lastDoc,
        ),
      );
    });
  }
}
