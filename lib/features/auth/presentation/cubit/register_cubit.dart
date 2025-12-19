import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/features/auth/domain/usecases/register_usecase.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUsecase registerUsecase;
  RegisterCubit({required this.registerUsecase}) : super(RegisterInitial());

  /// register using register usecase
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());

    final params = RegisterParams(
      username: name,
      email: email,
      password: password,
    );

    final result = await registerUsecase(params);

    result.fold(
      (failure) => emit(RegisterError(failure.message)),
      (_) => emit(RegisterSuccess()),
    );
  }
}
