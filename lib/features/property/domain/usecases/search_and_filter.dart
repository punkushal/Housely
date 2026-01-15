import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/domain/entities/property_filter_params.dart';
import 'package:housely/features/property/domain/repository/property_repo.dart';

class SearchAndFilter
    implements
        UseCase<
          (List<Property> properties, DocumentSnapshot? lastDoc),
          SearchAndFilterParam
        > {
  final PropertyRepo repo;

  SearchAndFilter(this.repo);
  @override
  ResultFuture<(List<Property> properties, DocumentSnapshot? lastDoc)> call(
    params,
  ) async {
    return await repo.searchPropertiesWithFilters(
      filters: params.filterParams,
      lastDoc: params.lastDoc,
    );
  }
}

class SearchAndFilterParam extends Equatable {
  final PropertyFilterParams filterParams;
  final DocumentSnapshot? lastDoc;

  const SearchAndFilterParam({required this.filterParams, this.lastDoc});

  @override
  List<Object?> get props => [filterParams, lastDoc];
}
