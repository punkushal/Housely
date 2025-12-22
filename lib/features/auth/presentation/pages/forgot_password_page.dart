import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/core/widgets/custom_label_text_field.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/auth/presentation/widgets/welcome_message.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
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
              CustomLabelTextField(
                labelText: 'Email',
                customTextField: CustomTextField(
                  hintText: 'Email',
                  controller: _emailController,
                ),
              ),

              Spacer(),
              // continue button
              CustomButton(
                onTap: () {
                  // navigation to email verfication page
                  context.router.push(EmailVerificationRoute());
                },
                child: Text(
                  "Continue",
                  style: AppTextStyle.bodyRegular(
                    context,
                    fontSize: 18,
                    lineHeight: 27,
                    color: AppColors.surface,
                  ),
                ),
              ),

              SizedBox(height: ResponsiveDimensions.getHeight(context, 32)),
            ],
          ),
        ),
      ),
    );
  }
}
