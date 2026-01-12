import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/heading_label.dart';
import 'package:housely/features/search/presentation/cubit/search_filter_cubit.dart';

class PriceRangeSlider extends StatelessWidget {
  const PriceRangeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: ResponsiveDimensions.spacing8(context),
      children: [
        HeadingLabel(label: "Price Range"),
        SizedBox(height: ResponsiveDimensions.spacing8(context)),
        BlocBuilder<SearchFilterCubit, SearchFilterState>(
          builder: (context, state) {
            return Column(
              children: [
                RangeSlider(
                  values: state.priceRange,
                  min: 10,
                  max: 1000,
                  inactiveColor: AppColors.divider,
                  divisions: 100,
                  onChanged: (value) {
                    context.read<SearchFilterCubit>().updatePriceRange(value);
                  },
                  padding: .zero,
                ),

                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      "\$${state.priceRange.start.round()}",
                      style: AppTextStyle.bodySemiBold(
                        context,
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                    Text(
                      "\$${state.priceRange.end.round()}",
                      style: AppTextStyle.bodySemiBold(
                        context,
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
