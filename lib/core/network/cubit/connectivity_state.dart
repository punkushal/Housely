part of 'connectivity_cubit.dart';

sealed class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

final class ConnectivityConnected extends ConnectivityState {
  final bool showMessage;

  const ConnectivityConnected({this.showMessage = true});

  @override
  List<Object> get props => [showMessage];
}

final class ConnectivityDisconnected extends ConnectivityState {}
