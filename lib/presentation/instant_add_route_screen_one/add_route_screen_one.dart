import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import '../../core/utils/app_toast.dart';
import '../../data/services/mobility_api_service.dart';
import '../route_settings_bottomsheet/add_route_three_bottomsheet.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/loading_dialog.dart';
import 'models/add_route_one_item_model.dart';
import 'notifier/add_route_one_notifier.dart';
import 'widgets/places_autocomplete_field.dart';

// ignore for file, class must be immutable
class AddRouteScreenOne extends ConsumerStatefulWidget {
  const AddRouteScreenOne({super.key});

  @override
  AddRouteScreenOneState createState() => AddRouteScreenOneState();
}

class AddRouteScreenOneState extends ConsumerState<AddRouteScreenOne> {
  final MobilityApiService _mobilityApiService = MobilityApiService();
  bool _isCreatingRoute = false;

  @override
  void initState() {
    super.initState();
    final notifierState = ref.read(addRouteOneNotifier);
    notifierState.locationController?.addListener(_refreshFormState);
    notifierState.destinationController?.addListener(_refreshFormState);
    notifierState.stopController?.addListener(_refreshFormState);
    notifierState.setTimeController?.addListener(_refreshFormState);
  }

  void _refreshFormState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    final notifierState = ref.read(addRouteOneNotifier);
    notifierState.locationController?.removeListener(_refreshFormState);
    notifierState.destinationController?.removeListener(_refreshFormState);
    notifierState.stopController?.removeListener(_refreshFormState);
    notifierState.setTimeController?.removeListener(_refreshFormState);
    super.dispose();
  }

  String _mapPlanType(String title) {
    final normalized = title.toLowerCase();
    switch (normalized) {
      case 'ride':
      case 'ride-sharing':
        return 'ride';
      case 'delivery':
        return 'delivery';
      default:
        return 'hybrid';
    }
  }

  String _deriveSearchRequestType(String title) {
    final normalized = title.toLowerCase();
    if (normalized.contains('ride')) {
      return 'ride';
    }
    if (normalized.contains('delivery')) {
      return 'delivery';
    }
    return 'delivery';
  }

  String _mapVehicleType(String title) {
    switch (title.toLowerCase()) {
      case 'bike':
        return 'bike';
      case 'car':
        return 'car';
      case 'truck':
        return 'truck';
      case 'bus':
        return 'bus';
      case 'train':
        return 'train';
      case 'airplane':
        return 'airplane';
      case 'public':
        return 'public_transit';
      default:
        return title.toLowerCase().replaceAll(' ', '_');
    }
  }

  Future<void> createRoute(BuildContext context) async {
    if (_isCreatingRoute) {
      return;
    }

    final notifierState = ref.read(addRouteOneNotifier);

    // Validate that coordinates are selected
    if (notifierState.locationLat == null ||
        notifierState.locationLng == null ||
        notifierState.destinationLat == null ||
        notifierState.destinationLng == null) {
      AppToast.info(
        "Please select locations from the suggestions to get coordinates.",
      );
      return;
    }

    final now = DateTime.now();
    final pickedTime = notifierState.setTimeController?.text.split(':');
    final departureDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.tryParse(pickedTime?[0] ?? '0') ?? 0,
      int.tryParse(pickedTime?[1] ?? '0') ?? 0,
    ).toUtc();

    // Format to YYYY-MM-DDTHH:MM:SSZ to match the working example exactly

    setState(() {
      _isCreatingRoute = true;
    });
    if (context.mounted) {
      LoadingDialog.show(context, message: 'Creating route...');
    }

    try {
      final selectedTransportMode =
          notifierState.addRouteOneModelObj?.transportMeansList
              .firstWhere(
                (item) => item.isSelected,
                orElse: () => AddRouteOneItemModel(),
              )
              .meansTitle;

      final selectedServiceTitle =
          notifierState.serviceTypeDropDownValue?.title ?? '';
      final routeData = await _mobilityApiService.createTravelPlan(
        title:
            '${notifierState.locationController?.text ?? 'Current location'} to ${notifierState.destinationController?.text ?? 'Destination'}',
        planType: _mapPlanType(selectedServiceTitle),
        originName: notifierState.locationController?.text ?? '',
        originLatitude: notifierState.locationLat,
        originLongitude: notifierState.locationLng,
        destinationName: notifierState.destinationController?.text ?? '',
        destinationLatitude: notifierState.destinationLat,
        destinationLongitude: notifierState.destinationLng,
        departureTime: departureDateTime,
        vehicleType: _mapVehicleType(selectedTransportMode ?? ''),
        metadata: {
          'route_kind': 'instant',
          if (notifierState.stopController?.text.isNotEmpty == true)
            'stop_location': notifierState.stopController?.text,
          if (notifierState.stopController?.text.isNotEmpty == true)
            'stop_location_latitude': notifierState.stopLat,
          if (notifierState.stopController?.text.isNotEmpty == true)
            'stop_location_longitude': notifierState.stopLng,
        },
      );

      AppToast.success('Route created successfully.');
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.homeOneScreen,
          (route) => false,
          arguments: {
            'showDialog': false,
            'locationLat': notifierState.locationLat,
            'locationLng': notifierState.locationLng,
            'destinationLat': notifierState.destinationLat,
            'destinationLng': notifierState.destinationLng,
            'destinationName': notifierState.destinationController?.text,
            'highlightRoute': true,
            'autoEnableLive': true,
            'autoEnableLiveRouteId': routeData['id']?.toString(),
            'searchNearbyMovers': true,
            'searchRequestType': _deriveSearchRequestType(selectedServiceTitle),
            'searchRequestData': routeData,
          },
        );
      }
    } catch (e) {
      AppToast.error(_mobilityApiService.extractErrorMessage(e));
    } finally {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
      if (mounted) {
        setState(() {
          _isCreatingRoute = false;
        });
      }
    }
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
          CustomAppBar(
            height: 60.h,
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
              Consumer(builder: (context, ref, _) {
                return AppbarTrailingImage(
                  imagePath: ImageConstant.imgPlusBlack,
                  onTap: () {
                    ref.read(addRouteOneNotifier.notifier).toggleStopField();
                  },
                );
              }),
              AppbarTrailingImage(
                imagePath: ImageConstant.imgSetting,
                margin: EdgeInsets.only(
                  left: 22.h,
                  right: 15.h,
                ),
                onTap: () {
                  AppBottomSheet.show(
                      context: context,
                      builder: (_) => AddRouteThreeBottomsheet(),
                      isScrollControlled: true);
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
                    final state = ref.watch(addRouteOneNotifier);
                    return PlacesAutocompleteField(
                      controller: state.locationController,
                      hintText: "Enter your location",
                      radioValue: "location",
                      suffixIcon: ImageConstant.imgLocationPrimary,
                      onSuffixTap: () {
                        ref
                            .read(addRouteOneNotifier.notifier)
                            .fetchCurrentLocation();
                      },
                      onRadioChange: () {
                        ref
                            .read(addRouteOneNotifier.notifier)
                            .changeRadioBtn("location");
                      },
                      onPlaceSelected: (description, lat, lng) {
                        ref
                            .read(addRouteOneNotifier.notifier)
                            .setLocationCoordinates(lat, lng);
                      },
                    );
                  },
                ),
                SizedBox(height: 16.h),
                Consumer(
                  builder: (context, ref, _) {
                    final state = ref.watch(addRouteOneNotifier);
                    return PlacesAutocompleteField(
                      controller: state.destinationController,
                      hintText: "Enter your destination",
                      radioValue: "destination",
                      onRadioChange: () {
                        ref
                            .read(addRouteOneNotifier.notifier)
                            .changeRadioBtn("destination");
                      },
                      onPlaceSelected: (description, lat, lng) {
                        ref
                            .read(addRouteOneNotifier.notifier)
                            .setDestinationCoordinates(lat, lng);
                      },
                    );
                  },
                ),
                if (ref.watch(addRouteOneNotifier).showStopField) ...[
                  SizedBox(height: 16.h),
                  Consumer(
                    builder: (context, ref, _) {
                      final state = ref.watch(addRouteOneNotifier);
                      return PlacesAutocompleteField(
                        controller: state.stopController,
                        hintText: "Add stop",
                        radioValue: "stop",
                        showCloseButton: true,
                        onRadioChange: () {
                          ref
                              .read(addRouteOneNotifier.notifier)
                              .changeRadioBtn("stop");
                        },
                        onClose: () {
                          ref
                              .read(addRouteOneNotifier.notifier)
                              .toggleStopField();
                        },
                        onPlaceSelected: (description, lat, lng) {
                          ref
                              .read(addRouteOneNotifier.notifier)
                              .setStopCoordinates(lat, lng);
                        },
                      );
                    },
                  ),
                ],
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
                        textStyle: theme.textTheme.bodySmall
                            ?.copyWith(color: appTheme.black900),
                        iconSize: 16.h,
                        hintText: "Type of service",
                        hintStyle: CustomTextStyles.bodySmallGray80001!
                            .copyWith(color: appTheme.gray600),
                        items: ref
                                .watch(addRouteOneNotifier)
                                .addRouteOneModelObj
                                ?.serviceTypeDropdown
                                .map((item) => item.title)
                                .toList() ??
                            [],
                        contentPadding: EdgeInsets.all(14.h),
                        borderDecoration: DropDownStyleHelper.outlineBlueGray,
                        onChanged: (value) {
                          final selectedService = ref
                              .watch(addRouteOneNotifier)
                              .addRouteOneModelObj
                              ?.serviceTypeDropdown
                              .firstWhere((item) => item.title == value);
                          if (selectedService != null) {
                            ref
                                .read(addRouteOneNotifier.notifier)
                                .selectServiceType(selectedService);
                          }
                        },
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
                        hintStyle: CustomTextStyles.bodySmallGray80001!
                            .copyWith(color: appTheme.gray40001),
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
          Consumer(
            builder: (context, ref, _) {
              ref.watch(addRouteOneNotifier);
              return _buildAddRouteButton(context);
            },
          )
        ],
      ),
    );
  }

  Widget _buildAddRouteButton(BuildContext context) {
    final notifierState = ref.read(addRouteOneNotifier);
    final isTransportModeSelected = notifierState
            .addRouteOneModelObj?.transportMeansList
            .any((item) => item.isSelected) ??
        false;
    final isEnabled =
        notifierState.locationController?.text.isNotEmpty == true &&
            notifierState.destinationController?.text.isNotEmpty == true &&
            isTransportModeSelected &&
            notifierState.serviceTypeDropDownValue?.title.isNotEmpty == true &&
            notifierState.setTimeController?.text.isNotEmpty == true;

    return CustomElevatedButton(
      text: "Add route",
      loadingText: "Creating route...",
      buttonStyle: isEnabled
          ? CustomButtonStyles.fillPrimaryTL41
          : CustomButtonStyles.fillBlueGray,
      isLoading: _isCreatingRoute,
      onPressed: isEnabled && !_isCreatingRoute
          ? () {
              createRoute(context);
            }
          : null,
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
                  onPrimary: theme.colorScheme.onPrimary,
                  onSurface: appTheme.black900,
                ),
            timePickerTheme: TimePickerThemeData(
              hourMinuteColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primary.withValues(alpha: 0.1)),
              hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary),
              dayPeriodColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? theme.colorScheme.primary
                      : Colors.transparent),
              dayPeriodTextColor: WidgetStateColor.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary),
              dayPeriodBorderSide: BorderSide(color: theme.colorScheme.primary),
              dialHandColor: theme.colorScheme.primary,
              dialBackgroundColor:
                  theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final formattedTime =
          "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
      ref.read(addRouteOneNotifier.notifier).updateTimeField(formattedTime);
    }
  }
}
