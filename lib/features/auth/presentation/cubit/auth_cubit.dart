import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';
import 'package:housely/features/auth/domain/usecases/auth_state_change_usecase.dart';
import 'package:housely/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:housely/features/auth/domain/usecases/login_status_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  StreamSubscription? _authSubscription;
  final AuthStateChangeUsecase authStateChangeUsecase;
  final LoginStatusUsecase statusUsecase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  AuthCubit({
    required this.authStateChangeUsecase,
    required this.statusUsecase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription = authStateChangeUsecase().listen((user) {
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    });
  }

  Future<void> checkLoginStatus() async {
    final isLoggedIn = statusUsecase();
    if (isLoggedIn) {
      final result = await getCurrentUserUseCase();

      result.fold((f) => emit(UnAuthenticated()), (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
      });
    } else {
      emit(UnAuthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
