import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/date_time_utils.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'notifier/move_one_notifier.dart'; //ignore for file, class must be immutable

class ScheduleMoveBottomsheetOne extends ConsumerStatefulWidget {
  const ScheduleMoveBottomsheetOne({Key? key}) : super(key: key);

  @override
  ScheduleMoveBottomsheetOneState createState() =>
      ScheduleMoveBottomsheetOneState();
}

class ScheduleMoveBottomsheetOneState
    extends ConsumerState<ScheduleMoveBottomsheetOne> {
  @override
  Widget build(BuildContext context) {
    return _buildScrollView(context);
  }

  // Section Widget
  Widget _buildScrollView(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(left: 16.h, top: 16.h, right: 16.h),
          decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withOpacity(1),
              borderRadius: BorderRadiusStyle.customBorderTL24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 50.h,
                child: Divider(),
              ),
              SizedBox(
                height: 24.h,
              ),
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Departure Details",
                              style: theme.textTheme.titleSmall,
                            ),
                          ),
                          CustomImageView(
                            imagePath: ImageConstant.imgCancel,
                            height: 24.h,
                            width: 24.h,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Consumer(
                      builder: (context, ref, _) {
                        return CustomTextFormField(
                          readOnly: true,
                          controller: ref.watch(moveOneNotifier).dateController,
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
                            onTapDate(context);
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Consumer(
                      builder: (context, ref, _) {
                        return CustomTextFormField(
                          readOnly: true,
                          controller: ref.watch(moveOneNotifier).timeController,
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
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              CustomElevatedButton(
                text: "Confirm",
                buttonStyle: CustomButtonStyles.fillBlueGray,
              ),
              SizedBox(
                height: 8.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Displays a date picker dialog and updates the selected date in the [moveOneModelObj] object of the current [dateController] if the user selects a valid date
  // This function return a `Future` that cmpletes with `void`
  Future<void> onTapDate(BuildContext context) async {
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: ref.watch(moveOneNotifier).moveOneModelObj!.selectedDate ??
            DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));
    if (dateTime != null) {
      ref.watch(moveOneNotifier).moveOneModelObj!.selectedDate = dateTime;
      ref.watch(moveOneNotifier).dateController?.text =
          dateTime.format(pattern: dateTimeFormatPattern);
    }
  }

  // Displays a time picker dialog and updates the selected time in the [moveOneModelObj] object of the current [timeController] if the user selects a valid time
  // This function return a `Future` that cmpletes with `void`
  Future<void> onTapTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Access the state using ref.watch()
      final notifierState = ref.watch(moveOneNotifier);

      ref.read(moveOneNotifier.notifier).state = notifierState.copyWith(
          setTime: pickedTime); // Update with the pickedTime

      // Format the pickedTime as needed (e.g., 'HH:mm')
      final formattedTime =
          "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
      ref.watch(moveOneNotifier).timeController?.text = formattedTime;
    }
  }
}