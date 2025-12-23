import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/network/cubit/connectivity_cubit.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/core/widgets/custom_label_text_field.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:housely/features/auth/presentation/widgets/welcome_message.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  void _handlePasswordReset(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final isConnected = context
          .read<ConnectivityCubit>()
          .checkConnectivityForAction();
      if (isConnected) {
        context.read<PasswordResetCubit>().sendPasswordResetLink(
          email: _emailController.text.trim(),
        );
        return;
      } else {
        SnackbarHelper.showError(
          context,
          "No internet connection. Please try again",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PasswordResetCubit>(),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: ResponsiveDimensions.paddingSymmetric(
              context,
              horizontal: 24,
            ),
            child: Column(
              crossAxisAlignment: .start,
              spacing: ResponsiveDimensions.getHeight(context, 16),
              children: [
                SizedBox(height: ResponsiveDimensions.getHeight(context, 4)),
                WelcomeMessage(
                  headingTitle: "Forgot Password",
                  subtitle: "Enter your email to get reset code",
                ),

                SizedBox(height: ResponsiveDimensions.getHeight(context, 8)),

                // Email input field
                Form(
                  key: _formKey,
                  child: CustomLabelTextField(
                    labelText: 'Email',
                    customTextField: CustomTextField(
                      hintText: 'Email',
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty || value == "") {
                          return "Please enter your email";
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                Spacer(),
                // continue button
                BlocConsumer<PasswordResetCubit, PasswordResetState>(
                  listener: (context, state) {
                    if (state is PasswordResetSuccess) {
                      SnackbarHelper.showInfo(
                        context,
                        "Please check your email we've sent password reset link",
                      );
                      return;
                    } else if (state is PasswordResetFailure) {
                      SnackbarHelper.showError(context, state.message);
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is PasswordResetLoading;
                    return CustomButton(
                      onTap: () => _handlePasswordReset(context),
                      child: isLoading
                          ? CircularProgressIndicator(color: AppColors.surface)
                          : Text(
                              "Continue",
                              style: AppTextStyle.bodyRegular(
                                context,
                                fontSize: 18,
                                lineHeight: 27,
                                color: AppColors.surface,
                              ),
                            ),
                    );
                  },
                ),

                SizedBox(height: ResponsiveDimensions.getHeight(context, 32)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
