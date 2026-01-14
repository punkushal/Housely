part of 'property_search_bloc.dart';

sealed class PropertySearchEvent extends Equatable {
  const PropertySearchEvent();

  @override
  List<Object> get props => [];
}

final class PropertySearchAndFilterReset extends PropertySearchEvent {}

final class GetSearchAndFilterProperties extends PropertySearchEvent {
  final PropertyFilterParams filterParams;
  final DocumentSnapshot? lastDoc;

  const GetSearchAndFilterProperties({
    required this.filterParams,
    this.lastDoc,
  });
}

final class LoadMoreProperties extends PropertySearchEvent {}
