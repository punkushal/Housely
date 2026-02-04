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
import 'package:housely/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:housely/features/profile/presentation/widgets/profile_section.dart';
import 'package:housely/features/property/presentation/cubit/owner/owner_cubit.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';

@RoutePage()
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.appUser,
    required this.profileCubit,
    this.owner,
  });
  final AppUser appUser;
  final ProfileCubit profileCubit;
  final PropertyOwner? owner;
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = .new();
  final TextEditingController _phoneController = .new();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.appUser.username;

    if (widget.owner != null) {
      _phoneController.text = widget.owner!.phone;
    }
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
    );

    final hasData = widget.owner != null;

    context.read<ProfileCubit>().updateUserProfile(
      appUser: updatedUser,
      owner: hasData
          ? widget.owner!.copyWith(
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
            )
          : null,
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
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }

          if (state.imageError != null) {
            SnackbarHelper.showError(context, state.imageError!);
          }

          // success
          if (state.status == .success) {
            context.read<ProfileCubit>().reset();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          final isLoading = state.status == .loading;
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

                          BlocBuilder<OwnerCubit, OwnerState>(
                            builder: (context, ownerState) {
                              if (ownerState is OwnerLoaded &&
                                  ownerState.owner != null) {
                                return CustomLabelTextField(
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
                                );
                              }
                              return const SizedBox.shrink();
                            },
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
