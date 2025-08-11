import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/app_export.dart';
import '../set_date_bottomsheet/set_date_bottomsheet.dart';
import '../../core/utils/date_time_utils.dart';
import '../../core/utils/file_upload_helper.dart';
import '../../core/utils/permission_manager.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_radio_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/custom_icon_button.dart';
import 'models/add_route_item_model.dart';
import 'notifier/add_route_two_notifier.dart';

class AddRouteScreenThree extends ConsumerStatefulWidget {
  const AddRouteScreenThree({super.key});

  @override
  AddRouteScreenThreeState createState() => AddRouteScreenThreeState();
}

class AddRouteScreenThreeState extends ConsumerState<AddRouteScreenThree> {
  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'auth_token');
  }

  Future<void> createRoute(BuildContext context) async {
    final token = await getToken();
    if (token == null) {
      Fluttertoast.showToast(msg: "No token found. Please log in first.");
      return;
    }

    final notifierState = ref.read(addRouteTwoNotifier);

    // Convert image to base64
    final itemImageBase64 = notifierState.imagePath != null
        ? base64Encode(File(notifierState.imagePath!).readAsBytesSync())
        : null;

    final location = notifierState.locationController?.text;
    final stop = notifierState.stopController?.text;
    final destination = notifierState.destinationController?.text;

    final url = Uri.parse(
        'https://demosystem.pythonanywhere.com/create-scheduled-route/');
    final requestBody = {
      "location": location,
      "stop": stop,
      "destination": destination,
      "transportation_mode":
          notifierState.addRouteTwoModelObj?.transportMeansList
              .firstWhere(
                (item) => item.isSelected,
                orElse: () => AddRouteItemModel(),
              )
              .tabTitle,
      "service_type": notifierState.serviceDropdownValue?.title,
      "departure_time": notifierState.setTimeController,
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
        final message = jsonDecode(response.body)['message'] ??
            'Route created successfully.';
        Fluttertoast.showToast(msg: message);
      } else {
        final error =
            jsonDecode(response.body)['error'] ?? 'Failed to create route.';
        Fluttertoast.showToast(msg: error);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "An error occurred. Please check your connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            _buildAddrouteone(context),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(top: 30.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildColumnmeansof(context),
                      SizedBox(height: 22.h),
                      Consumer(
                        builder: (context, ref, _) {
                          final selectedTransportMode = ref.watch(addRouteTwoNotifier).addRouteTwoModelObj?.transportMeansList.firstWhere((item) => item.isSelected,
                          orElse: () => AddRouteItemModel(),
                          ).tabTitle;

                          if(selectedTransportMode == null) {
                            return Container(); // If no tab is selected, return empty container
                          }
                          if (selectedTransportMode == "Public") {
                            return SizedBox(
                              width: double.maxFinite,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildColumnnumberof(context),
                                      SizedBox(height: 24.h),
                                      _buildMaxCap(context),
                                      SizedBox(height: 24.h),
                                      _buildDepartureone(context),
                                      SizedBox(height: 22.h),
                                      Text(
                                        "Do you want to make a returning route?",
                                        style: theme.textTheme.labelLarge,
                                      ),
                                      SizedBox(height: 10.h),
                                      _buildDoyouwantto(context),
                                      SizedBox(height: 22.h),
                                      _buildColumnreturn(context),
                                      SizedBox(height: 24.h),
                                      _buildTimeRange(context),
                                      SizedBox(
                                        height: 22.h,
                                      ),
                                      _buildTrainTicket(context),
                                      SizedBox(
                                        height: 22.h,
                                      ),
                                      _buildUpload(context)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return Container();
                        }
                      ),
                      SizedBox(height: 4.h)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: _buildButtonnav(context),
    ));
  }

  // Section Widget
  Widget _buildAddrouteone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(
        top: 24.h,
        bottom: 22.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray20001,
            width: 1.h,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withOpacity(0.08),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(
              0,
              3,
            ),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.h),
          CustomAppBar(
            leadingWidth: 40.h,
            leading: AppbarLeadingImage(
              imagePath: ImageConstant.imgCancel,
              margin: EdgeInsets.only(left: 16.h),
              onTap: () {
                onTapBack(context);
              },
            ),
            centerTitle: true,
            title: AppbarSubtitle(
              text: "Add Route",
            ),
            actions: [
              AppbarTrailingImage(
                imagePath: ImageConstant.imgPlusBlack,
                margin: EdgeInsets.only(right: 15.h),
              )
            ],
          ),
          SizedBox(height: 22.h),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    return CustomTextFormField(
                      controller: ref.watch(addRouteTwoNotifier).locationController,
                      hintText: "Enter your location",
                      borderDecoration: TextFormFieldStyleHelper.outlineGray1,
                      // onTap: () {
                      //   ref
                      //       .read(addRouteTwoNotifier.notifier)
                      //       .changeRadioBtn('location');
                      // },
                    );
                  },
                ),
                SizedBox(height: 16.h),
                Consumer(
                  builder: (context, ref, _) {
                    return CustomTextFormField(
                      controller: ref.watch(addRouteTwoNotifier).stopController,
                      hintText: "Add stop",
                      borderDecoration: TextFormFieldStyleHelper.outlineGray1,
                      // onTap: () {
                      //   ref
                      //       .read(addRouteTwoNotifier.notifier)
                      //       .changeRadioBtn('stop');
                      // },
                    );
                  },
                ),
                SizedBox(height: 16.h),
                Consumer(
                  builder: (context, ref, _) {
                    return CustomTextFormField(
                      controller: ref.watch(addRouteTwoNotifier).destinationController,
                      hintText: "Enter your destination",
                      borderDecoration: TextFormFieldStyleHelper.outlineGray1,
                      // onTap: () {
                      //   ref
                      //       .read(addRouteTwoNotifier.notifier)
                      //       .changeRadioBtn('destination');
                      // },
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildColumnmeansof(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(left: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Means of transportation",
            style: theme.textTheme.labelLarge,
          ),
          SizedBox(height: 12.h),
          Consumer(
            builder: (context, ref, _) {
              final transportModes = ref
                      .watch(addRouteTwoNotifier)
                      .addRouteTwoModelObj
                      ?.transportMeansList ??
                  [];
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(transportModes.length, (index) {
                    final mode = transportModes[index];
                    final isSelected = mode.isSelected;

                    return GestureDetector(
                      onTap: () {
                        // Change the selected mode when tapped
                        ref
                            .read(addRouteTwoNotifier.notifier)
                            .selectTransportMode(index);
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.h),
                        margin: EdgeInsets.only(right: 25.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.1)
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : appTheme.gray20001,
                            width: 2.h,
                          ),
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                        child: Column(
                          children: [
                            CustomImageView(
                              imagePath: mode.tabImage ?? '',
                              height: 40.h,
                              width: 40.h,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              mode.tabTitle ?? '',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : appTheme.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildColumnnumberof(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Type of service",
              style: theme.textTheme.labelLarge,
            ),
            SizedBox(
              height: 4.h,
            ),
            Consumer(builder: (context, ref, _) {
              return CustomDropDown(
                icon: Container(
                  margin: EdgeInsets.only(left: 16.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgBlueGrayDownArrow,
                    height: 16.h,
                    width: 20.h,
                    fit: BoxFit.contain,
                  ),
                ),
                iconSize: 16.h,
                hintText: "Type of service",
                items: ref
                        .watch(addRouteTwoNotifier)
                        .addRouteTwoModelObj
                        ?.serviceDropdown
                        .map((item) => item.title)
                        .toList() ??
                    [],
                contentPadding: EdgeInsets.all(14.h),
                borderDecoration: DropDownStyleHelper.outlineBlueGray,
              );
            })
          ],
        ));
  }

  // Section Widget
  Widget _buildMaxCap(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Maximum Capacity",
              style: theme.textTheme.labelLarge,
            ),
            SizedBox(
              height: 4.h,
            ),
            Consumer(builder: (context, ref, _) {
              return CustomDropDown(
                icon: Container(
                  margin: EdgeInsets.only(left: 16.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgBlueGrayDownArrow,
                    height: 16.h,
                    width: 20.h,
                    fit: BoxFit.contain,
                  ),
                ),
                iconSize: 16.h,
                hintText: "Maximum Capacity",
                items: ref
                        .watch(addRouteTwoNotifier)
                        .addRouteTwoModelObj
                        ?.maxCapDropdown
                        .map((item) => item.title)
                        .toList() ??
                    [],
                contentPadding: EdgeInsets.all(14.h),
                borderDecoration: DropDownStyleHelper.outlineBlueGray,
              );
            })
          ],
        ));
  }

  // Section Widget
  Widget _buildDate(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return CustomTextFormField(
        readOnly: true,
        controller: ref.watch(addRouteTwoNotifier).setDateController,
        hintText: "Set date",
        prefix: Container(
          margin: EdgeInsets.fromLTRB(14.h, 16.h, 12.h, 16.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgCalendar,
            height: 16.h,
            width: 16.h,
            fit: BoxFit.contain,
          ),
        ),
        prefixConstraints: BoxConstraints(
          maxHeight: 50.h,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.h,
          vertical: 16.h,
        ),
        onTap: () {
          showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.h))),
              builder: (BuildContext context) {
                return const SetDateBottomsheet();
              });
        },
      );
    });
  }

  // Section Widget
  Widget _buildTime(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          readOnly: true,
          controller: ref.watch(addRouteTwoNotifier).setTimeController,
          hintText: "Set time",
          textInputAction: TextInputAction.done,
          prefix: Container(
            margin: EdgeInsets.fromLTRB(14.h, 16.h, 12.h, 16.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgClock,
              height: 16.h,
              width: 16.h,
              fit: BoxFit.contain,
            ),
          ),
          prefixConstraints: BoxConstraints(maxHeight: 50.h),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.h,
            vertical: 16.h,
          ),
          onTap: () {
            onTapTime(context);
          },
        );
      },
    );
  }

  // Section Widget
  Widget _buildDepartureone(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Departure",
            style: theme.textTheme.labelLarge,
          ),
          SizedBox(height: 14.h),
          _buildDate(context),
          SizedBox(height: 14.h),
          _buildTime(context),
          SizedBox(height: 14.h),
          Consumer(builder: (context, ref, _) {
            return CustomDropDown(
              icon: Container(
                margin: EdgeInsets.only(left: 16.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgBlueGrayDownArrow,
                  height: 16.h,
                  width: 20.h,
                  fit: BoxFit.contain,
                ),
              ),
              iconSize: 16.h,
              hintText: "Does not repeat",
              hintStyle: CustomTextStyles.bodySmallErrorContainer,
              items: ref
                      .watch(addRouteTwoNotifier)
                      .addRouteTwoModelObj
                      ?.repeatDropdown
                      .map((item) => item.title)
                      .toList() ??
                  [],
              prefix: Container(
                margin: EdgeInsets.fromLTRB(14.h, 16.h, 12.h, 16.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgRepeat,
                  height: 16.h,
                  width: 16.h,
                  fit: BoxFit.contain,
                ),
              ),
              prefixConstraints: BoxConstraints(maxHeight: 50.h),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.h,
                vertical: 16.h,
              ),
            );
          })
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildDoyouwantto(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        child: Consumer(builder: (context, ref, _) {
          return Row(
            children: [
              CustomRadioButton(
                text: "Yes",
                value: "Yes",
                groupValue: ref.watch(addRouteTwoNotifier).returnRadio,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                textStyle: theme.textTheme.labelLarge,
                onChange: (value) {
                  ref.read(addRouteTwoNotifier.notifier).changeRadioBtn(value);
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.h),
                child: CustomRadioButton(
                  text: "No",
                  value: "No",
                  groupValue: ref.watch(addRouteTwoNotifier).returnRadio,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  textStyle: theme.textTheme.labelLarge,
                  onChange: (value) {
                    ref
                        .read(addRouteTwoNotifier.notifier)
                        .changeRadioBtn(value);
                  },
                ),
              )
            ],
          );
        }));
  }

  // Section Widget
  Widget _buildGateway(BuildContext context) {
    return CustomElevatedButton(
      text: "Gateway Zone, Magodo Phase II, GRA Lagos State",
      leftIcon: Container(
        margin: EdgeInsets.only(right: 12.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgSearch,
          height: 24.h,
          width: 24.h,
          fit: BoxFit.contain,
        ),
      ),
      buttonStyle: CustomButtonStyles.fillGray,
      buttonTextStyle: CustomTextStyles.bodySmallOnPrimaryContainer,
    );
  }

  // Section Widget
  Widget _buildColumnreturn(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Return Destination",
            style: CustomTextStyles.labelLargeGray600,
          ),
          SizedBox(height: 4.h),
          _buildGateway(context)
        ],
      ),
    );
  }

  // Section Wigdet
  Widget _buildTimeBegin(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          readOnly: true,
          width: 148.h,
          controller: ref.watch(addRouteTwoNotifier).setTimeBeginController,
          hintText: "Set time",
          prefix: Container(
            margin: EdgeInsets.fromLTRB(14.h, 14.h, 12.h, 14.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgClock,
              height: 16.h,
              width: 16.h,
              fit: BoxFit.contain,
            ),
          ),
          prefixConstraints: BoxConstraints(maxHeight: 46.h),
          contentPadding: EdgeInsets.all(14.h),
          onTap: () {
            onTapTimeBegin(context);
          },
        );
      },
    );
  }

  // Section Widget
  Widget _buildTimeEnd(BuildContext context) {
    return Expanded(
      child: CustomTextFormField(
        readOnly: true,
        controller: ref.watch(addRouteTwoNotifier).setTimeEndController,
        hintText: "Set time",
        textInputAction: TextInputAction.done,
        prefix: Container(
          margin: EdgeInsets.fromLTRB(14.h, 14.h, 12.h, 14.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgClock,
            height: 16.h,
            width: 16.h,
            fit: BoxFit.contain,
          ),
        ),
        prefixConstraints: BoxConstraints(maxHeight: 46.h),
        contentPadding: EdgeInsets.all(14.h),
        onTap: () {
          onTapTimeEnd(context);
        },
      ),
    );
  }

  // Section Widget
  Widget _buildTimeRange(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Time Range",
            style: CustomTextStyles.labelLargeGray600,
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                _buildTimeBegin(context),
                SizedBox(width: 14.h),
                Expanded(
                  child: Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgRightArrow,
                        height: 16.h,
                        width: 16.h,
                      ),
                      SizedBox(width: 14.h),
                      _buildTimeEnd(context)
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildTrainTicket(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Train Ticket",
            style: theme.textTheme.labelLarge,
          ),
          SizedBox(
            height: 4.h,
          ),
          Consumer(
            builder: (context, ref, _) {
              final imagePath = ref.watch(addRouteTwoNotifier).imagePath;
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
                      border:
                          Border.all(color: appTheme.blueGray10002, width: 1.h),
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
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          "Click to upload",
                          style: CustomTextStyles.titleSmallInterPrimary,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          "PNG or JPG (max. 800 x 400px)",
                          style: CustomTextStyles.bodySmallInterGray600_1,
                        )
                      ],
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildUpload(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(left: 12.h, top: 14.h, bottom: 14.h),
      decoration: BoxDecoration(
          color: appTheme.gray100,
          borderRadius: BorderRadiusStyle.roundedBorder2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upload a clear and non-blurry image of your log ticket",
            style: CustomTextStyles.bodySmallLightGreen900,
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            "Ensure the correct log ticket is being uploaded",
            style: CustomTextStyles.bodySmallLightGreen900,
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            "This request wil be reviewed in 3 - 5 minutes",
            style: CustomTextStyles.bodySmallLightGreen900,
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildAddroute(BuildContext context) {
    return CustomElevatedButton(
      text: "Add route",
      buttonStyle: CustomButtonStyles.fillBlueGray,
      onPressed: () {
        NavigatorService.pushNamed(AppRoutes.saveYourRouteDialog);
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
        children: [_buildAddroute(context)],
      ),
    );
  }

  // Displays a date picker dialog and updates the selected date in the [addRouteTwoModelObj] object of the current [setDateController] if the user selects a valid date.
  // This function returns a `Future` that completes with `void`.
  Future<void> onTapDate(BuildContext context) async {
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate:
            ref.watch(addRouteTwoNotifier).addRouteTwoModelObj!.setDate ??
                DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));
    if (dateTime != null) {
      ref.watch(addRouteTwoNotifier).addRouteTwoModelObj!.setDate = dateTime;
      ref.watch(addRouteTwoNotifier).setDateController?.text =
          dateTime.format(pattern: dateTimeFormatPattern);
    }
  }

  // Displays a date picker dialog and updates the selected date in the [addRouteTwoModelObj] object of the current [setTimeController] if the user selects a valid date.
  // This function returns a `Future` that completes with `void`.
  Future<void> onTapTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Access the state using ref.watch()
      final notifierState = ref.watch(addRouteTwoNotifier);

      ref.read(addRouteTwoNotifier.notifier).state = notifierState.copyWith(
          setTime: pickedTime); // Update with the pickedTime

      // Format the pickedTime as needed (e.g., 'HH:mm')
      final formattedTime =
          "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
      ref.watch(addRouteTwoNotifier).setTimeController?.text = formattedTime;
    }
  }

  // Displays a date picker dialog and updates the selected date in the [addRouteTwoModelObj] object of the current [timeBeginController] if the user selects a valid date.
  // This function returns a `Future` that completes with `void`.
  Future<void> onTapTimeBegin(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Access the state using ref.watch()
      final notifierState = ref.watch(addRouteTwoNotifier);

      // Update the setTime in your notifierState
      ref.read(addRouteTwoNotifier.notifier).state = notifierState.copyWith(
          setTime: pickedTime); // Update with the pickedTime

      // Format the pickedTime as needed (e.g., 'HH:mm')
      final formattedTime =
          "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
      ref.watch(addRouteTwoNotifier).setTimeController?.text = formattedTime;
    }
  }

  // Displays a date picker dialog and updates the selected date in the [addRouteTwoModelObj] object of the current [timeEndController] if the user selects a valid date.
  // This function returns a `Future` that completes with `void`.
  Future<void> onTapTimeEnd(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Access the state using ref.watch()
      final notifierState = ref.watch(addRouteTwoNotifier);

      // Update the setTime in your notifierState
      ref.read(addRouteTwoNotifier.notifier).state = notifierState.copyWith(
          setTime: pickedTime); // Update with the pickedTime

      // Format the pickedTime as needed (e.g., 'HH:mm')
      final formattedTime =
          "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
      ref.watch(addRouteTwoNotifier).setTimeController?.text = formattedTime;
    }
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

  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }
}
