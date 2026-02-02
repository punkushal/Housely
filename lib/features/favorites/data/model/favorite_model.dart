import 'package:housely/features/favorites/domain/entity/favorite.dart';
import 'package:housely/features/property/data/models/property_model.dart';

class FavoriteModel {
  final int id; // sqlite auto increment pk id
  final String favoriteId;
  final PropertyModel property;
  final int addedAtEpoch;
  FavoriteModel({
    required this.id,
    required this.favoriteId,
    required this.property,
    required this.addedAtEpoch,
  });

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'],
      favoriteId: map['favorite_id'],
      property: PropertyModel.fromSqfliteMap(map),
      addedAtEpoch: map['added_at'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'favorite_id': favoriteId,
      'property': property.toSqfliteMap(),
      'added_at': addedAtEpoch,
    };
  }

  Favorite toEntity() => Favorite(
    property: property,
    favoriteId: favoriteId,
    addedAt: DateTime.fromMillisecondsSinceEpoch(addedAtEpoch),
  );

  factory FavoriteModel.fromEntity(Favorite entity) => FavoriteModel(
    id: -1,
    favoriteId: entity.favoriteId,
    property: PropertyModel.fromEntity(entity.property),
    addedAtEpoch: entity.addedAt.millisecondsSinceEpoch,
  );
}
