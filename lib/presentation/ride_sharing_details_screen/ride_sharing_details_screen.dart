import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../data/services/mobility_api_service.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../delivery_details_screen/widgets/places_autocomplete_field.dart';
import 'notifier/ride_sharing_details_notifier.dart';

class RideSharingDetailsScreen extends ConsumerStatefulWidget {
  const RideSharingDetailsScreen({Key? key}) : super(key: key);

  @override
  RideSharingDetailsScreenState createState() => RideSharingDetailsScreenState();
}

class RideSharingDetailsScreenState
    extends ConsumerState<RideSharingDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MobilityApiService _mobilityApiService = MobilityApiService();

  Future<void> _submitRideRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notifier = ref.read(rideSharingDetailsNotifier.notifier);
    final state = ref.read(rideSharingDetailsNotifier);

    try {
      final requestData = await _mobilityApiService.createRideRequest(
        originName: state.originController?.text.trim() ?? '',
        originLatitude: state.originLatitude,
        originLongitude: state.originLongitude,
        destinationName: state.destinationController?.text.trim() ?? '',
        destinationLatitude: state.destinationLatitude,
        destinationLongitude: state.destinationLongitude,
        scheduledTime: DateTime.now(),
        seatsRequested: notifier.selectedPassengers,
      );

      Fluttertoast.showToast(msg: "Ride request sent");
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.homeOneScreen,
        (route) => false,
        arguments: {
          'autoEnableLive': true,
          'searchNearbyMovers': true,
          'searchRequestType': 'ride',
          'searchRequestData': requestData,
        },
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: _mobilityApiService.extractErrorMessage(error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: _buildAppbar(context),
      body: Form(
        key: _formKey,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(left: 16.h, right: 16.h),
                child: Column(
                  children: [
                    _buildLocation(context),
                    SizedBox(height: 22.h),
                    _buildPassengers(context),
                    SizedBox(height: 4.h),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildButtonnav(context),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 60.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeft,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(text: "Share a ride"),
      styleType: Style.bgOutline,
    );
  }

  Widget _buildLocation(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(rideSharingDetailsNotifier);
              return PlacesAutocompleteField(
                controller: state.originController,
                hintText: "Current location",
                radioValue: "origin",
                groupValue: state.radioGroup,
                onRadioChange: () {
                  ref.read(rideSharingDetailsNotifier.notifier).changeRadioBtn("origin");
                },
                onChanged: (value) {
                  ref.read(rideSharingDetailsNotifier.notifier).onOriginChange(value);
                },
                onPlaceSelected: (description, lat, lng) {
                  ref
                      .read(rideSharingDetailsNotifier.notifier)
                      .setOriginLocation(description, lat, lng);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your pickup location";
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.my_location,
                    color: theme.colorScheme.primary,
                    size: 20.h,
                  ),
                  onPressed: () {
                    ref.read(rideSharingDetailsNotifier.notifier).getCurrentLocation();
                  },
                ),
              );
            },
          ),
          SizedBox(height: 16.h),
          Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(rideSharingDetailsNotifier);
              return PlacesAutocompleteField(
                controller: state.destinationController,
                hintText: "Destination",
                radioValue: "destination",
                groupValue: state.radioGroup,
                onRadioChange: () {
                  ref
                      .read(rideSharingDetailsNotifier.notifier)
                      .changeRadioBtn("destination");
                },
                onChanged: (value) {
                  ref
                      .read(rideSharingDetailsNotifier.notifier)
                      .updateDestination(value);
                },
                onPlaceSelected: (description, lat, lng) {
                  ref
                      .read(rideSharingDetailsNotifier.notifier)
                      .setDestinationLocation(description, lat, lng);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your destination";
                  }
                  return null;
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPassengers(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Number of passenger",
            style: CustomTextStyles.labelLargeGray600,
          ),
          SizedBox(height: 4.h),
          Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(rideSharingDetailsNotifier);
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
                hintText: state.selectedDropDownValue?.title ?? "Select number of passenger",
                items: state.rideSharingDetailsModelObj?.dropdownItemList
                        .map((item) => item.title)
                        .toList() ??
                    [],
                prefix: Container(
                  margin: EdgeInsets.fromLTRB(14.h, 14.h, 12.h, 14.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgOneUser,
                    height: 16.h,
                    width: 16.h,
                    fit: BoxFit.contain,
                  ),
                ),
                prefixConstraints: BoxConstraints(maxHeight: 46.h),
                contentPadding: EdgeInsets.all(14.h),
                onChanged: (value) {
                  ref
                      .read(rideSharingDetailsNotifier.notifier)
                      .updatePassengerCount(value);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButtonnav(BuildContext context) {
    return Container(
      height: 98.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 22.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 1),
        border: Border(
          top: BorderSide(color: appTheme.gray20001, width: 1.h),
        ),
      ),
      child: Consumer(
        builder: (context, ref, _) {
          ref.watch(rideSharingDetailsNotifier);
          final isComplete =
              ref.read(rideSharingDetailsNotifier.notifier).isFormComplete;
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomElevatedButton(
                text: "Find Mover",
                isDisabled: !isComplete,
                buttonStyle: isComplete
                    ? CustomButtonStyles.fillPrimaryTL41
                    : CustomButtonStyles.fillBlueGray,
                onPressed: isComplete ? _submitRideRequest : null,
              ),
            ],
          );
        },
      ),
    );
  }

  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }
}
