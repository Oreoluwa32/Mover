import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/app_toast.dart';
import '../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../data/services/mobility_api_service.dart';
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

// ignore for file, class must be immutable
class AddRouteScreenOne extends ConsumerStatefulWidget {
  const AddRouteScreenOne({super.key});

  @override
  AddRouteScreenOneState createState() => AddRouteScreenOneState();
}

class AddRouteScreenOneState extends ConsumerState<AddRouteScreenOne> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final MobilityApiService _mobilityApiService = MobilityApiService();
  bool _isCreatingRoute = false;

  String _mapPlanType(String title) {
    switch (title.toLowerCase()) {
      case 'ride sharing':
      case 'ride':
      case 'ride-sharing':
        return 'ride';
      case 'delivery':
        return 'delivery';
      default:
        return 'hybrid';
    }
  }

  String _mapVehicleType(String title) {
    switch (title.toLowerCase()) {
      case 'bike':
        return 'bike';
      case 'car':
        return 'car';
      case 'bus':
        return 'bus';
      case 'train':
        return 'train';
      case 'airplane':
        return 'airplane';
      case 'public':
        return 'public_transit';
      case 'truck':
        return 'truck';
      default:
        return title.toLowerCase().replaceAll(' ', '_');
    }
  }

  SelectionPopupModel? _resolveSelectedOption(
    SelectionPopupModel? explicit,
    List<SelectionPopupModel> options,
  ) {
    if ((explicit?.title ?? '').trim().isNotEmpty) {
      return explicit;
    }
    for (final option in options) {
      if (option.isSelected == true) {
        return option;
      }
    }
    return options.isNotEmpty ? options.first : null;
  }

  DateTime _buildDepartureTime(String? rawTime) {
    final normalized = (rawTime ?? '').trim().toLowerCase();
    final match =
        RegExp(r'^(\d{1,2}):(\d{2})\s*([ap]m)$').firstMatch(normalized);
    final now = DateTime.now();
    if (match == null) {
      return now.toUtc();
    }

    var hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final period = match.group(3)!;

    if (period == 'pm' && hour != 12) {
      hour += 12;
    } else if (period == 'am' && hour == 12) {
      hour = 0;
    }

    var departure = DateTime(now.year, now.month, now.day, hour, minute);
    if (departure.isBefore(now)) {
      departure = departure.add(const Duration(days: 1));
    }
    return departure.toUtc();
  }

  Future<void> createRoute(BuildContext context) async {
    if (_isCreatingRoute) {
      return;
    }

    final notifierState = ref.read(addRouteOneNotifier);
    final location = locationController.text.trim();
    final destination = destinationController.text.trim();
    final selectedTransportMode =
        notifierState.addRouteOneModelObj?.transportMeansList
            .firstWhere(
              (item) => item.isSelected,
              orElse: () => AddRouteOneItemModel(),
            )
            .meansTitle;
    final selectedService = _resolveSelectedOption(
      notifierState.serviceTypeDropDownValue,
      notifierState.addRouteOneModelObj?.serviceTypeDropdown ?? const [],
    );
    final selectedDeparture = _resolveSelectedOption(
      notifierState.departureDropDownValue,
      notifierState.addRouteOneModelObj?.departureDropdown ?? const [],
    );

    if (location.isEmpty || destination.isEmpty) {
      AppToast.info('Please enter both route locations first.');
      return;
    }
    if ((selectedTransportMode ?? '').trim().isEmpty) {
      AppToast.info('Please choose a means of transportation.');
      return;
    }
    if ((selectedService?.title ?? '').trim().isEmpty) {
      AppToast.info('Please choose a service type.');
      return;
    }
    if ((selectedDeparture?.title ?? '').trim().isEmpty) {
      AppToast.info('Please choose a departure time.');
      return;
    }

    setState(() {
      _isCreatingRoute = true;
    });
    if (context.mounted) {
      LoadingDialog.show(context, message: 'Creating route...');
    }

    try {
      await _mobilityApiService.createTravelPlan(
        title: '$location to $destination',
        planType: _mapPlanType(selectedService!.title),
        originName: location,
        destinationName: destination,
        departureTime: _buildDepartureTime(selectedDeparture!.title),
        vehicleType: _mapVehicleType(selectedTransportMode ?? ''),
        metadata: {
          'route_kind': 'scheduled_legacy',
          'display_departure_time': selectedDeparture.title,
        },
      );
      AppToast.success('Route created successfully.');
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.homeOneScreen,
          (route) => false,
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
  void dispose() {
    locationController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
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
    );
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
                          children: [
                            CustomImageView(
                              imagePath: mode.meansImage ?? '',
                              height: 40.h,
                              width: 40.h,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              mode.meansTitle ?? '',
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
                          final selected = ref
                              .read(addRouteOneNotifier)
                              .addRouteOneModelObj
                              ?.serviceTypeDropdown
                              .firstWhere((item) => item.title == value);
                          if (selected != null) {
                            ref
                                .read(addRouteOneNotifier.notifier)
                                .selectServiceType(selected);
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
                        hintText: "Set Time",
                        hintStyle: CustomTextStyles.bodySmallGray80001!
                            .copyWith(color: appTheme.gray600),
                        items: ref
                                .watch(addRouteOneNotifier)
                                .addRouteOneModelObj
                                ?.departureDropdown
                                .map((item) => item.title)
                                .toList() ??
                            [],
                        prefix: Container(
                          margin: EdgeInsets.fromLTRB(14.h, 16.h, 12.h, 16.h),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgClock,
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
                        onChanged: (value) {
                          final selected = ref
                              .read(addRouteOneNotifier)
                              .addRouteOneModelObj
                              ?.departureDropdown
                              .firstWhere((item) => item.title == value);
                          if (selected != null) {
                            ref
                                .read(addRouteOneNotifier.notifier)
                                .selectDepartureTime(selected);
                          }
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
        vertical: 24.h,
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
          CustomElevatedButton(
            text: "Add route",
            loadingText: "Creating route...",
            buttonStyle: CustomButtonStyles.fillBlueGray,
            isLoading: _isCreatingRoute,
            onPressed: _isCreatingRoute
                ? null
                : () {
                    createRoute(context);
                  },
          )
        ],
      ),
    );
  }
}
