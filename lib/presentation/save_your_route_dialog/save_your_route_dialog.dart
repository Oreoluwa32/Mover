import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'notifier/save_route_notifier.dart'; //ignore for file, class must be immutable

// ignore for file, class must be immutable
class SaveYourRouteDialog extends ConsumerStatefulWidget {
  const SaveYourRouteDialog({Key? key})
      : super(
          key: key,
        );

  @override
  SaveYourRouteDialogState createState() => SaveYourRouteDialogState();
}

class SaveYourRouteDialogState extends ConsumerState<SaveYourRouteDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusStyle.CircleBorder20,
      ),
      backgroundColor: theme.colorScheme.onPrimary.withValues(alpha: 1),
      insetPadding: EdgeInsets.symmetric(horizontal: 16.h),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Save your route",
                      style: CustomTextStyles.titleMediumInterGray80001,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Customize route for easy use",
                      style: CustomTextStyles.bodyMediumGray700,
                    ),
                    SizedBox(height: 14.h),
                    Consumer(builder: (context, ref, _) {
                      return CustomTextFormField(
                        controller:
                            ref.watch(saveRouteNotifier).textController,
                        hintText: "Work",
                        // hintStyle: CustomTextStyles.bodyMediumGray80001,
                        textInputAction: TextInputAction.done,
                        contentPadding:
                            EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
                        borderDecoration:
                            TextFormFieldStyleHelper.outlineBlueGray,
                      );
                    }),
                    SizedBox(height: 22.h),
                    CustomElevatedButton(
                      text: "Save route",
                      buttonTextStyle:
                          CustomTextStyles.titleSmallOnPrimaryMedium,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 12.h),
                    CustomOutlinedButton(
                      text: "Cancel",
                      buttonStyle: CustomButtonStyles.outlineGray,
                      buttonTextStyle: CustomTextStyles.titleSmallGray700,
                      onPresssed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
