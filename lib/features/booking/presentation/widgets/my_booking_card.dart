import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/extensions/date_extension.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/booking/domain/entity/booking.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';
import 'package:housely/features/property/domain/entities/property.dart';

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
      padding: ResponsiveDimensions.paddingSymmetric(
        context,
        horizontal: 22,
        vertical: 16,
      ),
      height: ResponsiveDimensions.getSize(context, 104),
      color: AppColors.surface,
      child: Column(
        children: [
          Row(
            spacing: ResponsiveDimensions.spacing8(context),
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
                    width: ResponsiveDimensions.getSize(context, 150),
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
                        width: ResponsiveDimensions.getSize(context, 140),
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
                  SizedBox(height: ResponsiveDimensions.spacing12(context)),

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
          SizedBox(height: ResponsiveDimensions.spacing12(context)),
          Divider(color: AppColors.divider),
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
          color: AppColors.success,
          label: "Accepted",
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
      padding: ResponsiveDimensions.paddingSymmetric(
        context,
        horizontal: 8,
        vertical: 2,
      ),
      height: ResponsiveDimensions.getHeight(context, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withValues(alpha: 0.2),
      ),
      child: Text(
        label,
        style: AppTextStyle.labelRegular(context, color: color),
      ),
    );
  }
}
