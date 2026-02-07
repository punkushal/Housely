import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/core/validator/form_validator.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/core/widgets/custom_label_text_field.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:housely/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:housely/features/profile/presentation/widgets/profile_section.dart';
import 'package:housely/features/property/presentation/cubit/owner/owner_cubit.dart';

@RoutePage()
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.appUser,
    required this.profileCubit,
  });
  final AppUser appUser;
  final ProfileCubit profileCubit;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.appUser.username;
    _phoneController.text = widget.appUser.phoneNumber ?? "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onUpdateProfile(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final updatedUser = widget.appUser.copyWith(
      username: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
    );

    // We no longer pass the owner object explicitly since the remote data source will handle synchronization based on AppUser data.
    context.read<ProfileCubit>().updateUserProfile(
      appUser: updatedUser,
      owner: null, 
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.profileCubit,
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) async {
          // errors
          if (state.errorMessage != null) {
             SnackbarHelper.showError(context, state.errorMessage!);
          }

          if (state.imageError != null) {
            SnackbarHelper.showError(context, state.imageError!);
          }

          // success
          if (state.status == ProfileStatus.success) {
            // Sync AuthCubit with updated user data
            if (state.appUser != null) {
              context.read<AuthCubit>().updateUser(state.appUser!);
            }
            
            // Sync OwnerCubit to reflect new profile changes (creation/update)
            context.read<OwnerCubit>().fetchProfile();

            context.read<ProfileCubit>().reset();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          final isLoading = state.status == ProfileStatus.loading;
          return PopScope(
            canPop: !isLoading,
            child: Scaffold(
              appBar: AppBar(title: const Text("Edit Profile")),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: ResponsiveDimensions.paddingSymmetric(
                      context,
                      horizontal: 22,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        spacing: ResponsiveDimensions.spacing12(context),
                        children: [
                          // change profile picture
                          ProfileSection(isEditing: true),

                          CustomLabelTextField(
                            labelText: "Full Name",
                            customTextField: CustomTextField(
                              controller: _nameController,
                              hintText: "Enter your name",
                              validator: (value) =>
                                  FormValidators.validateFullName(value),
                            ),
                          ),

                          CustomLabelTextField(
                            labelText: "Phone Number",
                            customTextField: CustomTextField(
                              hintText: "Enter your number",
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  FormValidators.validatePhoneNumber(
                                    value,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottomSheet: Padding(
                padding: ResponsiveDimensions.paddingSymmetric(
                  context,
                  vertical: 12,
                  horizontal: 22,
                ),
                child: CustomButton(
                  isLoading: isLoading,
                  onTap: () => _onUpdateProfile(context),
                  buttonLabel: "Save Change",
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
