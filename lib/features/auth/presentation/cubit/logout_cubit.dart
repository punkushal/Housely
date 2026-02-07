import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/auth/domain/usecases/logout_usecase.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogOutUseCase logOutUseCase;
  LogoutCubit({required this.logOutUseCase}) : super(LogoutInitial());

  /// logout user
  Future<void> logout() async {
    emit(LogoutLoading());
    final result = await logOutUseCase();

    result.fold(
      (failure) => emit(LogoutFailure(failure.message)),
      (success) => emit(LogoutSuccess()),
    );
  }
}
