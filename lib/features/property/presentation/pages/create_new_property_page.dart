import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/app/app_router.gr.dart';
import 'package:housely/core/constants/app_text_style.dart';
import 'package:housely/core/constants/text_constants.dart';
import 'package:housely/core/extensions/string_extension.dart';
import 'package:housely/core/network/cubit/connectivity_cubit.dart';
import 'package:housely/core/responsive/responsive_dimensions.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/core/validator/form_validator.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/core/widgets/custom_label_text_field.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/location/domain/entities/location.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';
import 'package:housely/features/property/presentation/bloc/property_bloc.dart';
import 'package:housely/features/property/presentation/cubit/owner/owner_cubit.dart';
import 'package:housely/features/property/presentation/cubit/form/property_form_cubit.dart';
import 'package:housely/features/property/presentation/widgets/enum_drop_down.dart';
import 'package:housely/features/property/presentation/widgets/facility_list.dart';
import 'package:housely/features/property/presentation/widgets/label.dart';
import 'package:housely/features/property/presentation/widgets/location_card.dart';
import 'package:housely/features/property/presentation/widgets/upload_container.dart';
import 'package:housely/features/property/presentation/widgets/year_picker_form_field.dart';
import 'package:housely/injection_container.dart';
import '../bloc/crud/property_crud_bloc.dart';

@RoutePage()
class CreateNewPropertyPage extends StatefulWidget implements AutoRouteWrapper {
  const CreateNewPropertyPage({super.key, this.property});
  final Property? property;
  @override
  State<CreateNewPropertyPage> createState() => _CreateNewPropertyPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<PropertyCrudBloc>()),
        BlocProvider(
          create: (context) {
            final cubit = sl<PropertyFormCubit>();

            if (property != null) {
              cubit.setInitialValues(property!);
            }

            return cubit;
          },
        ),
      ],
      child: this,
    );
  }
}

