import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/file_upload_helper.dart';
import '../../core/utils/permission_manager.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_radio_button.dart';
import '../../widgets/custom_search_view.dart';
import '../../widgets/custom_text_form_field.dart';
import 'notifier/delivery_details_notifier.dart';

class DeliveryDetailsScreen extends ConsumerStatefulWidget {
  const DeliveryDetailsScreen({Key? key}) : super(key: key);

  @override
  DeliveryDetailsScreenState createState() => DeliveryDetailsScreenState();
}

// ignore for file, class must be iimmuatble
class DeliveryDetailsScreenState extends ConsumerState<DeliveryDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<void> deliveryDetails(WidgetRef ref) async {
    final token = await getToken();
    if (token == null) {
      Fluttertoast.showToast(msg: "No token found. Please log in first.");
      return;
    }

    // Validate the form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final state = ref.read(deliveryDetailsNotifier);

    // Convert image to base64
    final itemImageBase64 = state.imagePath != null
        ? base64Encode(File(state.imagePath!).readAsBytesSync())
        : null;

    final location = state.pickupController?.text;
    final destination = state.destinationController?.text;

    final url =
        Uri.parse('https://movr-api.onrender.com/api/v1/deliveries');
    // Gather details
    final requestBody = {
      "location": location,
      "destination": destination,
      "item_description": state.itemDescrController?.text,
      "item_weight": state.itemWeight,
      "receiver_name": state.nameController?.text,
      "reciever_phone_number": state.phoneController?.text,
      if (itemImageBase64 != null) "item_image": itemImageBase64,
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
          // final message = jsonDecode(response.body)['message'] ?? 'Update successful';
          // Fluttertoast.showToast(msg: message);
          Navigator.pushNamed(context, AppRoutes.searchMoverBottomsheet);
        }
        else {
          // final error = jsonDecode(response.body)['error'] ?? 'Failed to update vehicle information';
          // Fluttertoast.showToast(msg: error);
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "An error occurred. Please check your connection.");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: _buildAppbar(context),
      body: Form(
          key: _formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(
                  left: 16.h,
                  top: 24.h,
                  right: 16.h,
                ),
                child: Column(
                  children: [
                    _buildSearch(context),
                    SizedBox(height: 32.h),
                    _buildUpload(context),
                    SizedBox(height: 24.h),
                    _buildColumntitle(context),
                    SizedBox(height: 22.h),
                    _buildItemWeight(context),
                    SizedBox(height: 22.h),
                    _buildNametitle(context),
                    SizedBox(height: 22.h),
                    _buildPhonetitle(context),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildButtonnav(context),
      );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 90.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgLeftArrow,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 44.h,
          bottom: 22.h,
        ),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Send a package",
        margin: EdgeInsets.only(
          top: 46.h,
          bottom: 19.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildSearch(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Consumer(
              builder: (context, ref, _) {
                return CustomSearchView(
                  controller:
                      ref.watch(deliveryDetailsNotifier).pickupController,
                  hintText: "Pickup",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.h,
                    vertical: 16.h,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          Consumer(
            builder: (context, ref, _) {
              return CustomSearchView(
                controller:
                    ref.watch(deliveryDetailsNotifier).destinationController,
                hintText: "Destination",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.h,
                  vertical: 16.h,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildUpload(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Item Image",
            style: theme.textTheme.labelLarge,
          ),
          SizedBox(height: 2.h),
          Consumer(
            builder: (context, ref, _) {
              final imagePath = ref.watch(deliveryDetailsNotifier).imagePath;
              return GestureDetector(
                onTap: () {
                  requestCameraGalleryPermission(context);
                },
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary.withOpacity(1),
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                    border: Border.all(
                      color: appTheme.blueGray10002,
                      width: 1.h,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconButton(
                        height: 40.h,
                        width: 40.h,
                        padding: EdgeInsets.all(10.h),
                        decoration: IconButtonStyleHelper.outlineGray,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgCloudUpload,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "Click to upload",
                        style: CustomTextStyles.titleSmallInterPrimary,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "PNG or JPG (max. 800x400px)",
                        style: CustomTextStyles.bodySmallInterGray600_1,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildDescription(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller: ref.watch(deliveryDetailsNotifier).itemDescrController,
          hintText: "Description",
          hintStyle: CustomTextStyles.bodySmallBluegray400,
          maxLines: 5,
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 12.h),
          borderDecoration: TextFormFieldStyleHelper.outlineBlueGray,
        );
      },
    );
  }

  // Section Widget
  Widget _buildColumntitle(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Item Description",
            style: theme.textTheme.labelLarge,
          ),
          SizedBox(height: 2.h),
          _buildDescription(context)
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildItemWeight(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Item Weight",
            style: theme.textTheme.labelLarge,
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.maxFinite,
            child: Consumer(
              builder: (context, ref, _) {
                return Row(
                  children: [
                    CustomRadioButton(
                      text: "Light",
                      value: "Light",
                      groupValue: ref.watch(deliveryDetailsNotifier).itemWeight,
                      textStyle: theme.textTheme.labelLarge,
                      onChange: (value) {
                        ref
                            .read(deliveryDetailsNotifier.notifier)
                            .changeRadioButton1(value);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.h),
                      child: CustomRadioButton(
                        text: "Medium",
                        value: "Medium",
                        groupValue:
                            ref.watch(deliveryDetailsNotifier).itemWeight,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        textStyle: theme.textTheme.labelLarge,
                        onChange: (value) {
                          ref
                              .read(deliveryDetailsNotifier.notifier)
                              .changeRadioButton1(value);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.h),
                      child: CustomRadioButton(
                        text: "Heavy",
                        value: "Heavy",
                        groupValue:
                            ref.watch(deliveryDetailsNotifier).itemWeight,
                        textStyle: theme.textTheme.labelLarge,
                        onChange: (value) {
                          ref
                              .read(deliveryDetailsNotifier.notifier)
                              .changeRadioButton1(value);
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildName(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return CustomTextFormField(
        controller: ref.watch(deliveryDetailsNotifier).nameController,
        hintText: "Receiver Name",
        contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
        validator: (value) {
          if (!isText(value)) {
            return "Please enter a valid text";
          }
          return null;
        },
      );
    });
  }

  // Section Widget
  Widget _buildNametitle(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Receiver Name",
            style: theme.textTheme.labelLarge,
          ),
          SizedBox(height: 4.h),
          _buildName(context)
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildPhone(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return CustomTextFormField(
        controller: ref.watch(deliveryDetailsNotifier).phoneController,
        hintText: "Receiver Phone Number",
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.phone,
        contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
        validator: (value) {
          if (!isValidPhone(value)) {
            return "Please enter a valid phone number";
          }
          return null;
        },
      );
    });
  }

  // Section Widget
  Widget _buildPhonetitle(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Receiver Phone Number",
            style: theme.textTheme.labelLarge,
          ),
          SizedBox(height: 4.h),
          _buildPhone(context)
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildFindMover(BuildContext context) {
    return CustomElevatedButton(
      text: "Find Mover",
      buttonStyle: CustomButtonStyles.fillBlueGray,
      onPressed: () {
        NavigatorService.pushNamed(AppRoutes.searchMoverBottomsheet);
      },
    );
  }

  // Section Widget
  Widget _buildButtonnav(BuildContext context) {
    return Container(
      height: 98.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 24.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border(
          top: BorderSide(
            color: appTheme.gray20001,
            width: 1.h,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [_buildFindMover(context)],
      ),
    );
  }

  // Navigates back to the previous screen
  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }

  // Requests permission to access the camera and storage, and displays a model sheet for selecting images
  // Throws an error if permission is denied or an error occures while selecting images
  requestCameraGalleryPermission(BuildContext context) async {
    await PermissionManager.requestPermission(Permission.camera);
    await PermissionManager.requestPermission(Permission.storage);
    List<String?>? imageList = [];
    await FileManager().showModelSheetForImage(getImages: (value) async {
      imageList = value;
    });
  }
}
