import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
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
                  headingTitle: "Register Account",
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

                // Username input field
                CustomLabelTextField(
                  labelText: 'Username',
                  customTextField: CustomTextField(
                    hintText: 'Username',
                    controller: _usernameController,
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

                // checkbox section
                CheckboxSection(
                  hasHighlightText: true,
                  value: true,
                  onChanged: (value) {
                    // TODO implement check box on changed functionality
                  },
                ),

                SizedBox(height: ResponsiveDimensions.getHeight(context, 12)),

                // sign up button
                CustomButton(
                  onTap: () {
                    //TODO later i will implement actual login logic
                  },
                  child: Text(
                    "Sign up",
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

                SizedBox(height: ResponsiveDimensions.getHeight(context, 4)),

                // google sign in section
                GoogleSignInContainer(
                  onTap: () {
                    //TODO later i will implement google sign in functionality
                  },
                ),

                SizedBox(height: ResponsiveDimensions.getHeight(context, 4)),

                // sign up section
                RedirectSection(
                  infoText: "Already have an account ?",
                  redirectLinkText: "Sign in",
                  navigateTo: () {
                    context.router.pop();
                  },
                ),

                SizedBox(height: ResponsiveDimensions.getHeight(context, 4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