class _CreateNewPropertyPageState extends State<CreateNewPropertyPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _typeController = TextEditingController();
  final _roomController = TextEditingController();
  final _tubController = TextEditingController();
  final _areaController = TextEditingController();
  final _statusController = TextEditingController();
  final _yearController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Location? location;
  PropertyType? selectedType;
  PropertyStatus? selectedStatus;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.property != null) {
        // Load property images into property crud bloc for editing
        context.read<PropertyCrudBloc>().add(
          LoadPropertyForEdit(widget.property!),
        );
        _populateFormFields(widget.property!);
      }
    });
  }

  /// Populates all form fields with existing property data (for edit mode)
  void _populateFormFields(Property property) {
    _titleController.text = property.name;
    _descController.text = property.description;
    _yearController.text = property.specs.builtYear;
    _roomController.text = property.specs.bedrooms.toString();
    _tubController.text = property.specs.bathrooms.toString();
    _typeController.text = property.type.name;
    _statusController.text = property.status.name.capitalize;
    _priceController.text = property.price.amount.toString();
    _areaController.text = property.specs.area.toString();

    location = Location(
      latitude: property.location.latitude,
      longitude: property.location.longitude,
      address: property.location.address,
    );
  }

  void _resetForm() {
    // Clear all text controllers
    _titleController.clear();
    _descController.clear();
    _priceController.clear();
    _typeController.clear();
    _roomController.clear();
    _tubController.clear();
    _areaController.clear();
    _statusController.clear();
    _yearController.clear();

    // Clear location
    location = null;

    // Reset the form key
    _formKey.currentState?.reset();

    // Reset the PropertyFormCubit only if creating new (not editing)
    if (widget.property == null) {
      context.read<PropertyFormCubit>().resetForm();
      context.read<PropertyFormCubit>().resetForm();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _tubController.dispose();
    _roomController.dispose();
    _areaController.dispose();
    _statusController.dispose();
    _typeController.dispose();
    _priceController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  // validation and profile check
  Future<void> _validateAndSubmit(BuildContext context) async {
    // Validate form fields
    if (!_formKey.currentState!.validate()) return;

    final crudState = context.read<PropertyCrudBloc>().state;

    // Check if cover image is provided
    if (crudState.localCoverImage == null &&
        crudState.networkCoverImageUrl == null) {
      SnackbarHelper.showError(context, "Please upload cover image");
      return;
    }

    // Check if gallery images are provided
    if (crudState.localGalleryImages.isEmpty &&
        crudState.networkGalleryImageUrls.isEmpty) {
      SnackbarHelper.showError(
        context,
        TextConstants.uploadManyFileError,
        showTop: true,
      );
      return;
    }

    // Check if location is selected
    if (location == null) {
      SnackbarHelper.showError(
        context,
        "Please choose your location",
        showTop: true,
      );
      return;
    }

    // Check internet connectivity
    final isConnected = context
        .read<ConnectivityCubit>()
        .checkConnectivityForAction();

    if (!isConnected) {
      SnackbarHelper.showError(context, TextConstants.internetError);
      return;
    }

    // Check if owner profile is loaded
    final ownerState = context.read<OwnerCubit>().state;
    if (ownerState is! OwnerLoaded) {
      SnackbarHelper.showError(context, "Please wait, profile is loading..");
      return;
    } else if (ownerState.owner == null) {
      _showCompleteProfileDialog(context);
      return;
    }

    // Decide whether to create or update
    if (widget.property != null) {
      await _updateProperty();
    } else {
      await _createProperty(ownerState.owner!);
    }
  }

  // update existed property details
  Future<void> _updateProperty() async {
    final formState = context.read<PropertyFormCubit>().state;

    final updatedProperty = widget.property!.copyWith(
      name: _titleController.text.trim(),
      description: _descController.text.trim(),
      location: PropertyLocation(
        address: location!.address!,
        latitude: location!.latitude,
        longitude: location!.longitude,
      ),
      price: PropertyPrice(amount: double.parse(_priceController.text.trim())),
      status: PropertyStatus.values.byName(
        _statusController.text.trim().toLowerCase(),
      ),
      type: PropertyType.values.byName(
        _typeController.text.trim().toLowerCase(),
      ),
      specs: PropertySpecs(
        area: double.parse(_areaController.text.trim()),
        builtYear: _yearController.text.trim(),
        bedrooms: int.parse(_roomController.text.trim()),
        bathrooms: int.parse(_tubController.text.trim()),
      ),
      facilities: formState.facilities,
      updatedAt: DateTime.now(),
    );
    context.read<PropertyCrudBloc>().add(UpdatePropertyEvent(updatedProperty));
  }

  Future<void> _createProperty(PropertyOwner owner) async {
    final formState = context.read<PropertyFormCubit>().state;

    // Build property object without image urls (bloc will handle upload)
    final property = Property(
      name: _titleController.text.trim(),
      description: _descController.text.trim(),
      owner: owner,
      location: PropertyLocation(
        address: location!.address!,
        latitude: location!.latitude,
        longitude: location!.longitude,
      ),
      price: PropertyPrice(amount: double.parse(_priceController.text.trim())),
      status: PropertyStatus.values.byName(
        _statusController.text.trim().toLowerCase(),
      ),
      type: PropertyType.values.byName(
        _typeController.text.trim().toLowerCase(),
      ),
      specs: PropertySpecs(
        area: double.parse(_areaController.text.trim()),
        builtYear: _yearController.text.trim(),
        bedrooms: int.parse(_roomController.text.trim()),
        bathrooms: int.parse(_tubController.text.trim()),
      ),
      // Media will be populate by the bloc after upload
      media: PropertyMedia(coverImage: {}, gallery: {}),
      facilities: formState.facilities,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rating: PropertyRating(),
    );

    context.read<PropertyCrudBloc>().add(CreatePropertyEvent(property));
  }

  /// Show Dialog if profile is missing
  void _showCompleteProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Complete Your Profile",
          style: AppTextStyle.headingSemiBold(ctx),
        ),
        content: Text(
          "Please complete your owner profile before adding a property.",
          style: AppTextStyle.bodyRegular(ctx),
        ),
        actions: [
          CustomButton(
            onTap: () {
              // close the dialog box
              ctx.pop();
              ctx.router.push(CompleteOwnerProfileRoute());
            },
            buttonLabel: "Go to Profile",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;
    return MultiBlocListener(
      listeners: [
        BlocListener<ConnectivityCubit, ConnectivityState>(
          listener: (context, state) {
            if (state is ConnectivityDisconnected) {
              SnackbarHelper.showError(
                context,
                TextConstants.internetError,
                showTop: true,
              );
            }
          },
        ),

        BlocListener<PropertyCrudBloc, PropertyCrudState>(
          listener: (context, state) {
            // Handle loading state - show loading dialog
            if (state.status == .loading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) =>
                    const Center(child: CircularProgressIndicator()),
              );
            }
            // Handle error state - close loading dialog and show error
            else if (state.status == .error) {
              context.pop();
              SnackbarHelper.showError(
                context,
                state.errorMessage ?? 'An error occurred',
              );
            }
            // Handle success state - close loading dialog, show success message, and navigate
            else if (state.status == .success) {
              context.pop();

              // refresh the property list afte successful operation
              // later i don't need this bcuz in detail page i will fetch individual property data using property id
              context.read<PropertyBloc>().add(GetAllProperties());

              // Show success messsage based on operation type

              final message = state.lastOperation == PropertyOperation.create
                  ? 'Property created successfully'
                  : 'Property updated successfully';

              SnackbarHelper.showSuccess(context, message);

              // Reset form and navigate back
              _resetForm();
              context.pop();
            }
          },
        ),

        BlocListener<OwnerCubit, OwnerState>(
          listener: (context, state) {
            if (state is OwnerLoaded) {
              if (state.owner == null) {
                _showCompleteProfileDialog(context);
              }
            } else if (state is OwnerError) {
              SnackbarHelper.showError(context, state.message, showTop: true);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            property != null
                ? TextConstants.editProperty
                : TextConstants.addProperty,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: ResponsiveDimensions.paddingSymmetric(
                context,
                horizontal: 24,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: ResponsiveDimensions.getSize(context, 12),
                  children: [
                    // title input
                    CustomLabelTextField(
                      labelText: "Title",
                      customTextField: CustomTextField(
                        controller: _titleController,
                        hintText: "Property Title",
                        validator: (value) => FormValidators.title(value),
                      ),
                    ),

                    // description input
                    CustomLabelTextField(
                      labelText: "Description",
                      customTextField: CustomTextField(
                        controller: _descController,
                        hintText: "Property Description",
                        maxLines: 4,
                        validator: (value) => FormValidators.description(value),
                      ),
                    ),

                    // price input
                    CustomLabelTextField(
                      labelText: "Price",
                      customTextField: CustomTextField(
                        controller: _priceController,
                        hintText: "Price",
                        keyboardType: .number,
                        validator: (value) => FormValidators.price(value),
                      ),
                    ),

                    // property type
                    BlocSelector<PropertyFormCubit, PropertyFormState, String?>(
                      selector: (state) {
                        return state.propertyType;
                      },
                      builder: (context, typeName) {
                        return CustomLabelTextField(
                          labelText: "Property Type",
                          customTextField: EnumDropdown(
                            value: typeName != null
                                ? PropertyType.values.byName(typeName)
                                : null,
                            items: PropertyType.values,
                            onChanged: (value) {
                              if (value != null) {
                                context
                                    .read<PropertyFormCubit>()
                                    .changePropertyType(value.name);
                                _typeController.text = value.name.capitalize;
                              }
                            },
                            hintText: "Select your property type",
                            validator: (value) {
                              if (value == null) {
                                return "Please select your property type";
                              }
                              return null;
                            },
                          ),
                        );
                      },
                    ),

                    // bedrooms input
                    CustomLabelTextField(
                      labelText: "Bedrooms",
                      customTextField: CustomTextField(
                        controller: _roomController,
                        hintText: "Number of Bedrooms",
                        keyboardType: .number,
                        validator: (value) =>
                            FormValidators.rooms(value, label: "Bedrooms"),
                      ),
                    ),

                    // bathtubs input
                    CustomLabelTextField(
                      labelText: "Bathtubs",
                      customTextField: CustomTextField(
                        controller: _tubController,
                        hintText: "Number of Bathtubs",
                        keyboardType: .number,
                        validator: (value) =>
                            FormValidators.rooms(value, label: "Bathtubs"),
                      ),
                    ),

                    // area input
                    CustomLabelTextField(
                      labelText: "Area (sq ft)",
                      customTextField: CustomTextField(
                        controller: _areaController,
                        hintText: "Area in square feet",
                        keyboardType: .number,
                        validator: (value) => FormValidators.area(value),
                      ),
                    ),

                    // build year input
                    BlocSelector<PropertyFormCubit, PropertyFormState, String?>(
                      selector: (state) {
                        return state.year;
                      },
                      builder: (context, year) {
                        // converting String? from Cubit to int? for the form field
                        final int? yearInt = year != null
                            ? int.tryParse(year)
                            : null;
                        return CustomLabelTextField(
                          labelText: "Build Year",
                          customTextField: YearPickerFormField(
                            context: context,
                            initialValue: yearInt,
                            hintText: "Select Year",
                            validator: (value) {
                              if (value == null) {
                                return "Please select built in year";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              context.read<PropertyFormCubit>().setBuiltInYear(
                                value.toString(),
                              );
                              _yearController.text = value.toString();
                            },
                          ),
                        );
                      },
                    ),

                    // upload cover image
                    BlocBuilder<PropertyCrudBloc, PropertyCrudState>(
                      buildWhen: (previous, current) =>
                          previous.localCoverImage != current.localCoverImage ||
                          previous.networkCoverImageUrl !=
                              current.networkCoverImageUrl,
                      builder: (context, state) {
                        return UploadContainer(
                          labelText: "Property Cover Image",
                          singleImage: state.localCoverImage,
                          coverUrl: state.networkCoverImageUrl,
                          imageList: const [],
                          networkImages: const [],
                          onImageSelected: (file) {
                            context.read<PropertyCrudBloc>().add(
                              PickCoverImage(file),
                            );
                          },
                        );
                      },
                    ),

                    // upload gallery images
                    BlocBuilder<PropertyCrudBloc, PropertyCrudState>(
                      buildWhen: (prev, curr) =>
                          prev.localGalleryImages != curr.localGalleryImages ||
                          prev.networkGalleryImageUrls !=
                              curr.networkGalleryImageUrls,
                      builder: (context, state) {
                        return UploadContainer(
                          labelText: "Property Images",
                          hasMany: true,
                          imageList: state.localGalleryImages,
                          networkImages: state.networkGalleryImageUrls,
                          onImagesSelected: (files) => context
                              .read<PropertyCrudBloc>()
                              .add(PickGalleryImages(files)),
                          onRemoveLocal: (index) => context
                              .read<PropertyCrudBloc>()
                              .add(RemoveLocalGalleryImage(index)),
                          onRemoveNetwork: (index) => context
                              .read<PropertyCrudBloc>()
                              .add(RemoveNetworkGalleryImage(index)),
                        );
                      },
                    ),

                    // location
                    LocationCard(
                      address: property?.location.address,
                      navigateTo: () async {
                        final currentLocation =
                            location ??
                            (property != null
                                ? Location(
                                    latitude: property.location.latitude,
                                    longitude: property.location.longitude,
                                    address: property.location.address,
                                  )
                                : null);
                        final pickedLocation = await context.router.push(
                          MapPickerRoute(
                            isOwner: true,
                            initialLocation: currentLocation,
                          ),
                        );

                        if (pickedLocation != null) {
                          location = pickedLocation as Location;
                        }
                        // update form cubit with new address
                        if (context.mounted && location != null) {
                          context.read<PropertyFormCubit>().setAddress(
                            location!.address!,
                          );
                        }
                      },
                    ),

                    // property status
                    BlocSelector<PropertyFormCubit, PropertyFormState, String?>(
                      selector: (state) {
                        return state.propertyStatus;
                      },
                      builder: (context, status) {
                        return CustomLabelTextField(
                          labelText: "Property Status",
                          customTextField: EnumDropdown(
                            value: status != null
                                ? PropertyStatus.values.byName(status)
                                : null,
                            items: PropertyStatus.values,
                            onChanged: (value) {
                              if (value != null) {
                                context
                                    .read<PropertyFormCubit>()
                                    .changePropertyStatus(value.name);
                                _statusController.text = value.name.capitalize;
                              }
                            },
                            hintText: "Select your property status",
                            validator: (value) {
                              if (value == null) {
                                return "Please select property status";
                              }
                              return null;
                            },
                          ),
                        );
                      },
                    ),

                    // facility section
                    const Label(label: "Facilites"),
                    FacilityList(existedFacilites: property?.facilities),

                    SizedBox(height: ResponsiveDimensions.getSize(context, 4)),

                    BlocBuilder<PropertyCrudBloc, PropertyCrudState>(
                      builder: (context, state) {
                        final isLoading = state.status == .loading;
                        return CustomButton(
                          onTap: () => _validateAndSubmit(context),
                          buttonLabel: property != null
                              ? "Update Property"
                              : TextConstants.addProperty,
                          isLoading: isLoading,
                        );
                      },
                    ),

                    SizedBox(height: ResponsiveDimensions.getSize(context, 6)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
