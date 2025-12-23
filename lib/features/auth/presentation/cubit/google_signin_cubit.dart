import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:housely/features/auth/domain/usecases/google_signin_usecase.dart';

part 'google_signin_state.dart';

class GoogleSigninCubit extends Cubit<GoogleSigninState> {
  final GoogleSigninUsecase googleSigninUsecase;
  GoogleSigninCubit({required this.googleSigninUsecase})
    : super(GoogleSigninInitial());

  /// google sign in
  Future<void> googleSignIn() async {
    emit(GoogleSigninLoading());
    final result = await googleSigninUsecase();

    result.fold(
      (failure) => emit(GoogleSigninFailure(failure.message)),
      (success) => emit(GoogleSigninSuccess()),
    );
  }
}
