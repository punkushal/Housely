import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_colors.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:housely/features/detail/presentation/widgets/custom_carousel_slider.dart';
import 'package:housely/features/detail/presentation/widgets/image_list.dart';
import 'package:housely/features/detail/presentation/widgets/property_detail_section.dart';
import 'package:housely/features/favorites/presentation/widgets/favorite_toggle_button.dart';
import 'package:housely/features/property/presentation/bloc/crud/property_crud_bloc.dart';

@RoutePage()
class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.propertyId});

  final String propertyId;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PropertyCrudBloc>().add(
        LoadNetworkPropertyEvent(widget.propertyId),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PropertyCrudBloc, PropertyCrudState>(
        builder: (context, state) {
          // Handle loaidng state
          if (state.status == .loading && state.netWorkProperty == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (state.status == .error) {
            return _buildErrorState(context, state.errorMessage);
          }

          // Handle no data state
          final property = state.netWorkProperty;
          if (property == null) {
            return const Center(child: Text('Property not found'));
          }

          // Extract gallery URLs for display
          final urls = (property.media.gallery['images'] as List)
              .where((element) => element.containsKey("url"))
              .map((item) => item['url'] as String)
              .toList();

          // Check if current user is the owner
          final authState = context.read<AuthCubit>().state;
          final user = authState as Authenticated;
          final isOwner = user.currentUser!.uid == property.owner.ownerId;
          return CustomScrollView(
            slivers: [
              // AppBar as sliver for better scroll behavior
              SliverAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    final currentProperty = context
                        .read<PropertyCrudBloc>()
                        .state
                        .netWorkProperty;
                    // Navigate back and return the result directly
                    context.router.maybePop(currentProperty);
                  },
                ),
                backgroundColor: Colors.transparent,
                title: const Text('Details'),
                floating: true,
                pinned: false,
                actionsPadding: ResponsiveDimensions.paddingOnly(
                  context,
                  right: 18,
                ),
                actions: [
                  isOwner
                      ? IconButton(
                          onPressed: () async {
                            // Navigate to edit page and wait for result
                            final result = await context.router.push(
                              CreateNewPropertyRoute(property: property),
                            );

                            // If edit was successful, refresh the property data
                            if (result == true && context.mounted) {
                              context.read<PropertyCrudBloc>().add(
                                LoadNetworkPropertyEvent(widget.propertyId),
                              );
                            }
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
                      : FavoriteToggleButton(property: property),
                ],
              ),

              // Content
              SliverPadding(
                padding: ResponsiveDimensions.paddingSymmetric(
                  context,
                  horizontal: 24,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Property image carousel
                    CustomCarouselSlider(
                      imageUrls: [property.media.coverImage['url'], ...urls],
                    ),

                    SizedBox(
                      height: ResponsiveDimensions.getHeight(context, 12),
                    ),

                    // Images list
                    ImageList(imageUrls: urls),

                    SizedBox(
                      height: ResponsiveDimensions.getHeight(context, 12),
                    ),

                    // Detail section
                    PropertyDetailSection(property: property, isOwner: isOwner),

                    SizedBox(
                      height: ResponsiveDimensions.getHeight(context, 6),
                    ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message ?? 'Failed to load property'),
          const SizedBox(height: 16),
          CustomButton(
            onTap: () {
              // Retry loading
              context.read<PropertyCrudBloc>().add(
                LoadNetworkPropertyEvent(widget.propertyId),
              );
            },
            buttonLabel: 'Retry',
          ),
        ],
      ),
    );
  }
}
