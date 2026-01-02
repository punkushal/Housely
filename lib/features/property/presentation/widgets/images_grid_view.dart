import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/property/presentation/cubit/property_form_cubit.dart';

class ImagesGridView extends StatelessWidget {
  const ImagesGridView({super.key, required this.multipleImages});
  final List<File> multipleImages;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: multipleImages.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Image.file(
              multipleImages[index],
              fit: .cover,
              width: ResponsiveDimensions.getSize(context, 98),
              height: ResponsiveDimensions.getSize(context, 68),
            ),

            Positioned(
              right: ResponsiveDimensions.spacing8(context),
              top: ResponsiveDimensions.spacing4(context),
              child: GestureDetector(
                onTap: () {
                  context.read<PropertyFormCubit>().removeImage(index);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: .circle,
                  ),
                  child: Icon(Icons.close, color: AppColors.surface, size: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
