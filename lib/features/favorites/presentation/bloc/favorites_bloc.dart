import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/favorites/domain/usecases/add_favorite_use_case.dart';
import 'package:housely/features/favorites/domain/usecases/get_favorites_use_case.dart';
import 'package:housely/features/favorites/domain/usecases/is_favorite_use_case.dart';
import 'package:housely/features/favorites/domain/usecases/remove_favorite_use_case.dart';

import '../../domain/entity/favorite.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final AddFavoriteUseCase addFavoriteUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;
  final RemoveFavoriteUseCase removeFavoriteUseCase;
  final IsFavoriteUseCase isFavoriteUseCase;
  FavoritesBloc({
    required this.addFavoriteUseCase,
    required this.removeFavoriteUseCase,
    required this.getFavoritesUseCase,
    required this.isFavoriteUseCase,
  }) : super(FavoritesInitial()) {
    on<LoadFavoritesRequested>(_onLoad);
    on<ToggleFavoriteRequested>(_onToggle);
  }
  Future<void> _onLoad(
    LoadFavoritesRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    final result = await getFavoritesUseCase();
    result.fold((f) => emit(FavoritesError(f.message)), (list) {
      emit(FavoritesLoaded(list));
    });
  }

  Future<void> _onToggle(
    ToggleFavoriteRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    // Check if item is currently a favorite
    final checkResult = await isFavoriteUseCase(
      IsFavoriteParam(event.favoriteId),
    );

    // Extract the check result or return error
    final isFavorite = checkResult.fold<bool?>((failure) {
      emit(FavoritesError(failure.message));
      return null;
    }, (isFav) => isFav);

    // If check failed, it'll stop
    if (isFavorite == null) return;

    // Add or remove based on current state
    if (isFavorite) {
      // Remove from favorites
      final removeResult = await removeFavoriteUseCase(
        RemoveFavoriteParam(event.favoriteId),
      );

      // Handle remove error
      final removeError = removeResult.fold(
        (failure) => failure.message,
        (_) => null,
      );

      if (removeError != null) {
        emit(FavoritesError(removeError));
        return;
      }
    } else {
      // Add to favorites
      final addResult = await addFavoriteUseCase(
        AddFavoriteParam(event.favorite),
      );

      // Handle add error
      final addError = addResult.fold(
        (failure) => failure.message,
        (_) => null,
      );

      if (addError != null) {
        emit(FavoritesError(addError));
        return;
      }
    }

    // Reload the favorites list
    final getFavoritesResult = await getFavoritesUseCase();

    getFavoritesResult.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) {
        // Emit appropriate state based on action
        if (isFavorite) {
          emit(FavoriteRemoved(favorites));
        } else {
          emit(FavoriteAdded(favorites));
        }
      },
    );
  }
}
