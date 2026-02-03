import 'package:equatable/equatable.dart';
import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/favorites/domain/entity/favorite.dart';
import 'package:housely/features/favorites/domain/repository/favorite_repository.dart';

class AddFavoriteUseCase implements UseCase<void, AddFavoriteParam> {
  final FavoritesRepository favoritesRepository;

  AddFavoriteUseCase(this.favoritesRepository);
  @override
  ResultVoid call(params) async {
    return favoritesRepository.addFavorite(params.favorite);
  }
}

class AddFavoriteParam extends Equatable {
  final Favorite favorite;

  const AddFavoriteParam(this.favorite);
  @override
  List<Object?> get props => [favorite];
}
