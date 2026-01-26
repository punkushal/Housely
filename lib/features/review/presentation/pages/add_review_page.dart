import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/property/presentation/cubit/property_form_cubit.dart';
import 'package:housely/features/property/presentation/widgets/upload_container.dart';
import 'package:housely/features/review/presentation/widgets/write_review_container.dart';

class AddReviewPage extends StatefulWidget {
  const AddReviewPage({super.key});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PropertyFormCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text('Write a review')),
            body: Padding(
              padding: ResponsiveDimensions.paddingSymmetric(
                context,
                horizontal: 22,
              ),
              child: SingleChildScrollView(
                child: Column(
                  spacing: ResponsiveDimensions.spacing16(context),
                  children: [
                    UploadContainer(labelText: "Add Photo", hasMany: true),
                    WriteReviewContainer(),
                    SizedBox(height: ResponsiveDimensions.spacing32(context)),
                    CustomButton(
                      onTap: () {},
                      buttonLabel: TextConstants.submit,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
