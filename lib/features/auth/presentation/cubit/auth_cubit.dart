import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/auth/domain/usecases/auth_state_change_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  StreamSubscription? _authSubscription;
  final AuthStateChangeUsecase authStateChangeUsecase;
  AuthCubit({required this.authStateChangeUsecase}) : super(AuthInitial()) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription = authStateChangeUsecase().listen((user) {
      if (user != null) {
        emit(Authenticated());
      } else {
        emit(UnAuthenticated());
      }
    });
  }

  @override
  Future<void> close() {
    _authSubscription!.cancel();
    return super.close();
  }
}
