import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/favorites/domain/repository/favorite_repository.dart';

class RemoveFavoriteUseCase implements UseCase<void, RemoveFavoriteParam> {
  final FavoritesRepository favoritesRepository;

  RemoveFavoriteUseCase(this.favoritesRepository);
  @override
  ResultVoid call(params) async {
    return favoritesRepository.removeFavorite(params.favoriteId);
  }
}

class RemoveFavoriteParam extends Equatable {
  final String favoriteId;

  const RemoveFavoriteParam(this.favoriteId);
  @override
  List<Object?> get props => [favoriteId];
}
