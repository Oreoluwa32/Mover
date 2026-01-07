import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import '../../core/utils/date_time_utils.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/days_item_model.dart';
import 'notifier/set_date_notifier.dart';
import 'widgets/chipviewone_item_widget.dart';
import 'widgets/custom_date_picker.dart';
import '../add_route_screen_three/notifier/add_route_two_notifier.dart'; //ignore for file, class must be immutable

class SetDateBottomsheet extends ConsumerStatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const SetDateBottomsheet({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  SetDateBottomsheetState createState() => SetDateBottomsheetState();
}

class SetDateBottomsheetState extends ConsumerState<SetDateBottomsheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = ref.read(setDateNotifier);
      
      if (widget.initialStartDate != null) {
        currentState.setDateModelObj?.startDate = widget.initialStartDate;
        currentState.startDateController?.text =
            widget.initialStartDate!.format(pattern: dateTimeFormatPattern);
      }
      
      if (widget.initialEndDate != null) {
        currentState.setDateModelObj?.endDate = widget.initialEndDate;
        currentState.endDateController?.text =
            widget.initialEndDate!.format(pattern: dateTimeFormatPattern);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary.withValues(alpha: 1),
          borderRadius: BorderRadiusStyle.customBorderTL24,
        ),
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: _buildBodyContent(context),
                ),
              ),
            ),
            _buildBottomActions(context),
          ],
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildDate(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          readOnly: true,
          controller: ref.watch(setDateNotifier).startDateController,
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
          prefixConstraints: BoxConstraints(maxHeight: 50.h),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.h,
            vertical: 16.h,
          ),
          onTap: () {
            onTapStartDate(context);
          },
        );
      },
    );
  }

  // Section Widget
  Widget _buildOnetwo(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          width: 50.h,
          controller: ref.watch(setDateNotifier).numberController,
          textInputType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.h,
            vertical: 16.h,
          )
        );
      },
    );
  }

  // Section Widget
  Widget _buildDateone(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          readOnly: true,
          controller: ref.watch(setDateNotifier).endDateController,
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
          prefixConstraints: BoxConstraints(maxHeight: 50.h),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.h,
            vertical: 16.h,
          ),
          onTap: () {
            onTapEndDate(context);
          },
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.h,
        top: 16.h,
        right: 16.h,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 50.h,
              child: const Divider(),
            ),
          ),
          SizedBox(height: 14.h),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Set date",
              style: CustomTextStyles.titleMediumBlack900,
            ),
          ),
          SizedBox(height: 14.h),
        ],
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Start date",
                style: CustomTextStyles.labelLargeGray600,
              ),
              SizedBox(height: 4.h),
              _buildDate(context)
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "Repeat every",
          style: CustomTextStyles.labelLargeGray600,
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.maxFinite,
          child: Row(
            children: [
              _buildOnetwo(context),
              SizedBox(width: 16.h),
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
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
                      hintText: "Week",
                      hintStyle: CustomTextStyles.bodySmallErrorContainer,
                      items: ref
                              .watch(setDateNotifier)
                              .setDateModelObj
                              ?.repeatDropdown
                              .map((item) => item.title)
                              .toList() ??
                          [],
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.h,
                        vertical: 16.h,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
            width: double.maxFinite,
            margin: EdgeInsets.only(
              left: 14.h,
              right: 18.h,
            ),
            child: Consumer(builder: (context, ref, _) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  direction: Axis.horizontal,
                  runSpacing: 10.h,
                  spacing: 10.h,
                  children: List<Widget>.generate(
                      ref
                              .watch(setDateNotifier)
                              .setDateModelObj
                              ?.daysOfWeek
                              .length ??
                          0, (index) {
                    DaysItemModel model = ref
                            .watch(setDateNotifier)
                            .setDateModelObj
                            ?.daysOfWeek[index] ??
                        DaysItemModel();
                    return ChipviewoneItemWidget(
                      model,
                      onSelectedDay: (value) {
                        ref
                            .read(setDateNotifier.notifier)
                            .onSelectedDays(index, value);
                      },
                    );
                  }),
                ),
              );
            })),
        SizedBox(height: 14.h),
        SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "End date",
                style: CustomTextStyles.labelLargeGray600,
              ),
              SizedBox(height: 4.h),
              _buildDateone(context)
            ],
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          "Occurs every Monday through Friday",
          style: CustomTextStyles.labelLargeErrorContainer,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  // Section Widget
  Widget _buildSave(BuildContext context) {
    return CustomElevatedButton(
      text: "Save",
      onPressed: () {
        final startDate = ref.watch(setDateNotifier).setDateModelObj?.startDate;
        final endDate = ref.watch(setDateNotifier).setDateModelObj?.endDate;

        if (startDate == null || endDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select both start and end dates')),
          );
          return;
        }

        final dateRangeText =
            '${startDate.format(pattern: dateTimeFormatPattern)} - ${endDate.format(pattern: dateTimeFormatPattern)}';
        
        ref.read(addRouteTwoNotifier).setDateController?.text = dateRangeText;
        
        Navigator.pop(context);
      },
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.h,
        right: 16.h,
        bottom: 20.h,
      ),
      child: Column(
        children: [
          SizedBox(height: 15.h,),
          _buildSave(context),
          SizedBox(height: 22.h),
          GestureDetector(
            child: Text(
              "Cancel",
              style: CustomTextStyles.titleSmallErrorContainer,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // Displays a date picker dialog and updates the selected date in the [setDateModelObj] object of the current [startDateController] if the user selects a valid date.
  // This function returns a `Future` that completes with `void`.
  Future<void> onTapStartDate(BuildContext context) async {
    final today = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final maxDate = DateTime(today.year + 2, today.month, today.day);
    DateTime? dateTime = await showDialog<DateTime>(
      context: context,
      builder: (context) => CustomDatePicker(
        initialDate: ref.watch(setDateNotifier).setDateModelObj!.startDate ??
            today,
        firstDate: today,
        lastDate: maxDate,
      ),
    );
    if (dateTime != null) {
      ref.watch(setDateNotifier).setDateModelObj!.startDate = dateTime;
      ref.watch(setDateNotifier).startDateController?.text =
          dateTime.format(pattern: dateTimeFormatPattern);
    }
  }

  // Displays a date picker dialog and updates the selected date in the [setDateModelObj] object of the current [endDateController] if the user selects a valid date.
  // This function returns a `Future` that completes with `void`.
  Future<void> onTapEndDate(BuildContext context) async {
    final startDate = ref.watch(setDateNotifier).setDateModelObj!.startDate ??
        DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final maxDate = DateTime(startDate.year + 2, startDate.month, startDate.day);
    DateTime? dateTime = await showDialog<DateTime>(
      context: context,
      builder: (context) => CustomDatePicker(
        initialDate: ref.watch(setDateNotifier).setDateModelObj!.endDate ??
            startDate,
        firstDate: startDate,
        lastDate: maxDate,
      ),
    );
    if (dateTime != null) {
      ref.watch(setDateNotifier).setDateModelObj!.endDate = dateTime;
      ref.watch(setDateNotifier).endDateController?.text =
          dateTime.format(pattern: dateTimeFormatPattern);
    }
  }
}
