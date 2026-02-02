import 'package:equatable/equatable.dart';

import '../../../property/domain/entities/property.dart';

class Favorite extends Equatable {
  final Property property;
  final String id;
  final DateTime addedAt;

  const Favorite({
    required this.property,
    required this.addedAt,
    required this.id,
  });

  @override
  List<Object?> get props => [id, addedAt, property];
}
