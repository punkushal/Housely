import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/network/cubit/connectivity_cubit.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/core/validator/form_validator.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/core/widgets/custom_label_text_field.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';
import 'package:housely/features/property/presentation/cubit/owner_cubit.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class CompleteOwnerProfilePage extends StatefulWidget {
  const CompleteOwnerProfilePage({super.key});

  @override
  State<CompleteOwnerProfilePage> createState() =>
      _CompleteOwnerProfilePageState();
}

class _CompleteOwnerProfilePageState extends State<CompleteOwnerProfilePage> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _picker = ImagePicker();
  File? profileImage;
  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _nameController.dispose();
  }

  Future<void> pickProfileImage() async {
    final pickedImg = await _picker.pickImage(source: .gallery);
    if (pickedImg != null) {
      setState(() {
        profileImage = File(pickedImg.path);
      });
    }
  }

  void completeProfile() {
    final isConnected = context
        .read<ConnectivityCubit>()
        .checkConnectivityForAction();

    if (!isConnected) {
      SnackbarHelper.showError(
        context,
        TextConstants.internetError,
        showTop: true,
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      if (profileImage != null) {
        // in firebase remote source i updated owner id with uid
        // that's why here empty id is passed
        final owner = PropertyOwner(
          ownerId: "",
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        );
        context.read<OwnerCubit>().createProfile(owner, profileImage);
      } else {
        SnackbarHelper.showError(
          context,
          "Please pick your profile image",
          showTop: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OwnerCubit, OwnerState>(
      listener: (context, state) {
        if (state is OwnerLoaded && state.owner != null) {
          SnackbarHelper.showSuccess(
            context,
            TextConstants.profileComplete,
            showTop: true,
          );
          context.pop();
        } else if (state is OwnerError) {
          SnackbarHelper.showError(context, state.message, showTop: true);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: ResponsiveDimensions.paddingSymmetric(
              context,
              horizontal: 24,
            ),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: .center,
                  spacing: ResponsiveDimensions.spacing12(context),
                  children: [
                    // profile picture selection
                    GestureDetector(
                      onTap: pickProfileImage,
                      child: Container(
                        width: ResponsiveDimensions.getSize(context, 88),
                        height: ResponsiveDimensions.getSize(context, 88),

                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          shape: .circle,
                        ),
                        child: profileImage != null
                            ? ClipRRect(
                                borderRadius:
                                    ResponsiveDimensions.borderRadiusLarge(
                                      context,
                                      size: 46,
                                    ),
                                child: Image.file(profileImage!, fit: .cover),
                              )
                            : SvgPicture.asset(
                                ImageConstant.personFilledIcon,
                                fit: .scaleDown,
                              ),
                      ),
                    ),

                    // name input
                    CustomLabelTextField(
                      labelText: "Owner Name",
                      customTextField: CustomTextField(
                        controller: _nameController,
                        hintText: "Enter your name",
                        validator: (value) =>
                            FormValidators.validateFullName(value),
                      ),
                    ),

                    // phone input
                    CustomLabelTextField(
                      labelText: "Phone",
                      customTextField: CustomTextField(
                        controller: _phoneController,
                        hintText: "Enter your number",
                        validator: (value) =>
                            FormValidators.validatePhoneNumber(value),
                      ),
                    ),
                    SizedBox(height: ResponsiveDimensions.spacing12(context)),
                    BlocBuilder<OwnerCubit, OwnerState>(
                      builder: (context, state) {
                        bool isLoading = state is OwnerLoading;
                        return CustomButton(
                          onTap: completeProfile,
                          buttonLabel: 'Complete',
                          isLoading: isLoading,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
