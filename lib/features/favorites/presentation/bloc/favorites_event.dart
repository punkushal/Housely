part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoritesRequested extends FavoritesEvent {}

class ToggleFavoriteRequested extends FavoritesEvent {
  final Favorite favorite;
  final String favoriteId;
  const ToggleFavoriteRequested({
    required this.favorite,
    required this.favoriteId,
  });
  @override
  List<Object> get props => [favorite, favoriteId];
}
