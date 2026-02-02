import 'package:housely/core/utils/typedef.dart';
import '../entity/favorite.dart';

abstract interface class FavoritesRepository {
  /// Add favorite
  ResultVoid addFavorite(Favorite favorite);

  /// Remove favorite
  ResultVoid removeFavorite(String favoriteId);

  /// Get favorite list
  ResultFuture<List<Favorite>> getFavorites();

  /// Check if favorite
  ResultFuture<bool> isFavorite(String favoriteId);
}
