import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/extensions/date_extension.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/launcher_helper.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/presentation/bloc/crud/property_crud_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extension.dart';

class MyBookingCard extends StatelessWidget {
  const MyBookingCard({
    super.key,
    required this.property,
    required this.booking,
  });
  final Property property;
  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(
        horizontal: context.responsive(22),
        vertical: context.sp16,
      ),
      width: .infinity,
      color: AppColors.surface,
      child: Column(
        children: [
          Row(
            spacing: context.sp8,
            crossAxisAlignment: .end,
            children: [
              // cover image
              ClipRRect(
                borderRadius: ResponsiveDimensions.borderRadiusSmall(context),
                child: CustomCacheContainer(
                  imageUrl: property.media.coverImage['url'],
                  width: 80,
                  height: 62,
                ),
              ),

              // property details
              Column(
                crossAxisAlignment: .start,
                children: [
                  SizedBox(
                    width: context.responsive(150),
                    child: Text(
                      property.name,
                      style: AppTextStyle.bodySemiBold(context),
                      overflow: .ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        ImageConstant.locationIcon,
                        colorFilter: ColorFilter.mode(
                          AppColors.textHint,
                          .srcIn,
                        ),
                        fit: .scaleDown,
                      ),

                      SizedBox(
                        width: context.responsive(140),
                        child: Text(
                          property.location.address,
                          overflow: .ellipsis,
                          style: AppTextStyle.labelRegular(
                            context,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.sp12),

                  // selected date
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        booking.selectedMonths.isEmpty
                            ? "${booking.startDate!.dayMonthFormat()} - ${booking.endDate!.dayMonthFormat()}"
                            : "${booking.selectedMonths.first.dayMonthFormat()} - ${booking.selectedMonths.last.dayMonthFormat()}",
                        style: AppTextStyle.labelMedium(
                          context,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // status
              _buildStatusContainer(context, booking.bookingStatus),
            ],
          ),
          SizedBox(height: context.sp12),
          Divider(color: AppColors.divider),

          (booking.bookingStatus.name != "pending" &&
                  booking.bookingStatus.name != "accepted")
              ? _buildNavigationOption(context, status: booking.bookingStatus)
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildStatusContainer(BuildContext context, BookingStatus status) {
    switch (status) {
      case .pending:
        return _buildStatusChip(
          context,
          color: AppColors.error,
          label: "Pending",
        );
      case .accepted:
        return _buildStatusChip(
          context,
          color: AppColors.error,
          label: "Waiting",
        );
      case .cancelled:
        return _buildStatusChip(
          context,
          color: AppColors.error,
          label: "Cancelled",
        );

      case .completed:
        return _buildStatusChip(
          context,
          color: AppColors.success,
          label: "Completed",
        );
    }
  }

  Widget _buildStatusChip(
    BuildContext context, {
    required Color color,
    required String label,
  }) {
    return Container(
      padding: .symmetric(horizontal: context.sp8, vertical: 2),
      height: context.sp20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.sp12),
        color: color.withValues(alpha: 0.2),
      ),
      child: Text(
        label,
        style: AppTextStyle.labelRegular(context, color: color),
      ),
    );
  }

  Widget _buildNavigationOption(
    BuildContext context, {
    required BookingStatus status,
  }) {
    return Column(
      spacing: context.sp8,
      children: [
        SizedBox(height: context.sp8),
        status == .completed
            ? GestureDetector(
                onTap: () async {
                  final result = await context.router.push(
                    AddReviewRoute(property: property),
                  );

                  if (result == true && context.mounted) {
                    // Try to refresh property data if a relevant bloc is available
                    context.read<PropertyCrudBloc>().add(
                      RefreshPropertyEvent(property.id!),
                    );
                  }
                },
                child: _buildOptionContent(
                  context,
                  label: "Write review",
                  iconPath: ImageConstant.reviewIcon,
                ),
              )
            : SizedBox.shrink(),
        status == .completed
            ? Divider(color: AppColors.divider)
            : SizedBox.shrink(),
        GestureDetector(
          onTap: () async {
            // Navigation to phone contact
            await LauncherHelper.makePhoneCall(context, property.owner.phone);
          },
          child: _buildOptionContent(
            context,
            label: "Call Agent",
            iconPath: ImageConstant.callIcon,
          ),
        ),
        Divider(color: AppColors.divider),
      ],
    );
  }

  Widget _buildOptionContent(
    BuildContext context, {
    required String label,
    required String iconPath,
  }) {
    return Row(
      spacing: context.sp12,
      children: [
        SvgPicture.asset(iconPath, width: context.sp24, height: context.sp24),
        Text(
          label,
          style: AppTextStyle.bodyRegular(context, color: AppColors.textHint),
        ),
      ],
    );
  }
}
