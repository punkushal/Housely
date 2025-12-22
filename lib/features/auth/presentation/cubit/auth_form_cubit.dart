import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_form_state.dart';

class AuthFormCubit extends Cubit<AuthFormState> {
  AuthFormCubit() : super(AuthFormState());

  // toggle password visibility
  void togglePasswordVissibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  // toggle confirm password visibility
  void toggleConfirmPasswordVissibility() {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }

  // toggle checkbox
  void toggleRememberMe(bool value) {
    emit(state.copyWith(rememberMe: value));
  }

  void toggleTerms(bool value) {
    emit(state.copyWith(acceptTerms: value));
  }
}
