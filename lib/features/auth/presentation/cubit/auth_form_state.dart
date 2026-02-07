part of 'auth_form_cubit.dart';

final class AuthFormState extends Equatable {
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool rememberMe;
  final bool acceptTerms;

  const AuthFormState({
    this.isPasswordVisible = true,
    this.isConfirmPasswordVisible = true,
    this.rememberMe = false,
    this.acceptTerms = false,
  });

  AuthFormState copyWith({
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? rememberMe,
    bool? acceptTerms,
  }) {
    return AuthFormState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      acceptTerms: acceptTerms ?? this.acceptTerms,
    );
  }

  @override
  List<Object> get props => [
    isPasswordVisible,
    isConfirmPasswordVisible,
    rememberMe,
    acceptTerms,
  ];
}
