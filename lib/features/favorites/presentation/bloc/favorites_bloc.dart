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
    on<AddFavoriteRequested>(_onAdd);
    on<RemoveFavoriteRequested>(_onRemove);
    on<CheckFavoriteRequested>(_onCheck);
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

  // -----------------------------------------------------------------
  Future<void> _onAdd(
    AddFavoriteRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await addFavoriteUseCase(AddFavoriteParam(event.favorite));

    result.fold((f) => emit(FavoritesError(f.message)), (_) async {
      // reload to keep list in sync
      final result = await getFavoritesUseCase();

      result.fold((f) => emit(FavoritesError(f.message)), (list) {
        emit(FavoritesLoaded(list));
      });
    });
  }

  // -----------------------------------------------------------------
  Future<void> _onRemove(
    RemoveFavoriteRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await removeFavoriteUseCase(
      RemoveFavoriteParam(event.favoriteId),
    );

    result.fold((f) => emit(FavoritesError(f.message)), (_) async {
      // reload to keep list in sync
      final result = await getFavoritesUseCase();

      result.fold((f) => emit(FavoritesError(f.message)), (list) {
        emit(FavoriteRemoved(list));
      });
    });
  }

  // -----------------------------------------------------------------
  Future<void> _onCheck(
    CheckFavoriteRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await isFavoriteUseCase(IsFavoriteParam(event.favoriteId));
    result.fold(
      (f) => emit(FavoritesError(f.message)),
      (hasData) => emit(FavoriteChecked(hasData)),
    );
  }
}
