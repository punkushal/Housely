import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housely/core/constants/image_constant.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/search/presentation/widgets/filter_sheet.dart';

@RoutePage()
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _controller = .new();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void showFitlerSheet() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Explore')),
      body: SafeArea(
        child: Padding(
          padding: ResponsiveDimensions.paddingSymmetric(
            context,
            horizontal: 24,
          ),
          child: Column(
            children: [
              CustomTextField(
                controller: _controller,
                prefixIcon: SvgPicture.asset(
                  ImageConstant.searchIcon,
                  height: ResponsiveDimensions.getHeight(context, 24),
                  width: ResponsiveDimensions.getSize(context, 24),
                  fit: .scaleDown,
                ),
                suffixIcon: GestureDetector(
                  onTap: () => showFitlerSheet(),
                  child: SvgPicture.asset(
                    ImageConstant.filterIcon,
                    height: ResponsiveDimensions.getHeight(context, 24),
                    width: ResponsiveDimensions.getSize(context, 24),
                    fit: .scaleDown,
                  ),
                ),
                hintText: "Search Property",
                contentPadding: ResponsiveDimensions.paddingSymmetric(
                  context,
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
