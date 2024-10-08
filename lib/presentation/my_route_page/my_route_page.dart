import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_floating_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'widgets/savedroute_item_widget.dart';

// ignore for file, must be immutable
class MyRoutePage extends StatelessWidget{
  MyRoutePage({Key? key})
    : super(key: key,);

  TextEditingController addrouteoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomTextFormField(
                        controller: addrouteoneController,
                        hintText: "My Route",
                        hintStyle: CustomTextStyles.titleMediumOnPrimaryContainer,
                        textInputAction: TextInputAction.done,
                        contentPadding: EdgeInsets.fromLTRB(12.h, 12.h, 12.h, 20.h),
                        borderDecoration: TextFormFieldStyleHelper.outlineGray1,
                      ),
                      SizedBox(height: 16.h),
                      Expanded(
                        child: Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(horizontal: 16.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [_buildSavedroute(context)],
                          ),
                        ),
                      ),
                      SizedBox(height: 116.h)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: _buildFloatingactionb(context),
      ),
    );
  }

  // Section Widget 
  Widget _buildSavedroute(BuildContext context){
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index){
          return SizedBox(
            height: 12.h,
          );
        },
        itemCount: 7,
        itemBuilder: (context, index){
          return SavedrouteItemWidget();
        },
      ),
    );
  }

  // Section Widget 
  Widget _buildFloatingactionb(BuildContext context){
    return CustomFloatingButton(
      height: 48,
      width: 48,
      backgroundColor: theme.colorScheme.primary,
      decoration: FloatingButtonStyleHelper.fillPrimary,
      child: CustomImageView(
        imagePath: ImageConstant.imgPlus,
        height: 24.0.h,
        width: 24.0.h,
      ),
    );
  }
}