part of 'favorites_bloc.dart';

sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoritesRequested extends FavoritesEvent {}

class AddFavoriteRequested extends FavoritesEvent {
  final Favorite favorite;
  const AddFavoriteRequested(this.favorite);
  @override
  List<Object> get props => [favorite];
}

class RemoveFavoriteRequested extends FavoritesEvent {
  final String favoriteId;
  const RemoveFavoriteRequested(this.favoriteId);
  @override
  List<Object> get props => [favoriteId];
}

class CheckFavoriteRequested extends FavoritesEvent {
  final String favoriteId;
  const CheckFavoriteRequested(this.favoriteId);
  @override
  List<Object> get props => [favoriteId];
}
