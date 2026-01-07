import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/app_export.dart';
import '../route_settings_bottomsheet/add_route_three_bottomsheet.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/add_route_one_item_model.dart';
import 'notifier/add_route_one_notifier.dart';

// ignore for file, class must be immutable
class AddRouteScreenOne extends ConsumerStatefulWidget {
  const AddRouteScreenOne({super.key});

  @override
  AddRouteScreenOneState createState() => AddRouteScreenOneState();
}

class AddRouteScreenOneState extends ConsumerState<AddRouteScreenOne> {
  TextEditingController locationController = TextEditingController();
  TextEditingController stopController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

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

    final notifierState = ref.read(addRouteOneNotifier);
    final url =
        Uri.parse('https://demosystem.pythonanywhere.com/create-route/');
    final requestBody = {
      "location": notifierState.radioGroup,
      "destination": destinationController.text,
      "transportation_mode":
          notifierState.addRouteOneModelObj?.transportMeansList
              .firstWhere(
                (item) => item.isSelected,
                orElse: () => AddRouteOneItemModel(),
              )
              .meansTitle,
      "service_type": notifierState.serviceTypeDropDownValue?.title,
      "departure_time": notifierState.setTimeController
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

  bool _isAddRouteButtonEnabled() {
    final notifierState = ref.watch(addRouteOneNotifier);
    //Check if at least one transport mode is selected.
    final isTransportModeSelected = notifierState.addRouteOneModelObj?.transportMeansList.any((item) => item.isSelected) ?? false;

    return locationController.text.isNotEmpty &&
        destinationController.text.isNotEmpty &&
        isTransportModeSelected &&
        notifierState.serviceTypeDropDownValue?.title.isNotEmpty == true &&
        notifierState.setTimeController!.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              _buildAddrouteone(context),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildColumnmeansof(context),
                    SizedBox(height: 22.h),
                    _buildColumnnumberof(context),
                    SizedBox(height: 4.h)
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: _buildButtonnav(context),
      ),
    );
  }

  // Section Widget
  Widget _buildAddrouteone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(
        // top: 24.h,
        bottom: 22.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 1),
        border: Border(
          bottom: BorderSide(
            color: appTheme.gray20001,
            width: 1.h,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withValues(alpha: 0.08),
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
              ),
              AppbarTrailingImage(
                imagePath: ImageConstant.imgSetting,
                margin: EdgeInsets.only(
                  left: 22.h,
                  right: 15.h,
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => AddRouteThreeBottomsheet(),
                    isScrollControlled: true
                  );
                },
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
                      controller: locationController,
                      hintText: "Enter your location",
                      borderDecoration: TextFormFieldStyleHelper.outlineGray1,
                      onTap: () {
                        ref
                            .read(addRouteOneNotifier.notifier)
                            .changeRadioButton('location');
                      },
                    );
                  },
                ),
                SizedBox(height: 16.h),
                Consumer(
                  builder: (context, ref, _) {
                    return CustomTextFormField(
                      controller: stopController,
                      hintText: "Add Stop",
                      borderDecoration: TextFormFieldStyleHelper.outlineGray1,
                      onTap: () {
                        ref
                            .read(addRouteOneNotifier.notifier)
                            .changeRadioButton('stop');
                      },
                    );
                  },
                ),
                SizedBox(height: 16.h),
                Consumer(
                  builder: (context, ref, _) {
                    return CustomTextFormField(
                      controller: destinationController,
                      hintText: "Enter your destination",
                      borderDecoration: TextFormFieldStyleHelper.outlineGray1,
                      onTap: () {
                        ref
                            .read(addRouteOneNotifier.notifier)
                            .changeRadioButton('destination');
                      },
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
  // Widget _buildColumnmeansof(BuildContext context){
  //   return Container(
  //     width: double.maxFinite,
  //     margin: EdgeInsets.only(left: 16.h),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //           width: double.maxFinite,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Means of transportation",
  //                 style: theme.textTheme.labelLarge,
  //               )
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: 12.h),
  //         Container(
  //           child: Consumer(
  //             builder: (context, ref, _) {
  //               return SingleChildScrollView(
  //                 scrollDirection: Axis.horizontal,
  //                 child: Wrap(
  //                   direction: Axis.horizontal,
  //                   spacing: 14.h,
  //                   children: List.generate(
  //                     ref.watch(addRouteOneNotifier).addRouteOneModelObj?.transportMeansList.length ?? 0, (index) {
  //                       AddRouteOneItemModel model = ref.watch(addRouteOneNotifier).addRouteOneModelObj?.transportMeansList[index] ?? AddRouteOneItemModel();
  //                       return AddRouteOneItemWidget(model);
  //                     },
  //                   ),
  //                 ),
  //               );
  //             }
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

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
                      .watch(addRouteOneNotifier)
                      .addRouteOneModelObj
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
                            .read(addRouteOneNotifier.notifier)
                            .selectTransportMode(index);
                      },
                      child: Container(
                        width: 100.h,
                        padding: EdgeInsets.all(15.h),
                        margin: EdgeInsets.only(right: 25.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withValues(alpha: 0.1)
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomImageView(
                              imagePath: mode.meansImage ?? '',
                              height: 40.h,
                              width: 40.h,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              mode.meansTitle ?? '',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : appTheme.gray600,
                              ),
                              textAlign: TextAlign.center,
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
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Type of service",
                      style: theme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 4.h),
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
                        textStyle: theme.textTheme.bodySmall?.copyWith(color: appTheme.black900),
                        iconSize: 16.h,
                        hintText: "Type of service",
                        hintStyle: CustomTextStyles.bodySmallGray80001!.copyWith(color: appTheme.gray600),
                        items: ref
                                .watch(addRouteOneNotifier)
                                .addRouteOneModelObj
                                ?.serviceTypeDropdown
                                .map((item) => item.title)
                                .toList() ??
                            [],
                        contentPadding: EdgeInsets.all(14.h),
                        borderDecoration: DropDownStyleHelper.outlineBlueGray,
                      );
                    })
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Departure",
                      style: theme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 10.h),
                    Consumer(builder: (context, ref, _) {
                      return CustomTextFormField(
                        readOnly: true,
                        controller:
                            ref.watch(addRouteOneNotifier).setTimeController,
                        hintText: "Set time",
                        hintStyle: CustomTextStyles.bodySmallGray80001!.copyWith(color: appTheme.gray40001),
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
                    })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildButtonnav(BuildContext context) {
    return Container(
      height: 98.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 22.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 1),
        border: Border(
          top: BorderSide(
            color: appTheme.gray20001,
            width: 1.h,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // CustomElevatedButton(
          //   text: "Add route",
          //   buttonStyle: _isAddRouteButtonEnabled() ? null : CustomButtonStyles.fillBlueGray,
          //   onPressed: _isAddRouteButtonEnabled() ? () {
          //     createRoute(context);
          //   } : null,
          // )
          CustomElevatedButton(
            text: "Add route",
            buttonStyle: CustomButtonStyles.fillBlueGray,
            onPressed: () {
              NavigatorService.pushNamed(AppRoutes.homeOneScreen);
            }
          )
        ],
      ),
    );
  }

  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }

  // Displays a date picker dialog and updates the selected date in the [addRouteTwoModelObj] object of the current [setTimeController] if the user selects a valid date.
  // This function returns a `Future` that completes with `void`.
  Future<void> onTapTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: theme.colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      // Access the state using ref.watch()
      final notifierState = ref.watch(addRouteOneNotifier);

      ref.read(addRouteOneNotifier.notifier).state = notifierState.copyWith(
          setTime: pickedTime); // Update with the pickedTime

      // Format the pickedTime as needed (e.g., 'HH:mm')
      final formattedTime =
          "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
      ref.watch(addRouteOneNotifier).setTimeController?.text = formattedTime;
    }
  }
}
