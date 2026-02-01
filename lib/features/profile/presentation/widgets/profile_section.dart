import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';
import 'package:housely/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSection extends StatelessWidget {
  ProfileSection({super.key, this.isEditing = false});
  final bool isEditing;

  final imagePicker = ImagePicker();
  Future<void> pickProfileImage(
    BuildContext context, {
    required ImageSource source,
  }) async {
    final picked = await imagePicker.pickImage(source: source);

    if (picked != null && context.mounted) {
      context.read<ProfileCubit>().setProfileImage(File(picked.path));
    }
  }

  Widget _buildImageOption({
    required String label,
    required IconData icon,
    required void Function()? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: .zero,
      leading: Icon(icon, color: AppColors.primaryPressed),
      title: Text(label),
    );
  }

  void _showOptionsForProfileImage(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    showDialog(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: profileCubit,
        child: AlertDialog(
          title: Text("Choose image"),
          content: Column(
            spacing: ResponsiveDimensions.spacing4(ctx),
            mainAxisSize: .min,
            children: [
              _buildImageOption(
                label: "Camera",
                icon: Icons.camera_alt_rounded,
                onTap: () {
                  ctx.pop();
                  pickProfileImage(ctx, source: .camera);
                },
              ),
              _buildImageOption(
                label: "Gallery",
                icon: Icons.image,
                onTap: () {
                  ctx.pop();
                  pickProfileImage(context, source: .gallery);
                },
              ),
            ],
          ),
          actions: [
            CustomButton(
              onTap: () {
                context.pop();
              },
              buttonLabel: "Cancel",
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            // profile image
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                final hasLocalImage = state.pickedProfileImage != null;
                final hasNetWorkImage = state.profileImageUrl != null;

                return Container(
                  width: ResponsiveDimensions.getSize(context, 80),
                  height: ResponsiveDimensions.getSize(context, 80),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    shape: .circle,
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      ResponsiveDimensions.getSize(context, 80),
                    ),
                    child: hasNetWorkImage
                        ? CustomCacheContainer(
                            imageUrl: state.profileImageUrl!['url'],
                            width: .infinity,
                            height: .infinity,
                          )
                        : hasLocalImage
                        ? Image.file(state.pickedProfileImage!)
                        : SvgPicture.asset(
                            ImageConstant.personIcon,
                            width: ResponsiveDimensions.getSize(context, 16),
                            height: ResponsiveDimensions.getSize(context, 16),
                            fit: .scaleDown,
                          ),
                  ),
                );
              },
            ),

            isEditing
                ? Positioned(
                    bottom: 0,
                    right: ResponsiveDimensions.getSize(context, 6),
                    child: GestureDetector(
                      onTap: () {
                        _showOptionsForProfileImage(context);
                      },
                      child: CircleAvatar(
                        radius: ResponsiveDimensions.spacing12(context),
                        child: SvgPicture.asset(ImageConstant.cameraIcon),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        SizedBox(height: ResponsiveDimensions.spacing16(context)),
        if (!isEditing)
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final user = state.appUser;
              if (user != null) {
                return Column(
                  children: [
                    Text(
                      user.username,
                      style: AppTextStyle.bodySemiBold(context),
                    ),
                    Text(
                      user.email,
                      style: AppTextStyle.bodyRegular(
                        context,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                );
              }
              return Text('No user data');
            },
          ),
      ],
    );
  }
}
