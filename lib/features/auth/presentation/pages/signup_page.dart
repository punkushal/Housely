import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/network/cubit/connectivity_cubit.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/core/validator/form_validator.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/core/widgets/custom_label_text_field.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/auth/presentation/cubit/auth_form_cubit.dart';
import 'package:housely/features/auth/presentation/cubit/google_signin_cubit.dart';
import 'package:housely/features/auth/presentation/cubit/register_cubit.dart';
import 'package:housely/features/auth/presentation/widgets/checkbox_section.dart';
import 'package:housely/features/auth/presentation/widgets/google_sign_in_container.dart';
import 'package:housely/features/auth/presentation/widgets/redirect_section.dart';
import 'package:housely/features/auth/presentation/widgets/welcome_message.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _usernameController.dispose();
  }

  // handle registration functionality
  void _handleRegistration(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterCubit>().signUp(
        name: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      final isConnected = context
          .read<ConnectivityCubit>()
          .checkConnectivityForAction();
      if (isConnected) {
        context.read<RegisterCubit>().signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          name: _usernameController.text.trim(),
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

  // handle google sign in functionality
  void _handleGoogleSignIn(BuildContext context) {
    final isConnected = context
        .read<ConnectivityCubit>()
        .checkConnectivityForAction();
    if (isConnected) {
      context.read<GoogleSigninCubit>().googleSignIn();
      return;
    } else {
      SnackbarHelper.showError(
        context,
        "No internet connection. Please try again",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<RegisterCubit>()),
        BlocProvider(create: (context) => sl<GoogleSigninCubit>()),
        BlocProvider(create: (context) => AuthFormCubit()),
      ],
      child: BlocListener<ConnectivityCubit, ConnectivityState>(
        listener: (context, state) {
          if (state is ConnectivityDisconnected) {
            SnackbarHelper.showError(context, 'No internet connection');
          }
          if (state is ConnectivityConnected && state.showMessage) {
            SnackbarHelper.showSuccess(context, "Internet connected");
          }
        },
        child: Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: Padding(
              padding: ResponsiveDimensions.paddingSymmetric(
                context,
                horizontal: 24,
              ),
              child: SingleChildScrollView(
                dragStartBehavior: .down,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: .end,
                    spacing: ResponsiveDimensions.getHeight(context, 16),
                    children: [
                      // welcome message section
                      WelcomeMessage(
                        headingTitle: "Register Account",
                        subtitle:
                            "Sign in with your email and password\nor social media to continue",
                      ),

                      SizedBox(
                        height: ResponsiveDimensions.getHeight(context, 12),
                      ),

                      // Email input field
                      CustomLabelTextField(
                        labelText: 'Email',
                        customTextField: CustomTextField(
                          hintText: 'Email',
                          controller: _emailController,
                          validator: (value) =>
                              FormValidators.validateEmail(value),
                        ),
                      ),

                      // Username input field
                      CustomLabelTextField(
                        labelText: 'Username',
                        customTextField: CustomTextField(
                          hintText: 'Username',
                          controller: _usernameController,
                          validator: (value) =>
                              FormValidators.validateUsername(value),
                        ),
                      ),

                      // Password input field
                      BlocSelector<AuthFormCubit, AuthFormState, bool>(
                        selector: (state) {
                          return state.isPasswordVisible;
                        },
                        builder: (context, state) {
                          return CustomLabelTextField(
                            labelText: 'Password',
                            customTextField: CustomTextField(
                              controller: _passwordController,
                              hintText: 'Password',
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: state,
                              maxLines: state ? 1 : null,
                              suffixIcon: GestureDetector(
                                onTap: () => context
                                    .read<AuthFormCubit>()
                                    .togglePasswordVissibility(),
                                child: Icon(Icons.visibility_off_outlined),
                              ),
                              validator: (value) =>
                                  FormValidators.validatePassword(value),
                            ),
                          );
                        },
                      ),

                      // confirm password input field
                      BlocSelector<AuthFormCubit, AuthFormState, bool>(
                        selector: (state) {
                          return state.isConfirmPasswordVisible;
                        },
                        builder: (context, state) {
                          return CustomLabelTextField(
                            labelText: 'Confirm Password',
                            customTextField: CustomTextField(
                              controller: _confirmController,
                              hintText: 'Retype Password',
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: state,
                              maxLines: state ? 1 : null,
                              suffixIcon: GestureDetector(
                                onTap: () => context
                                    .read<AuthFormCubit>()
                                    .toggleConfirmPasswordVissibility(),
                                child: Icon(Icons.visibility_off_outlined),
                              ),
                              validator: (value) =>
                                  FormValidators.validateConfirmPassword(
                                    value,
                                    _passwordController.text.trim(),
                                  ),
                            ),
                          );
                        },
                      ),

                      // checkbox section
                      BlocSelector<AuthFormCubit, AuthFormState, bool>(
                        selector: (state) {
                          return state.acceptTerms;
                        },
                        builder: (context, state) {
                          return CheckboxSection(
                            hasHighlightText: true,
                            value: state,
                            onChanged: (value) {
                              context.read<AuthFormCubit>().toggleTerms(value!);
                            },
                          );
                        },
                      ),

                      SizedBox(
                        height: ResponsiveDimensions.getHeight(context, 12),
                      ),

                      // sign up button
                      BlocConsumer<RegisterCubit, RegisterState>(
                        listener: (context, state) {
                          if (state is RegisterSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.success,
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Successfully registered your account',
                                ),
                              ),
                            );

                            context.router.pop();
                          }

                          if (state is RegisterError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.error,
                                duration: Duration(seconds: 3),
                                content: Text(state.error),
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is RegisterLoading;
                          return CustomButton(
                            onTap: () => _handleRegistration(context),
                            buttonLabel: "Sign up",
                            isLoading: isLoading,
                          );
                        },
                      ),

                      SizedBox(
                        height: ResponsiveDimensions.getHeight(context, 6),
                      ),

                      // or section
                      Text(
                        "Or",
                        style: AppTextStyle.bodyRegular(context, fontSize: 14),
                      ),

                      SizedBox(
                        height: ResponsiveDimensions.getHeight(context, 4),
                      ),

                      // google sign in section
                      BlocConsumer<GoogleSigninCubit, GoogleSigninState>(
                        listener: (context, state) {
                          if (state is GoogleSigninFailure) {
                            SnackbarHelper.showError(context, state.message);
                            return;
                          }

                          if (state is GoogleSigninSuccess) {
                            context.router.replace(LocationRoute());
                            SnackbarHelper.showSuccess(
                              context,
                              'Successfully logged in via google',
                            );
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is GoogleSigninLoading;
                          if (isLoading) {
                            return CircularProgressIndicator();
                          }
                          return GoogleSignInContainer(
                            onTap: () => _handleGoogleSignIn(context),
                          );
                        },
                      ),
                      SizedBox(
                        height: ResponsiveDimensions.getHeight(context, 4),
                      ),

                      // sign up section
                      RedirectSection(
                        infoText: "Already have an account ?",
                        redirectLinkText: "Sign in",
                        navigateTo: () {
                          context.router.pop();
                        },
                      ),

                      SizedBox(
                        height: ResponsiveDimensions.getHeight(context, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
