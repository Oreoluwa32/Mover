import 'dart:io';
// import 'package:images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/app_export.dart';
import '../../core/utils/file_upload_helper.dart';
import '../../core/utils/permission_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/utils/validation_functions.dart';
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
class VehicleInformationScreen extends ConsumerStatefulWidget{
  const VehicleInformationScreen({Key? key})
    : super(key: key,);

  @override
  VehicleInformationScreenState createState() => VehicleInformationScreenState();
}

// ignore for file, class must be immutable
class VehicleInformationScreenState extends ConsumerState<VehicleInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<void> updateVehicleInfo(BuildContext context) async {
  final token = await getToken();
  if (token == null) {
    Fluttertoast.showToast(msg: "No token found. Please log in first.");
    return;
  }

  final notifierState = ref.watch(vehicleInfoNotifier);

  // Convert images to Base64
  final vehiclePhotoBase64 = notifierState.vehiclePhotoPath != null
        ? base64Encode(File(notifierState.vehiclePhotoPath!).readAsBytesSync())
        : null;
    final driverLicenseBase64 = notifierState.driverLicensePath != null
        ? base64Encode(File(notifierState.driverLicensePath!).readAsBytesSync())
        : null;
    // final vehicleInspectorReportBase64 =
    //     notifierState.vehicleReportPath != null
    //         ? base64Encode(
    //             File(notifierState.vehicleReportPath!)
    //                 .readAsBytesSync())
    //         : null;
    final vehicleInsuranceBase64 = notifierState.vehicleInsurancePath != null
        ? base64Encode(
            File(notifierState.vehicleInsurancePath!).readAsBytesSync())
        : null;

