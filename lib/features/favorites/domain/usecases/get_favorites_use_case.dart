import 'package:housely/core/usecases/usecase.dart';
import 'package:housely/core/utils/typedef.dart';
import 'package:housely/features/favorites/domain/entity/favorite.dart';
import 'package:housely/features/favorites/domain/repository/favorite_repository.dart';

class GetFavoritesUseCase implements UseCaseWithoutParams<List<Favorite>> {
  final FavoritesRepository favoritesRepository;

  GetFavoritesUseCase(this.favoritesRepository);
  @override
  ResultFuture<List<Favorite>> call() async {
    return await favoritesRepository.getFavorites();
  }
}
