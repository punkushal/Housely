import 'package:fpdart/fpdart.dart';
import 'package:housely/core/error/failure.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/favorites/data/datasources/favorite_local_data_source.dart';
import 'package:housely/features/favorites/data/model/favorite_model.dart';
import 'package:housely/features/favorites/domain/entity/favorite.dart';
import 'package:housely/features/favorites/domain/repository/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDatasource localDatasource;

  FavoriteRepositoryImpl(this.localDatasource);
  @override
  ResultVoid addFavorite(Favorite favorite) async {
    try {
      await localDatasource.insert(FavoriteModel.fromEntity(favorite));
      return Right(null);
    } catch (e) {
      return Left(
        SqfliteFailure("Failed to insert your favorite: ${e.toString()}"),
      );
    }
  }

  @override
  ResultFuture<List<Favorite>> getFavorites() async {
    try {
      final resultModels = await localDatasource.getAll();
      final result = resultModels.map((model) => model.toEntity()).toList();
      return Right(result);
    } catch (e) {
      return Left(
        SqfliteFailure("Failed to get your favorites: ${e.toString()}"),
      );
    }
  }

  @override
  ResultFuture<bool> isFavorite(String favoriteId) async {
    try {
      final result = await localDatasource.exists(favoriteId);
      return Right(result);
    } catch (e) {
      return Left(
        SqfliteFailure("Failed to check favorite existence: ${e.toString()}"),
      );
    }
  }

  @override
  ResultVoid removeFavorite(String favoriteId) async {
    try {
      await localDatasource.delete(favoriteId);
      return Right(null);
    } catch (e) {
      return Left(
        SqfliteFailure("Failed to remove favorite : ${e.toString()}"),
      );
    }
  }
}
