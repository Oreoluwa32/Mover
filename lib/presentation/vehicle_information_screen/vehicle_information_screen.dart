import 'dart:io';
// import 'package:images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import '../../core/utils/file_upload_helper.dart';
import '../../core/utils/permission_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/utils/validation_functions.dart';
import '../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../data/services/account_api_service.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down_revamped.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'notifier/vehicle_info_notifier.dart';

// ignore for file, class must be immutable
class VehicleInformationScreen extends ConsumerStatefulWidget {
  const VehicleInformationScreen({Key? key})
      : super(
          key: key,
        );

  @override
  VehicleInformationScreenState createState() =>
      VehicleInformationScreenState();
}

// ignore for file, class must be immutable
class VehicleInformationScreenState
    extends ConsumerState<VehicleInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _existingVehicleId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(vehicleInfoNotifier)
          .plateNumber
          ?.addListener(_handleFormChanged);
      _loadVehicle();
    });
  }

  @override
  void dispose() {
    ref
        .read(vehicleInfoNotifier)
        .plateNumber
        ?.removeListener(_handleFormChanged);
    super.dispose();
  }

  void _handleFormChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadVehicle() async {
    final accountApiService = AccountApiService();
    try {
      final vehicles = await accountApiService.getVehicles();
      if (vehicles.isEmpty) {
        return;
      }

      final vehicle = vehicles.first;
      _existingVehicleId = vehicle['id']?.toString();
      final metadata =
          (vehicle['metadata'] as Map?)?.cast<String, dynamic>() ?? {};
      final notifier = ref.read(vehicleInfoNotifier.notifier);
      final state = ref.read(vehicleInfoNotifier);

      state.plateNumber?.text = vehicle['plate_number']?.toString() ?? '';

      final vehicleTypeTitle =
          _vehicleTypeLabel(vehicle['vehicle_type']?.toString() ?? '');
      final selectedType =
          state.vehicleInfoModelObj?.dropdownItemList.firstWhere(
        (item) => item.title == vehicleTypeTitle,
        orElse: () => SelectionPopupModel(title: vehicleTypeTitle),
      );
      if (selectedType != null && vehicleTypeTitle.isNotEmpty) {
        notifier.onSelected(selectedType);
      }

      final make = vehicle['make']?.toString() ?? '';
      final selectedBrand =
          state.vehicleInfoModelObj?.dropdownItemList1.firstWhere(
        (item) => item.title == make,
        orElse: () => SelectionPopupModel(title: make),
      );
      if (selectedBrand != null && make.isNotEmpty) {
        notifier.onSelected1(selectedBrand);
      }

      final color = vehicle['color']?.toString() ?? '';
      final selectedColor =
          state.vehicleInfoModelObj?.dropdownItemList2.firstWhere(
        (item) => item.title == color,
        orElse: () => SelectionPopupModel(title: color),
      );
      if (selectedColor != null && color.isNotEmpty) {
        notifier.onSelected2(selectedColor);
      }

      _applyStoredDocumentPath(
        metadata['vehicle_photo'],
        notifier.uploadVehiclePhoto,
      );
      _applyStoredDocumentPath(
        metadata['driver_license'],
        notifier.uploadDriverLicense,
      );
      _applyStoredDocumentPath(
        metadata['vehicle_report'],
        notifier.uploadVehicleReport,
      );
      _applyStoredDocumentPath(
        metadata['vehicle_insurance'],
        notifier.uploadVehicleInsurance,
      );
      if (mounted) {
        setState(() {});
      }
    } catch (_) {
      // Keep form usable even if no existing vehicle is available.
    }
  }

  void _applyStoredDocumentPath(
    dynamic value,
    void Function(String) onPathResolved,
  ) {
    if (value is String && value.trim().isNotEmpty) {
      onPathResolved(value.trim());
    }
  }

  Future<void> updateVehicleInfo(BuildContext context) async {
    final accountApiService = AccountApiService();
    final notifierState = ref.read(vehicleInfoNotifier);

    if (_isSubmitting) {
      return;
    }

    try {
      setState(() {
        _isSubmitting = true;
      });
      final vehicleType = _vehicleTypeValue(
        notifierState.selectedDropDownValue?.title ?? '',
      );
      final make = notifierState.selectedDropDownValue1?.title ?? '';
      final model = notifierState.selectedDropDownValue1?.title ?? '';
      final color = notifierState.selectedDropDownValue2?.title ?? '';
      final plateNumber = notifierState.plateNumber?.text ?? '';
      final metadata = <String, dynamic>{
        if (notifierState.vehiclePhotoPath != null)
          'vehicle_photo': notifierState.vehiclePhotoPath,
        if (notifierState.driverLicensePath != null)
          'driver_license': notifierState.driverLicensePath,
        if (notifierState.vehicleReportPath != null)
          'vehicle_report': notifierState.vehicleReportPath,
        if (notifierState.vehicleInsurancePath != null)
          'vehicle_insurance': notifierState.vehicleInsurancePath,
      };

      if (_existingVehicleId != null && _existingVehicleId!.isNotEmpty) {
        await accountApiService.updateVehicle(
          vehicleId: _existingVehicleId!,
          vehicleType: vehicleType,
          make: make,
          model: model,
          color: color,
          plateNumber: plateNumber,
          metadata: metadata,
          vehiclePhotoPath: notifierState.vehiclePhotoPath,
          driverLicensePath: notifierState.driverLicensePath,
          vehicleReportPath: notifierState.vehicleReportPath,
          vehicleInsurancePath: notifierState.vehicleInsurancePath,
        );
      } else {
        final vehicle = await accountApiService.createVehicle(
          vehicleType: vehicleType,
          make: make,
          model: model,
          color: color,
          plateNumber: plateNumber,
          metadata: metadata,
          vehiclePhotoPath: notifierState.vehiclePhotoPath,
          driverLicensePath: notifierState.driverLicensePath,
          vehicleReportPath: notifierState.vehicleReportPath,
          vehicleInsurancePath: notifierState.vehicleInsurancePath,
        );
        _existingVehicleId = vehicle['id']?.toString();
      }

      Fluttertoast.showToast(msg: 'Vehicle information updated successfully');
      if (context.mounted) {
        Navigator.pushNamed(context, AppRoutes.verificationScreen);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: accountApiService.extractErrorMessage(e));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _vehicleTypeValue(String title) {
    switch (title.toLowerCase()) {
      case 'car':
        return 'car';
      case 'bike':
        return 'bike';
      case 'truck':
        return 'truck';
      default:
        return 'car';
    }
  }

  String _vehicleTypeLabel(String value) {
    switch (value.toLowerCase()) {
      case 'car':
        return 'Car';
      case 'bike':
        return 'Bike';
      case 'truck':
        return 'Truck';
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(context),
        body: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.only(
                        left: 14.h,
                        top: 22.h,
                        right: 14.h,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 292.h,
                                  child: Text(
                                    "Complete the necessary field to validate your vehicle",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomTextStyles
                                        .titleSmallGray600Medium
                                        .copyWith(
                                      height: 1.20,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 28.h),
                                Text(
                                  "Vehicle Type",
                                  style: CustomTextStyles.titleSmallGray600,
                                ),
                                SizedBox(height: 4.h),
                                Consumer(
                                  builder: (context, ref, _) {
                                    final state =
                                        ref.watch(vehicleInfoNotifier);
                                    return CustomDropDownRevamped(
                                      // prefixIcon: Icon(Icons.layers_outlined, color: Colors.grey.shade600, size: 24.h),
                                      hintText: "Type of Vehicle",
                                      value: (state.selectedDropDownValue?.title
                                                  ?.isNotEmpty ??
                                              false)
                                          ? state.selectedDropDownValue?.title
                                          : null,
                                      items: state.vehicleInfoModelObj
                                              ?.dropdownItemList
                                              .map((item) => item.title)
                                              .toList() ??
                                          [],
                                      onChanged: (value) {
                                        final selected = state
                                            .vehicleInfoModelObj
                                            ?.dropdownItemList
                                            .firstWhere(
                                                (item) => item.title == value);
                                        if (selected != null) {
                                          ref
                                              .read(
                                                  vehicleInfoNotifier.notifier)
                                              .onSelected(selected);
                                        }
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: 22.h),
                                Text(
                                  "Vehicle Brand",
                                  style: CustomTextStyles.titleSmallGray600,
                                ),
                                SizedBox(height: 6.h),
                                Consumer(
                                  builder: (context, ref, _) {
                                    final state =
                                        ref.watch(vehicleInfoNotifier);
                                    return CustomDropDownRevamped(
                                      // prefixIcon: Icon(Icons.layers_outlined, color: Colors.grey.shade600, size: 24.h),
                                      hintText: "Brand of Vehicle",
                                      value: (state.selectedDropDownValue1
                                                  ?.title?.isNotEmpty ??
                                              false)
                                          ? state.selectedDropDownValue1?.title
                                          : null,
                                      items: state.vehicleInfoModelObj
                                              ?.dropdownItemList1
                                              .map((item) => item.title)
                                              .toList() ??
                                          [],
                                      onChanged: (value) {
                                        final selected = state
                                            .vehicleInfoModelObj
                                            ?.dropdownItemList1
                                            .firstWhere(
                                                (item) => item.title == value);
                                        if (selected != null) {
                                          ref
                                              .read(
                                                  vehicleInfoNotifier.notifier)
                                              .onSelected1(selected);
                                        }
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: 22.h),
                                Text(
                                  "Vehicle Color",
                                  style: CustomTextStyles.titleSmallGray600,
                                ),
                                SizedBox(height: 6.h),
                                Consumer(
                                  builder: (context, ref, _) {
                                    final state =
                                        ref.watch(vehicleInfoNotifier);
                                    return CustomDropDownRevamped(
                                      // prefixIcon: Icon(Icons.layers_outlined, color: Colors.grey.shade600, size: 24.h),
                                      hintText: "Color of Vehicle",
                                      value: (state.selectedDropDownValue2
                                                  ?.title?.isNotEmpty ??
                                              false)
                                          ? state.selectedDropDownValue2?.title
                                          : null,
                                      items: state.vehicleInfoModelObj
                                              ?.dropdownItemList2
                                              .map((item) => item.title)
                                              .toList() ??
                                          [],
                                      onChanged: (value) {
                                        final selected = state
                                            .vehicleInfoModelObj
                                            ?.dropdownItemList2
                                            .firstWhere(
                                                (item) => item.title == value);
                                        if (selected != null) {
                                          ref
                                              .read(
                                                  vehicleInfoNotifier.notifier)
                                              .onSelected2(selected);
                                        }
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: 22.h),
                                Text(
                                  "Vehicle Plate Number",
                                  style: CustomTextStyles.titleSmallGray600,
                                ),
                                SizedBox(height: 6.h),
                                Consumer(
                                  builder: (context, ref, _) {
                                    return CustomTextFormField(
                                      controller: ref
                                          .watch(vehicleInfoNotifier)
                                          .plateNumber,
                                      hintText:
                                          "Enter plate number e.g. ABC-123DE",
                                      textInputAction: TextInputAction.done,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r'[A-Za-z0-9-]'),
                                        ),
                                        TextInputFormatter.withFunction(
                                          (oldValue, newValue) =>
                                              newValue.copyWith(
                                            text: newValue.text.toUpperCase(),
                                            selection: newValue.selection,
                                          ),
                                        ),
                                      ],
                                      contentPadding: EdgeInsets.fromLTRB(
                                          14.h, 16.h, 14.h, 14.h),
                                      validator: (value) {
                                        if (!isValidNigerianPlateNumber(value,
                                            isRequired: true)) {
                                          return "Use the Nigerian plate format ABC-123DE";
                                        }
                                        return null;
                                      },
                                    );
                                  },
                                ),
                                SizedBox(height: 22.h),
                                Text(
                                  "Vehicle Photo",
                                  style: CustomTextStyles.titleSmallGray600,
                                ),
                                SizedBox(height: 2.h),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: _buildFileuploadOne(context,
                                      clickToUpload: "Click to upload",
                                      uploadSize: "PNG or JPG (max. 800x400px)",
                                      onImageSelected: ref
                                          .read(vehicleInfoNotifier.notifier)
                                          .uploadVehiclePhoto),
                                ),
                                SizedBox(height: 22.h),
                                Text(
                                  "Driver's License",
                                  style: CustomTextStyles.titleSmallGray600,
                                ),
                                SizedBox(height: 2.h),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: _buildFileuploadOne(context,
                                      clickToUpload: "Click to upload",
                                      uploadSize: "PNG or JPG (max. 800x400px)",
                                      onImageSelected: ref
                                          .read(vehicleInfoNotifier.notifier)
                                          .uploadDriverLicense),
                                ),
                                SizedBox(height: 24.h),
                                Text(
                                  "Vehicle Inspector Report",
                                  style: CustomTextStyles.titleSmallGray600,
                                ),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: _buildFileuploadOne(context,
                                      clickToUpload: "Click to upload",
                                      uploadSize: "PNG or JPG (max. 800x400px)",
                                      onImageSelected: ref
                                          .read(vehicleInfoNotifier.notifier)
                                          .uploadVehicleReport),
                                ),
                                SizedBox(height: 22.h),
                                Text(
                                  "Vehicle Insurance",
                                  style: CustomTextStyles.titleSmallGray600,
                                ),
                                SizedBox(height: 2.h),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: _buildFileuploadOne(context,
                                      clickToUpload: "Click to upload",
                                      uploadSize: "PNG or JPG (max. 800x400px)",
                                      onImageSelected: ref
                                          .read(vehicleInfoNotifier.notifier)
                                          .uploadVehicleInsurance),
                                ),
                                SizedBox(height: 24.h),
                                _buildColumnuploadacl(context)
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.h, 16.h, 16.h, 24.h),
                  child: _buildSubmit(context),
                )
              ],
            )));
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 90.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeft,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 24.h,
          bottom: 42.h,
        ),
        onTap: () => Navigator.pushNamed(context, AppRoutes.verificationScreen),
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Vehicle Identification",
        margin: EdgeInsets.only(
          top: 22.h,
          bottom: 44.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildColumnuploadacl(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: appTheme.gray100,
        borderRadius: BorderRadiusStyle.roundedBorder4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Upload a clear and non-blurry image of your vehicle",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.bodySmallLightGreen900.copyWith(
              height: 1.50,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            "Ensure the correct image is being uploaded",
            style: CustomTextStyles.bodySmallLightGreen900,
          ),
          SizedBox(height: 2.h),
          Text(
            "This request will be reviewed in 3-5 mins",
            style: CustomTextStyles.bodySmallLightGreen900,
          )
        ],
      ),
    );
  }

  // Common Widget
  Widget _buildFileuploadOne(
    BuildContext context, {
    required String clickToUpload,
    required String uploadSize,
    required Function(String) onImageSelected,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        // Get the appropriate image path based on the caller
        String? imagePath;
        if (onImageSelected ==
            ref.read(vehicleInfoNotifier.notifier).uploadVehiclePhoto) {
          imagePath = ref.watch(vehicleInfoNotifier).vehiclePhotoPath;
        } else if (onImageSelected ==
            ref.read(vehicleInfoNotifier.notifier).uploadDriverLicense) {
          imagePath = ref.watch(vehicleInfoNotifier).driverLicensePath;
        } else if (onImageSelected ==
            ref.read(vehicleInfoNotifier.notifier).uploadVehicleReport) {
          imagePath = ref.watch(vehicleInfoNotifier).vehicleReportPath;
        } else if (onImageSelected ==
            ref.read(vehicleInfoNotifier.notifier).uploadVehicleInsurance) {
          imagePath = ref.watch(vehicleInfoNotifier).vehicleInsurancePath;
        }

        return GestureDetector(
          onTap: () {
            requestCameraGalleryPermission(context, onImageSelected);
          },
          child: Container(
            height: 120.h,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(1),
              borderRadius: BorderRadiusStyle.roundedBorder8,
              border: Border.all(
                color: appTheme.blueGray10002,
                width: 1.h,
              ),
            ),
            child: imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                    child: _buildDocumentPreview(imagePath),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconButton(
                        height: 40.h,
                        width: 40.h,
                        padding: EdgeInsets.all(10.h),
                        decoration: IconButtonStyleHelper.outlineGrayTL20,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgCloudUpload,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        clickToUpload,
                        style: CustomTextStyles.titleSmallInterPrimary.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        uploadSize,
                        style:
                            CustomTextStyles.bodySmallInterGray600_1.copyWith(
                          color: appTheme.gray600,
                        ),
                      )
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildDocumentPreview(String imagePath) {
    if (_isRemoteUrl(imagePath)) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.maxFinite,
        errorBuilder: (_, __, ___) => _buildPreviewFallback(),
      );
    }

    if (_isExistingLocalFile(imagePath)) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: double.maxFinite,
      );
    }

    return _buildPreviewFallback();
  }

  Widget _buildPreviewFallback() {
    return Container(
      color: appTheme.gray100,
      alignment: Alignment.center,
      child: Text(
        "Preview unavailable",
        style: CustomTextStyles.bodySmallInterGray600_1,
      ),
    );
  }

  bool _isRemoteUrl(String value) {
    return value.startsWith('http://') || value.startsWith('https://');
  }

  bool _isExistingLocalFile(String value) {
    try {
      return File(value).existsSync();
    } catch (_) {
      return false;
    }
  }

  bool _isVehicleFormComplete(VehicleInfoState state) {
    final hasVehicleType =
        (state.selectedDropDownValue?.title ?? '').trim().isNotEmpty;
    final hasBrand =
        (state.selectedDropDownValue1?.title ?? '').trim().isNotEmpty;
    final hasColor =
        (state.selectedDropDownValue2?.title ?? '').trim().isNotEmpty;
    final hasValidPlate =
        isValidNigerianPlateNumber(state.plateNumber?.text, isRequired: true);
    final hasVehiclePhoto = (state.vehiclePhotoPath ?? '').trim().isNotEmpty;
    final hasDriverLicense = (state.driverLicensePath ?? '').trim().isNotEmpty;
    final hasVehicleReport = (state.vehicleReportPath ?? '').trim().isNotEmpty;
    final hasVehicleInsurance =
        (state.vehicleInsurancePath ?? '').trim().isNotEmpty;

    return hasVehicleType &&
        hasBrand &&
        hasColor &&
        hasValidPlate &&
        hasVehiclePhoto &&
        hasDriverLicense &&
        hasVehicleReport &&
        hasVehicleInsurance;
  }

  // Section Widget
  Widget _buildSubmit(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final vehicleState = ref.watch(vehicleInfoNotifier);
        final isFormComplete = _isVehicleFormComplete(vehicleState);
        return CustomElevatedButton(
          text: "Submit",
          buttonStyle: CustomButtonStyles.fillBlueGray,
          buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
          isDisabled: !isFormComplete,
          isLoading: _isSubmitting,
          loadingText: "Uploading documents...",
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              updateVehicleInfo(context);
            }
          },
        );
      },
    );
  }

  // Navigates back to the verification screen
  onTapLeftArrow(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.verificationScreen);
  }

  // Requests permission to access the camera and storage, and displays a model sheet for selecting images
  // Throws an error if permission is denied or an error occures while selecting images
  requestCameraGalleryPermission(
      BuildContext context, Function(String) onImageSelected) async {
    await PermissionManager.requestPermission(Permission.camera);
    await PermissionManager.requestPermission(Permission.storage);
    await FileManager().showModelSheetForImage(getImages: (value) async {
      if (value != null && value.isNotEmpty && value[0] != null) {
        onImageSelected(value[0]!);
        if (mounted) {
          setState(() {});
        }
      }
    });
  }
}
