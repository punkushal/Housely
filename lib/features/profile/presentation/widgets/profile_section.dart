import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, this.isEditing = false});
  final bool isEditing;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final authState = state as Authenticated;
        return Column(
          children: [
            Stack(
              children: [
                // profile image
                CircleAvatar(
                  radius: ResponsiveDimensions.getSize(context, 60),
                  backgroundColor: AppColors.divider,
                  child: SvgPicture.asset(
                    //TODO: add profile url if available
                    ImageConstant.personIcon,
                    width: ResponsiveDimensions.getSize(context, 30),
                    height: ResponsiveDimensions.getSize(context, 30),
                  ),
                ),

                isEditing
                    ? Positioned(
                        bottom: 0,
                        right: ResponsiveDimensions.getSize(context, 12),
                        child: GestureDetector(
                          onTap: () {
                            // open camera
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
            Text(
              authState.currentUser!.username,
              style: AppTextStyle.bodySemiBold(context),
            ),
            Text(
              authState.currentUser!.email,
              style: AppTextStyle.bodyRegular(
                context,
                color: AppColors.textHint,
              ),
            ),
          ],
        );
      },
    );
  }
}
