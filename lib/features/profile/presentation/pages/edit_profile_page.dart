import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_label_text_field.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/auth/domain/entities/app_user.dart';
import 'package:housely/features/profile/presentation/widgets/profile_section.dart';
import 'package:housely/features/property/presentation/cubit/owner_cubit.dart';

@RoutePage()
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.appUser});
  final AppUser appUser;
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = .new();
  final TextEditingController _emailController = .new();
  final TextEditingController _phoneController = .new();

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.appUser.username;

    _emailController.text = widget.appUser.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: ResponsiveDimensions.paddingSymmetric(
              context,
              horizontal: 22,
            ),
            child: Column(
              spacing: ResponsiveDimensions.spacing12(context),
              children: [
                // change profile picture
                ProfileSection(isEditing: true),

                CustomLabelTextField(
                  labelText: "User Name",
                  customTextField: CustomTextField(controller: _nameController),
                ),

                CustomLabelTextField(
                  labelText: "Email",
                  customTextField: CustomTextField(
                    controller: _emailController,
                  ),
                ),

                BlocBuilder<OwnerCubit, OwnerState>(
                  builder: (context, state) {
                    if (state is OwnerLoaded && state.owner != null) {
                      return CustomLabelTextField(
                        labelText: "Phone Number",
                        customTextField: CustomTextField(
                          controller: _phoneController,
                        ),
                      );
                    }
                    return SizedBox.shrink();
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
