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
import 'package:housely/core/utils/file_utils.dart';
import 'package:housely/core/utils/snack_bar_helper.dart';
import 'package:housely/core/validator/form_validator.dart';
import 'package:housely/core/widgets/custom_button.dart';
import 'package:housely/core/widgets/custom_label_text_field.dart';
import 'package:housely/core/widgets/custom_text_field.dart';
import 'package:housely/features/property/domain/entities/property.dart';
import 'package:housely/features/location/domain/entities/location.dart';
import 'package:housely/features/property/domain/entities/property_owner.dart';
import 'package:housely/features/property/presentation/cubit/owner_cubit.dart';
import 'package:housely/features/property/presentation/cubit/property_cubit.dart';
import 'package:housely/features/property/presentation/cubit/property_form_cubit.dart';
import 'package:housely/features/property/presentation/widgets/facility_list.dart';
import 'package:housely/features/property/presentation/widgets/label.dart';
import 'package:housely/features/property/presentation/widgets/location_card.dart';
import 'package:housely/features/property/presentation/widgets/upload_container.dart';
import 'package:housely/injection_container.dart';

@RoutePage()
class CreateNewPropertyPage extends StatefulWidget {
  const CreateNewPropertyPage({super.key});

  @override
  State<CreateNewPropertyPage> createState() => _CreateNewPropertyPageState();
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
  void _validateAndProfile(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final formState = context.read<PropertyFormCubit>().state;
      if (formState.image == null) {
        SnackbarHelper.showError(context, "Please upload cover image");
      }
      if (formState.imageList.isEmpty) {
        SnackbarHelper.showError(context, TextConstants.uploadManyFileError);
      }

      if (location == null) {
        SnackbarHelper.showError(context, "Please choose your location");
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
      }
      addProperty(context, state.owner!);
    }
  }

  void addProperty(BuildContext context, PropertyOwner owner) {
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

    context.read<PropertyCubit>().addProperty(
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PropertyFormCubit()),
        BlocProvider(create: (context) => sl<PropertyCubit>()),
      ],
      child: Builder(
        builder: (context) {
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
                    SnackbarHelper.showError(
                      context,
                      state.message,
                      showTop: true,
                    );
                  } else if (state is PropertyCreated) {
                    SnackbarHelper.showSuccess(
                      context,
                      "Successfully created new property",
                      showTop: true,
                    );
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
                    SnackbarHelper.showError(
                      context,
                      state.message,
                      showTop: true,
                    );
                  }
                },
              ),
            ],
            child: Scaffold(
              appBar: AppBar(title: Text('Add new property')),
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
                            validator: (value) =>
                                FormValidators.description(value),
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
                        BlocSelector<
                          PropertyFormCubit,
                          PropertyFormState,
                          String?
                        >(
                          selector: (state) {
                            return state.propertyType;
                          },
                          builder: (context, state) {
                            return CustomLabelTextField(
                              labelText: "Property Type",
                              customTextField: CustomTextField(
                                readOnly: true,
                                controller: _typeController,
                                hintText: "Select Property Type",
                                suffixIcon: DropdownButton(
                                  // to hide the underline
                                  underline: SizedBox.shrink(),
                                  items: PropertyType.values
                                      .map(
                                        (type) => DropdownMenuItem(
                                          value: type,
                                          child: Text(type.name.capitalize),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      context
                                          .read<PropertyFormCubit>()
                                          .changePropertyType(value.name);
                                      _typeController.text =
                                          value.name.capitalize;
                                    }
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please select property type";
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
                        CustomLabelTextField(
                          labelText: "Build Year",
                          customTextField: CustomTextField(
                            controller: _yearController,
                            hintText: "e.g 2020",
                            keyboardType: .number,
                            validator: (value) =>
                                FormValidators.buildYear(value),
                          ),
                        ),

                        // upload profile image
                        UploadContainer(labelText: "Property Cover Image"),

                        // upload property images
                        BlocSelector<
                          PropertyFormCubit,
                          PropertyFormState,
                          List<File>
                        >(
                          selector: (state) {
                            return state.imageList;
                          },
                          builder: (context, state) {
                            final usedMb = FileUtils.getTotalSizeInMB(state);
                            return UploadContainer(
                              labelText:
                                  "Property Images (${usedMb.toStringAsFixed(2)} mb)",
                              hasMany: true,
                            );
                          },
                        ),

                        // location
                        GestureDetector(
                          onTap: () async {
                            location = await context.router.push(
                              MapPickerRoute(isOwner: true),
                            );
                            if (context.mounted && location != null) {
                              context.read<PropertyFormCubit>().setAddress(
                                location!.address!,
                              );
                            }
                          },
                          child: LocationCard(),
                        ),

                        // property status
                        CustomLabelTextField(
                          labelText: "Property Status",
                          customTextField: CustomTextField(
                            controller: _statusController,
                            readOnly: true,
                            hintText: "Select Property Status",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select property status";
                              }
                              return null;
                            },
                            suffixIcon:
                                BlocSelector<
                                  PropertyFormCubit,
                                  PropertyFormState,
                                  String?
                                >(
                                  selector: (state) {
                                    return state.propertyType;
                                  },
                                  builder: (context, state) {
                                    return DropdownButton(
                                      // to hide the underline
                                      underline: SizedBox.shrink(),
                                      items: PropertyStatus.values
                                          .map(
                                            (type) => DropdownMenuItem(
                                              value: type,
                                              child: Text(type.name.capitalize),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          context
                                              .read<PropertyFormCubit>()
                                              .changePropertyStatus(value.name);
                                          _statusController.text =
                                              value.name.capitalize;
                                        }
                                      },
                                    );
                                  },
                                ),
                          ),
                        ),

                        // facility section
                        Label(label: "Facilites"),
                        FacilityList(),
                        SizedBox(
                          height: ResponsiveDimensions.getSize(context, 4),
                        ),
                        BlocBuilder<PropertyCubit, PropertyState>(
                          builder: (context, state) {
                            bool isLoading = state is PropertyLoading;
                            return CustomButton(
                              onTap: () => _validateAndProfile(context),
                              buttonLabel: TextConstants.addProperty,
                              isLoading: isLoading,
                            );
                          },
                        ),

                        SizedBox(
                          height: ResponsiveDimensions.getSize(context, 6),
                        ),
                      ],
                    ),
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
