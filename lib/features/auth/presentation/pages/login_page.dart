import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/core/widgets/custom_label_text_field.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/auth/presentation/widgets/checkbox_section.dart';
import 'package:housely/features/auth/presentation/widgets/google_sign_in_container.dart';
import 'package:housely/features/auth/presentation/widgets/redirect_section.dart';
import 'package:housely/features/auth/presentation/widgets/welcome_message.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: ResponsiveDimensions.paddingSymmetric(
            context,
            horizontal: 24,
          ),
          child: SingleChildScrollView(
            dragStartBehavior: .down,
            child: Column(
              mainAxisAlignment: .end,
              spacing: ResponsiveDimensions.getHeight(context, 16),
              children: [
                // welcome message section
                WelcomeMessage(
                  headingTitle: "Welcome Back !",
                  subtitle:
                      "Sign in with your email and password\nor social media to continue",
                ),

                SizedBox(height: ResponsiveDimensions.getHeight(context, 12)),

                // Email input field
                CustomLabelTextField(
                  labelText: 'Email',
                  customTextField: CustomTextField(
                    hintText: 'Email',
                    controller: _emailController,
                  ),
                ),

                // Password input field
                CustomLabelTextField(
                  labelText: 'Password',
                  customTextField: CustomTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    suffixIcon: Icon(Icons.visibility_off_outlined),
                  ),
                ),

                // checkbox + forgot password section
                Row(
                  children: [
                    CheckboxSection(
                      labelText: 'Remember me',
                      value: true,
                      onChanged: (value) {
                        // TODO implement check box on changed functionality
                      },
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        // navigation to forgot password page
                      },
                      child: Text(
                        'Forgot password ?',
                        style: AppTextStyle.bodyRegular(
                          context,
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ResponsiveDimensions.getHeight(context, 12)),

                // sign in button
                CustomButton(
                  onTap: () {
                    //TODO later i will implement actual login logic
                  },
                  child: Text(
                    "Sign in",
                    style: AppTextStyle.bodyRegular(
                      context,
                      fontSize: 18,
                      lineHeight: 27,
                      color: AppColors.surface,
                    ),
                  ),
                ),

                SizedBox(height: ResponsiveDimensions.getHeight(context, 6)),

                // or section
                Text(
                  "Or",
                  style: AppTextStyle.bodyRegular(context, fontSize: 14),
                ),

                SizedBox(height: ResponsiveDimensions.getHeight(context, 6)),

                // google sign in section
                GoogleSignInContainer(
                  onTap: () {
                    //TODO later i will implement google sign in functionality
                  },
                ),

                SizedBox(height: ResponsiveDimensions.getHeight(context, 8)),

                // sign up section
                RedirectSection(
                  infoText: "Don't have account ?",
                  redirectLinkText: "Sign up",
                  navigateTo: () {
                    context.router.push(SignupRoute());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
