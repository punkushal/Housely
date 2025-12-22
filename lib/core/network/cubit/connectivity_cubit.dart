import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  late final StreamSubscription _subscription;
  bool _isInitialCheck = true;
  bool _shouldSuppressNextConnectedMessage = false;

  ConnectivityCubit() : super(ConnectivityDisconnected()) {
    _subscription = InternetConnection().onStatusChange.listen((status) {
      if (status == .connected) {
        if (_isInitialCheck) {
          _isInitialCheck = false;
          emit(ConnectivityConnected(showMessage: false));
        } else if (_shouldSuppressNextConnectedMessage) {
          _shouldSuppressNextConnectedMessage = false;
          emit(ConnectivityConnected(showMessage: false));
        } else {
          emit(ConnectivityConnected(showMessage: true));
        }
      } else {
        emit(ConnectivityDisconnected());
      }
    });
  }

  /// Call this before performing an action that requires internet
  /// Returns true if connected, false if disconnected
  bool checkConnectivityForAction() {
    _shouldSuppressNextConnectedMessage = true;
    return state is ConnectivityConnected;
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
