// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/usecases/fetch_all_properties.dart';

part 'property_event.dart';
part 'property_fetch_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyFetchState> {
  final FetchAllProperties fetchAllProperties;
  PropertyBloc(this.fetchAllProperties) : super(PropertyInitial()) {
    on<GetAllProperties>(_fetchAll);
  }

  Future<void> _fetchAll(
    GetAllProperties event,
    Emitter<PropertyFetchState> emit,
  ) async {
    emit(PropertyFetchLoading());
    final result = await fetchAllProperties();
    result.fold((f) => emit(PropertyFetchError(f.message)), (properties) {
      emit(PropertyLoaded(properties));
    });
  }
}
