import 'dart:developer';
import 'dart:io';
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
import 'package:housely/features/property/presentation/cubit/owner_cubit.dart';
import 'package:housely/features/property/presentation/cubit/property_cubit.dart';
import 'package:housely/features/property/presentation/cubit/property_form_cubit.dart';
import 'package:housely/features/property/presentation/widgets/enum_drop_down.dart';
import 'package:housely/features/property/presentation/widgets/facility_list.dart';
import 'package:housely/features/property/presentation/widgets/label.dart';
import 'package:housely/features/property/presentation/widgets/location_card.dart';
import 'package:housely/features/property/presentation/widgets/upload_container.dart';
import 'package:housely/features/property/presentation/widgets/year_picker_form_field.dart';
import 'package:housely/injection_container.dart';

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
        BlocProvider(create: (context) => sl<PropertyCubit>()),
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
        _titleController.text = widget.property!.name;
        _descController.text = widget.property!.description;
        _yearController.text = widget.property!.specs.builtYear;
        _roomController.text = widget.property!.specs.bedrooms.toString();
        _tubController.text = widget.property!.specs.bathrooms.toString();
        _typeController.text = widget.property!.type.name;
        _statusController.text = widget.property!.status.name.capitalize;
        _priceController.text = widget.property!.price.amount.toString();
        _areaController.text = widget.property!.specs.area.toString();
        location = Location(
          latitude: widget.property!.location.latitude,
          longitude: widget.property!.location.longitude,
          address: widget.property!.location.address,
        );
      }
    });
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

    if (widget.property == null) {
      // Reset the PropertyFormCubit
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
  Future<void> _validateAndProfile(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final formState = context.read<PropertyFormCubit>().state;
      if (formState.image == null) {
        SnackbarHelper.showError(
          context,
          "Please upload cover image",
          showTop: true,
        );
        return;
      }
      if (formState.imageList.isEmpty) {
        SnackbarHelper.showError(
          context,
          TextConstants.uploadManyFileError,
          showTop: true,
        );
        return;
      }

      if (location == null) {
        SnackbarHelper.showError(
          context,
          "Please choose your location",
          showTop: true,
        );
        return;
      }
      final isConnected = context
          .read<ConnectivityCubit>()
          .checkConnectivityForAction();

      if (!isConnected) {
        SnackbarHelper.showError(context, TextConstants.internetError);
        return;
      }

      final state = context.read<OwnerCubit>().state;
      log("owner status: $state");
      if (state is! OwnerLoaded) {
        SnackbarHelper.showError(context, "Please wait, profile is loading..");
        return;
      } else if (state.owner == null) {
        _showCompleteProfileDialog(context);
      } else if (widget.property != null) {
        await updateProperty(context);
        return;
      }
      await addProperty(context, state.owner!);
    }
  }

  // update existed property details
  Future<void> updateProperty(BuildContext context) async {
    final formState = context.read<PropertyFormCubit>().state;
    final File? coverImg = formState.image;
    final List<File> newUpdatedGalleryImages = formState.imageList;
    if (formState.facilities.isEmpty || formState.facilities.length < 2) {
      return SnackbarHelper.showError(
        context,
        "Please select at least one facility",
        showTop: true,
      );
    }
    if (widget.property != null) {
      await context.read<PropertyCubit>().updatePropertyDetails(
        widget.property!.copyWith(
          name: _titleController.text.trim(),
          description: _descController.text.trim(),
          location: PropertyLocation(
            address: location!.address!,
            latitude: location!.latitude,
            longitude: location!.longitude,
          ),
          price: PropertyPrice(
            amount: double.parse(_priceController.text.trim()),
          ),
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
          media: widget.property!.media.copyWith(
            // Pass the filtered list currently held in the FormState
            gallery: {'images': formState.existingNetworkImages},
          ),
          updatedAt: DateTime.now(),
        ),
        coverImage: coverImg,
        galleryImages: newUpdatedGalleryImages,
        // Sending the real database original list for cleanup comparison
        originalGallery: List<Map<String, dynamic>>.from(
          widget.property!.media.gallery['images'],
        ),
      );
    }
  }

  Future<void> addProperty(BuildContext context, PropertyOwner owner) async {
    final formState = context.read<PropertyFormCubit>().state;
    final property = Property(
      id: "",
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
      media: PropertyMedia(coverImage: {}, gallery: {}),
      facilities: formState.facilities,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await context.read<PropertyCubit>().addProperty(
      property: property,
      image: formState.image!,
      images: formState.imageList,
    );
  }

  /// Show Dialog if profile is missing
  void _showCompleteProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Profile Incomplete",
          style: AppTextStyle.headingSemiBold(context),
        ),
        content: Text(
          "You must complete your owner profile before posting a property.",
          style: AppTextStyle.bodyRegular(context),
        ),
        actions: [
          CustomButton(
            onTap: () {
              // close the dialog box
              context.pop();
              context.router.push<bool>(CompleteOwnerProfileRoute());
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
    log("selected year: ${_yearController.text}");
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

        BlocListener<PropertyCubit, PropertyState>(
          listener: (context, state) {
            if (state is PropertyError) {
              SnackbarHelper.showError(context, state.message, showTop: true);
            } else if (state is PropertyCreated) {
              SnackbarHelper.showSuccess(
                context,
                "Successfully created new property",
                showTop: true,
              );
              _resetForm();
              // Trigger a refresh of the list before going back
              context.read<PropertyBloc>().add(GetAllProperties());

              context.pop(true);
            } else if (state is CoverImageUploaded) {
              SnackbarHelper.showSuccess(
                context,
                "Cover image uploaded",
                showTop: true,
              );
            } else if (state is GalleryImagesUploaded) {
              SnackbarHelper.showSuccess(
                context,
                "Gallery images uploaded",
                showTop: true,
              );
            } else if (state is PropertyUpdated) {
              SnackbarHelper.showSuccess(
                context,
                "Property details updated successfully",
                showTop: true,
              );
              _resetForm();
              context.pop(true);
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
                ? "${TextConstants.update} property"
                : '${TextConstants.add} new property',
          ),
        ),
        body: Padding(
          padding: ResponsiveDimensions.paddingSymmetric(
            context,
            horizontal: 24,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
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

                  // upload profile image
                  UploadContainer(
                    labelText: "Property Cover Image",
                    coverUrl: property?.media.coverImage['url'],
                  ),

                  // upload property images
                  UploadContainer(
                    labelText: "Property Images",
                    hasMany: true,
                    property: property,
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
                      location = await context.router.push(
                        MapPickerRoute(
                          isOwner: true,
                          initialLocation: currentLocation,
                        ),
                      );
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
                  Label(label: "Facilites"),
                  FacilityList(existedFacilites: property?.facilities),
                  SizedBox(height: ResponsiveDimensions.getSize(context, 4)),
                  BlocBuilder<PropertyCubit, PropertyState>(
                    builder: (context, state) {
                      bool isLoading = state is PropertyLoading;
                      return CustomButton(
                        onTap: () => property != null
                            ? updateProperty(context)
                            : _validateAndProfile(context),
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
    );
  }
}
