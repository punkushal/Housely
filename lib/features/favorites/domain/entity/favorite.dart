import 'package:equatable/equatable.dart';

import '../../../property/domain/entities/property.dart';

class Favorite extends Equatable {
  final Property property;
  final String favoriteId;
  final DateTime addedAt;
  const Favorite({
    required this.property,
    required this.favoriteId,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [favoriteId, property, addedAt];
}
