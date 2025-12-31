import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/detail/presentation/widgets/detail_image_card.dart';

class CustomCarouselSlider extends StatefulWidget {
  const CustomCarouselSlider({super.key});

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  final _controller = CarouselSliderController();

  int _currentIndex = 0;

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: .bottomCenter,
      children: [
        ClipRRect(
          borderRadius: ResponsiveDimensions.borderRadiusMedium(context),
          child: CarouselSlider.builder(
            // TODO: later i will implement dynamic content
            carouselController: _controller,
            itemCount: 4,
            itemBuilder: (context, index, realIndex) {
              return DetailImageCard(
                imgPath: ImageConstant.fourthVilla,
                width: ResponsiveDimensions.getSize(context, 327),
                height: ResponsiveDimensions.getHeight(context, 232),
                fit: .cover,
              );
            },
            options: CarouselOptions(
              clipBehavior: .none,
              autoPlay: true,
              aspectRatio: 327 / 232,
              viewportFraction: 1,
              pauseAutoPlayOnTouch: true,
              onPageChanged: (index, reason) {
                onPageChanged(index);
              },
            ),
          ),
        ),

        Row(
          mainAxisAlignment: .center,
          children: List.generate(4, (index) {
            return Container(
              margin: EdgeInsets.all(8),
              width: ResponsiveDimensions.getSize(context, 8),
              height: ResponsiveDimensions.getHeight(context, 8),
              decoration: BoxDecoration(
                shape: .circle,
                color: _currentIndex == index
                    ? AppColors.primaryPressed
                    : AppColors.border,
              ),
            );
          }),
        ),
      ],
    );
  }
}
