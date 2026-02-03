import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/favorites/domain/repository/favorite_repository.dart';

class IsFavoriteUseCase implements UseCase<bool, IsFavoriteParam> {
  final FavoritesRepository favoritesRepository;

  IsFavoriteUseCase(this.favoritesRepository);
  @override
  ResultFuture<bool> call(params) async {
    return favoritesRepository.isFavorite(params.favoriteId);
  }
}

class IsFavoriteParam extends Equatable {
  final String favoriteId;

  const IsFavoriteParam(this.favoriteId);
  @override
  List<Object?> get props => [favoriteId];
}
