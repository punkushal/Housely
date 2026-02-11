import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/extensions/date_extension.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/booking/domain/entity/booking_detail.dart';
import 'package:housely/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:housely/features/booking/presentation/widgets/price_details.dart';
import 'package:housely/features/detail/presentation/widgets/custom_cache_container.dart';

import '../../../../core/extensions/context_extension.dart';

class BookingRequestCard extends StatelessWidget {
  const BookingRequestCard(this.bookingDetail, {super.key});
  final BookingDetail bookingDetail;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: .symmetric(horizontal: context.sp24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.sp8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(context.sp8),
              topRight: Radius.circular(context.sp8),
            ),
            child: CustomCacheContainer(
              imageUrl: bookingDetail.property.media.coverImage['url'],
              width: .infinity,
              height: 180,
            ),
          ),

          Padding(
            padding: .symmetric(
              horizontal: context.sp16,
              vertical: context.sp8,
            ),
            child: Column(
              crossAxisAlignment: .start,
              spacing: context.sp12,
              children: [
                Text(
                  bookingDetail.property.name,
                  style: AppTextStyle.headingSemiBold(
                    context,
                    fontSize: 18,
                    lineHeight: 28,
                  ),
                ),

                Row(
                  mainAxisSize: .min,
                  spacing: context.sp8,
                  children: [
                    SvgPicture.asset(
                      ImageConstant.calenderIcon,
                      fit: .scaleDown,
                      height: context.sp40,
                      width: context.sp40,
                    ),

                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          'Dates',
                          style: AppTextStyle.bodyRegular(
                            context,
                            color: AppColors.textHint,
                          ),
                        ),
                        Text(
                          bookingDetail.booking.selectedMonths.isEmpty
                              ? "${bookingDetail.booking.startDate!.dayMonthFormat()} - ${bookingDetail.booking.endDate!.dayMonthFormat()}"
                              : "${bookingDetail.booking.selectedMonths.first.dayMonthFormat()} - ${bookingDetail.booking.selectedMonths.last.dayMonthFormat()}",
                          style: AppTextStyle.bodyMedium(context, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: context.sp4),
                PriceDetails(
                  price: bookingDetail.property.price.amount,
                  propertyType: bookingDetail.property.type.name,
                ),

                // buttons
                Row(
                  spacing: context.sp8,
                  children: [
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          context.read<BookingBloc>().add(
                            ResponseBookingRequestEvent(
                              status: .cancelled,
                              bookingId: bookingDetail.booking.bookingId,
                            ),
                          );
                        },
                        buttonLabel: "Decline",
                        isOutlined: true,
                        textColor: AppColors.border,
                      ),
                    ),

                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          context.read<BookingBloc>().add(
                            ResponseBookingRequestEvent(
                              status: .accepted,
                              bookingId: bookingDetail.booking.bookingId,
                            ),
                          );
                        },
                        buttonLabel: "Accept",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
