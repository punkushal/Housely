import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/auth/domain/usecases/send_password_reset_usecase.dart';

part 'password_reset_state.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  final SendPasswordResetUsecase resetUsecase;
  PasswordResetCubit({required this.resetUsecase})
    : super(PasswordResetInitial());

  /// send password reset email link
  Future<void> sendPasswordResetLink({required String email}) async {
    emit(PasswordResetLoading());
    final param = PasswordResetParams(email: email);

    final result = await resetUsecase(param);

    result.fold(
      (failure) => emit(PasswordResetFailure(failure.message)),
      (success) => emit(PasswordResetSuccess()),
    );
  }
}
