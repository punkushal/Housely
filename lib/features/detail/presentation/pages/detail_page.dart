import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:housely/features/detail/presentation/widgets/custom_carousel_slider.dart';
import 'package:housely/features/detail/presentation/widgets/image_list.dart';
import 'package:housely/features/detail/presentation/widgets/property_detail_section.dart';
import 'package:housely/features/favorites/presentation/widgets/favorite_toggle_button.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/property/presentation/bloc/crud/property_crud_bloc.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.property});

  /// actual property data
  final Property property;
  @override
  Widget build(BuildContext context) {
    final urls = (property.media.gallery['images'] as List)
        .where((element) => element.containsKey("url"))
        .map((item) => item['url'] as String)
        .toList();
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => sl<PropertyCrudBloc>())],

      child: Builder(
        builder: (context) {
          final authState = context.read<AuthCubit>().state;
          final user = authState as Authenticated;
          final isOwner = user.currentUser!.uid == property.owner.ownerId;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text('Details'),
              actionsPadding: ResponsiveDimensions.paddingOnly(
                context,
                right: 18,
              ),
              actions: [
                isOwner
                    ? IconButton(
                        onPressed: () {
                          context.router.push(
                            CreateNewPropertyRoute(property: property),
                          );
                        },
                        icon: Container(
                          padding: ResponsiveDimensions.paddingAll8(context),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.edit_rounded,
                            color: AppColors.background,
                            size: ResponsiveDimensions.spacing20(context),
                          ),
                        ),
                      )
                    :
                      // favorite icon button
                      FavoriteToggleButton(property: property),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: ResponsiveDimensions.paddingSymmetric(
                  context,
                  horizontal: 24,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: ResponsiveDimensions.getHeight(context, 12),
                    children: [
                      // property image carousel
                      CustomCarouselSlider(
                        imageUrls: [property.media.coverImage['url'], ...urls],
                      ),

                      // images list
                      ImageList(imageUrls: urls),

                      SizedBox(
                        height: ResponsiveDimensions.getHeight(context, 12),
                      ),

                      // Detail section
                      PropertyDetailSection(
                        property: property,
                        isOwner: isOwner,
                      ),

                      SizedBox(
                        height: ResponsiveDimensions.getHeight(context, 6),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