  final url = Uri.parse('https://demosystem.pythonanywhere.com/update-vehicle/');
  final requestBody = {
    "vehicle_plate_number": notifierState.plateNumber?.text,
    "vehicle_type": notifierState.selectedDropDownValue?.title,
    "vehicle_brand": notifierState.selectedDropDownValue1?.title,
    "vehicle_color": notifierState.selectedDropDownValue2?.title,
    if (vehiclePhotoBase64 != null)
        "vehicle_photo": vehiclePhotoBase64,
      if (driverLicenseBase64 != null)
        "driver_license": driverLicenseBase64,
      // if (vehicleInspectorReportBase64 != null)
      //   "vehicle_inspector_report": vehicleInspectorReportBase64,
      if (vehicleInsuranceBase64 != null)
        "vehicle_insurance": vehicleInsuranceBase64,
  };

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final message = jsonDecode(response.body)['message'] ?? 'Update successful';
      Fluttertoast.showToast(msg: message);
      Navigator.pushNamed(context, AppRoutes.verificationScreen);
    } 
    else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to update vehicle information';
      Fluttertoast.showToast(msg: error);
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "An error occurred. Please check your connection.");
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
                                  style: CustomTextStyles.titleSmallGray600Medium.copyWith(height: 1.20,),
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
                                  final state = ref.watch(vehicleInfoNotifier);
                                  return CustomDropDownRevamped(
                                    // prefixIcon: Icon(Icons.layers_outlined, color: Colors.grey.shade600, size: 24.h),
                                    hintText: "Type of Vehicle",
                                    value: (state.selectedDropDownValue?.title?.isNotEmpty ?? false) ? state.selectedDropDownValue?.title : null,
                                    items: state.vehicleInfoModelObj?.dropdownItemList.map((item) => item.title).toList() ?? [],
                                    onChanged: (value) {
                                      final selected = state.vehicleInfoModelObj?.dropdownItemList.firstWhere((item) => item.title == value);
                                      if (selected != null) {
                                        ref.read(vehicleInfoNotifier.notifier).onSelected(selected);
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
                                  final state = ref.watch(vehicleInfoNotifier);
                                  return CustomDropDownRevamped(
                                    // prefixIcon: Icon(Icons.layers_outlined, color: Colors.grey.shade600, size: 24.h),
                                    hintText: "Brand of Vehicle",
                                    value: (state.selectedDropDownValue1?.title?.isNotEmpty ?? false) ? state.selectedDropDownValue1?.title : null,
                                    items: state.vehicleInfoModelObj?.dropdownItemList1.map((item) => item.title).toList() ?? [],
                                    onChanged: (value) {
                                      final selected = state.vehicleInfoModelObj?.dropdownItemList1.firstWhere((item) => item.title == value);
                                      if (selected != null) {
                                        ref.read(vehicleInfoNotifier.notifier).onSelected1(selected);
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
                                  final state = ref.watch(vehicleInfoNotifier);
                                  return CustomDropDownRevamped(
                                    // prefixIcon: Icon(Icons.layers_outlined, color: Colors.grey.shade600, size: 24.h),
                                    hintText: "Color of Vehicle",
                                    value: (state.selectedDropDownValue2?.title?.isNotEmpty ?? false) ? state.selectedDropDownValue2?.title : null,
                                    items: state.vehicleInfoModelObj?.dropdownItemList2.map((item) => item.title).toList() ?? [],
                                    onChanged: (value) {
                                      final selected = state.vehicleInfoModelObj?.dropdownItemList2.firstWhere((item) => item.title == value);
                                      if (selected != null) {
                                        ref.read(vehicleInfoNotifier.notifier).onSelected2(selected);
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
                                    controller: ref.watch(vehicleInfoNotifier).plateNumber,
                              
                                    hintText: "Enter your plate number",
                                    textInputAction: TextInputAction.done,
                                    contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
                                    validator: (value) {
                                      if(!isText(value)) {
                                        return "Please enter a valid text";
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
                                child: _buildFileuploadOne(
                                  context,
                                  clickToUpload: "Click to upload",
                                  uploadSize: "PNG or JPG (max. 800x400px)",
                                  onImageSelected: ref.read(vehicleInfoNotifier.notifier).uploadVehiclePhoto
                                ),
                              ),
                              SizedBox(height: 22.h),
                              Text(
                                "Driver's License",
                                style: CustomTextStyles.titleSmallGray600,
                              ),
                              SizedBox(height: 2.h),
                              SizedBox(
                                width: double.maxFinite,
                                child: _buildFileuploadOne(
                                  context,
                                  clickToUpload: "Click to upload",
                                  uploadSize: "PNG or JPG (max. 800x400px)",
                                  onImageSelected: ref.read(vehicleInfoNotifier.notifier).uploadDriverLicense
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Text(
                                "Vehicle Inspector Report",
                                style: CustomTextStyles.titleSmallGray600,
                              ),
                              SizedBox(
                                width: double.maxFinite,
                                child: _buildFileuploadOne(
                                  context,
                                  clickToUpload: "Click to upload",
                                  uploadSize: "PNG or JPG (max. 800x400px)",
                                  onImageSelected: ref.read(vehicleInfoNotifier.notifier).uploadVehicleReport
                                ),
                              ),
                              SizedBox(height: 22.h),
                              Text(
                                "Vehicle Insurance",
                                style: CustomTextStyles.titleSmallGray600,
                              ),
                              SizedBox(height: 2.h),
                              SizedBox(
                                width: double.maxFinite,
                                child: _buildFileuploadOne(
                                  context,
                                  clickToUpload: "Click to upload",
                                  uploadSize: "PNG or JPG (max. 800x400px)",
                                  onImageSelected: ref.read(vehicleInfoNotifier.notifier).uploadVehicleInsurance
                                ),
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
          )
        )
      );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context){
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
  Widget _buildColumnuploadacl(BuildContext context){
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
            style: CustomTextStyles.bodySmallLightGreen900.copyWith(height: 1.50,),
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
            ref
                .read(vehicleInfoNotifier.notifier)
                .uploadVehicleReport) {
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
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.cover,
                      width: double.maxFinite,
                    ),
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
                        style: CustomTextStyles.bodySmallInterGray600_1
                            .copyWith(
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

  // Section Widget
  Widget _buildSubmit(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomElevatedButton(
                      text: "Submit",
                      buttonStyle: CustomButtonStyles.fillBlueGray,
                      buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
                      onPressed: () {
                        // Call the register function 
                        if (_formKey.currentState?.validate() ?? false) {
                              updateVehicleInfo(context);
                            }
                      },
                    );
      },
    );
  }

  // Navigates back to the verification screen
  onTapLeftArrow(BuildContext context){
    Navigator.pushNamed(context, AppRoutes.verificationScreen);
  }

  // Requests permission to access the camera and storage, and displays a model sheet for selecting images
  // Throws an error if permission is denied or an error occures while selecting images
  requestCameraGalleryPermission(BuildContext context, Function(String) onImageSelected) async {
    await PermissionManager.requestPermission(Permission.camera);
    await PermissionManager.requestPermission(Permission.storage);
    await FileManager().showModelSheetForImage(getImages: (value) async {
      if (value != null && value.isNotEmpty && value[0] != null) {
        onImageSelected(value[0]!);
      }
    });
  }
}