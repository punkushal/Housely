import 'package:equatable/equatable.dart';

import '../../../property/domain/entities/property.dart';

class Favorite extends Equatable {
  final Property property;
  final String favoriteId;

  const Favorite({required this.property, required this.favoriteId});

  @override
  List<Object?> get props => [favoriteId, property];
}
