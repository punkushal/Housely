import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/extensions/string_extension.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:housely/features/chat/domain/entity/chat_user.dart';
import 'package:housely/features/detail/presentation/widgets/contact_container.dart';
import 'package:housely/features/detail/presentation/widgets/facility_list.dart';
import 'package:housely/features/detail/presentation/widgets/heading_label.dart';
import 'package:housely/features/detail/presentation/widgets/icon_info_container.dart';
import 'package:housely/features/detail/presentation/widgets/info_container.dart';
import 'package:housely/features/detail/presentation/widgets/read_more_text.dart';
import 'package:housely/features/detail/presentation/widgets/review_list.dart';
import 'package:housely/features/home/presentation/widgets/heading_section.dart';
import 'package:housely/features/location/domain/entities/location.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/presentation/cubit/property_cubit.dart';

class PropertyDetailSection extends StatelessWidget {
  const PropertyDetailSection({
    super.key,
    required this.property,
    this.isOwner = false,
  });
  final Property property;
  final bool isOwner;

  // show dialog box before deleting
  Future<bool> _showConfirmationDailog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete Property?"),
        content: Text(
          "This action cannot be undone, and all related data will be permanently removed.",
          style: AppTextStyle.bodyRegular(context),
        ),

        actions: [
          Row(
            mainAxisAlignment: .center,
            children: [
              TextButton(
                onPressed: () {
                  context.pop(false);
                },
                child: Text(
                  'Cancel',
                  style: AppTextStyle.bodySemiBold(context),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.pop(true);
                },
                child: Text(
                  'Delete',
                  style: AppTextStyle.bodySemiBold(
                    context,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PropertyCubit, PropertyState>(
      listener: (context, state) {
        if (state is PropertyDeleted) {
          context.pop();
          SnackbarHelper.showSuccess(
            context,
            "The property is deleted",
            showTop: true,
          );
        } else if (state is PropertyError) {
          SnackbarHelper.showError(context, state.message);
        }
      },
      child: Column(
        spacing: ResponsiveDimensions.spacing16(context),
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .start,
            children: [
              // property name and location
              Column(
                crossAxisAlignment: .start,
                spacing: ResponsiveDimensions.getHeight(context, 4),
                children: [
                  // property title
                  SizedBox(
                    width: ResponsiveDimensions.getSize(context, 180),
                    child: Text(
                      property.name.capitalize,
                      overflow: .ellipsis,
                      style: AppTextStyle.bodySemiBold(
                        context,
                        fontSize: 20,
                        lineHeight: 26,
                      ),
                    ),
                  ),

                  // location
                  Row(
                    spacing: ResponsiveDimensions.spacing4(context),
                    children: [
                      SvgPicture.asset(
                        ImageConstant.locationIcon,
                        width: ResponsiveDimensions.getSize(context, 24),
                        height: ResponsiveDimensions.getHeight(context, 24),
                        colorFilter: ColorFilter.mode(
                          AppColors.textHint,
                          .srcIn,
                        ),
                      ),

                      SizedBox(
                        width: ResponsiveDimensions.getSize(context, 180),
                        child: Text(
                          property.location.address,
                          overflow: .ellipsis,
                          style: AppTextStyle.bodyRegular(
                            context,
                            fontSize: 14,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // price
              RichText(
                text: TextSpan(
                  text: "Rs${property.price.amount.toStringAsFixed(2)}",
                  style: AppTextStyle.labelBold(
                    context,
                    lineHeight: 18,
                    color: AppColors.primaryPressed,
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(
                      text:
                          property.type.name.toLowerCase() ==
                              PropertyType.house.name.toLowerCase()
                          ? "/month"
                          : "/night",
                      style: AppTextStyle.bodyRegular(
                        context,
                        lineHeight: 14,
                        fontSize: 11,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveDimensions.getHeight(context, 8)),

          HeadingLabel(label: "Property Details"),

          // Property details
          Column(
            crossAxisAlignment: .start,
            spacing: ResponsiveDimensions.getHeight(context, 12),
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  IconInfoContainer(
                    label: "Bedrooms",
                    iconPath: ImageConstant.bedIcon,
                    number: property.specs.bedrooms,
                  ),
                  IconInfoContainer(
                    label: "Bathtub",
                    iconPath: ImageConstant.bathTubIcon,
                    number: property.specs.bathrooms,
                  ),
                  IconInfoContainer(
                    label: "Bedrooms",
                    iconPath: ImageConstant.areaIcon,
                    number: property.specs.area.toInt(),
                    isArea: true,
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: .spaceEvenly,
                children: [
                  InfoContainer(
                    label: "Build",
                    number: int.tryParse(property.specs.builtYear),
                  ),
                  Spacer(),
                  InfoContainer(label: "Parking", number: 1),

                  SizedBox(width: ResponsiveDimensions.getSize(context, 67)),
                  InfoContainer(
                    label: "Status",
                    infoText: property.status.name,
                  ),

                  SizedBox(width: ResponsiveDimensions.getSize(context, 21)),
                ],
              ),
            ],
          ),
          SizedBox(height: ResponsiveDimensions.getHeight(context, 8)),

          // Description section
          HeadingLabel(label: "Description"),
          ReadMoreText(
            text: property.description,
            style: AppTextStyle.bodyRegular(context, color: AppColors.textHint),
          ),

          SizedBox(height: ResponsiveDimensions.getHeight(context, 8)),

          // owner section
          HeadingLabel(label: "Agent"),
          Row(
            spacing: ResponsiveDimensions.spacing16(context),
            children: [
              CircleAvatar(
                radius: ResponsiveDimensions.radiusXLarge(context, size: 22),
                backgroundColor: Colors.grey,
                foregroundImage: NetworkImage(property.media.coverImage['url']),
              ),

              Column(
                crossAxisAlignment: .start,
                children: [
                  // user name
                  Text(
                    property.owner.name.capitalize,
                    style: AppTextStyle.bodySemiBold(context),
                  ),

                  // user role
                  Text(
                    "Owner",
                    style: AppTextStyle.bodyRegular(
                      context,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
              Spacer(),
              // contact section
              isOwner
                  ? SizedBox.shrink()
                  : Row(
                      spacing: ResponsiveDimensions.spacing8(context),
                      children: [
                        ContactContainer(iconPath: ImageConstant.callIcon),
                        ContactContainer(
                          iconPath: ImageConstant.chatIcon,
                          onTap: () {
                            final state =
                                context.read<AuthCubit>().state
                                    as Authenticated;
                            context.router.push(
                              ChatRoute(
                                currentUser: ChatUser(
                                  uid: state.currentUser!.uid,
                                  name: state.currentUser!.username,
                                  email: state.currentUser!.email,
                                ),
                                otherUser: ChatUser(
                                  uid: property.owner.ownerId,
                                  name: property.owner.name,
                                  email:
                                      "currently no email added, later i'll add",
                                  isOwner: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ],
          ),

          SizedBox(height: ResponsiveDimensions.getHeight(context, 8)),

          // location & facility
          HeadingLabel(label: "Location & Public Facilities"),

          FacilityList(facilities: property.facilities),

          // map preview image
          GestureDetector(
            onTap: () => context.router.push(
              MapPickerRoute(
                initialLocation: Location(
                  latitude: property.location.latitude,
                  longitude: property.location.longitude,
                  address: property.location.address,
                ),
                isVisitor: true,
              ),
            ),
            child: ClipRRect(
              borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
              child: Image.asset(
                ImageConstant.mapPreviewImg,
                fit: .cover,
                height: ResponsiveDimensions.getHeight(context, 142),
                width: .infinity,
              ),
            ),
          ),

          // TODO: initially this section will not be displayed untill review exist for this property
          // Review section
          HeadingSection(title: "Reviews", onTapText: "See all"),

          ReviewList(),

          // rent button
          BlocBuilder<PropertyCubit, PropertyState>(
            builder: (context, state) {
              if (isOwner) {
                return CustomButton(
                  onTap: () async {
                    final result = await _showConfirmationDailog(context);
                    if (result && context.mounted) {
                      await context.read<PropertyCubit>().removeProperty(
                        property,
                      );
                    }
                  },
                  buttonLabel: "Delete",
                  textColor: AppColors.error,
                  isOutlined: true,
                  isLoading: state is PropertyLoading,
                );
              }
              return CustomButton(
                onTap: () {
                  context.router.push(BookingRoute(property: property));
                },
                buttonLabel: TextConstants.rent,
              );
            },
          ),
        ],
      ),
    );
  }
}
