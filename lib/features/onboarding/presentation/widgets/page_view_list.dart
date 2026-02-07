import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/onboarding/domain/entities/onboarding.dart';

class PageViewList extends StatelessWidget {
  /// Custom widget to display page view builder
  const PageViewList({
    super.key,
    this.controller,
    this.onPageChanged,
    required this.pages,
  });

  /// Page content list
  final List<Onboarding> pages;

  /// Page controller
  final PageController? controller;

  /// Page on change function
  final void Function(int value)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: pages.length,
      itemBuilder: (context, index) {
        final content = pages[index];
        return Column(
          mainAxisAlignment: .center,
          children: [
            // overlaped image section
            Image.asset(
              content.imagePath,
              width: ResponsiveDimensions.getSize(context, 231),
              height: ResponsiveDimensions.getHeight(context, 298),
            ),
            SizedBox(height: ResponsiveDimensions.getHeight(context, 28)),
            Padding(
              padding: ResponsiveDimensions.paddingSymmetric(
                context,
                horizontal: 48,
              ),
              child: Column(
                spacing: ResponsiveDimensions.spacing16(context),
                children: [
                  // Info heading section
                  Padding(
                    padding: ResponsiveDimensions.paddingSymmetric(
                      context,
                      horizontal: 1,
                    ),
                    child: RichText(
                      textAlign: .center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headlineLarge,
                        text: content.firstHeading,

                        children: [
                          TextSpan(
                            text: content.boldContent,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          if (content.lastHeading != null)
                            TextSpan(text: content.lastHeading),
                        ],
                      ),
                    ),
                  ),

                  // subtitle info section
                  Text(
                    content.subtitleInfo,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(color: AppColors.textHint),
                    textAlign: .center,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
