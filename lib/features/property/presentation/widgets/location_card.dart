import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/property/presentation/cubit/property_form_cubit.dart';
import 'package:housely/features/property/presentation/widgets/label.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({super.key, this.address, this.navigateTo});
  final String? address;

  /// navigate to map picker
  final void Function()? navigateTo;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: ResponsiveDimensions.spacing4(context),
      crossAxisAlignment: .start,
      children: [
        Label(label: "Location"),
        GestureDetector(
          onTap: navigateTo,
          child: address != null
              ? BlocSelector<PropertyFormCubit, PropertyFormState, String?>(
                  selector: (state) => state.address,
                  builder: (context, state) {
                    return state != null
                        ? CustomTextField(initialValue: state)
                        : CustomTextField(initialValue: address);
                  },
                )
              : ClipRRect(
                  borderRadius: ResponsiveDimensions.borderRadiusMedium(
                    context,
                  ),
                  child: Image.asset(
                    ImageConstant.mapPreviewImg,
                    fit: .cover,
                    height: ResponsiveDimensions.getHeight(context, 142),
                    width: .infinity,
                  ),
                ),
        ),
      ],
    );
  }
}
