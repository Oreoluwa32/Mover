import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_floating_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/saved_route_model.dart';
import 'notifier/my_route_notifier.dart';
import 'widgets/savedroute_item_widget.dart';

// ignore for file, must be immutable
class MyRoutePage extends ConsumerStatefulWidget {
  const MyRoutePage({Key? key})
      : super(
          key: key,
        );

  @override
  MyRoutePageState createState() => MyRoutePageState();
}

class MyRoutePageState extends ConsumerState<MyRoutePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [SizedBox(height: 28.h), _buildSavedroute(context)],
          ),
        ),
        floatingActionButton: _buildFloatingactionb(context),
      ),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 90.h,
      leadingWidth: 40.h,
      centerTitle: true,
      title: AppbarSubtitle(
        text: "My Route",
        margin: EdgeInsets.only(
          top: 46.h,
          bottom: 19.h,
        ),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildSavedroute(BuildContext context) {
    return Expanded(child: Consumer(builder: (context, ref, _) {
      return ListView.separated(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 12.h,
          );
        },
        itemCount: ref
                .watch(myRouteNotifier)
                .myRouteModelObj
                ?.savedrouteItemList
                .length ??
            0,
        itemBuilder: (context, index) {
          SavedRouteModel model = ref
                  .watch(myRouteNotifier)
                  .myRouteModelObj
                  ?.savedrouteItemList[index] ??
              SavedRouteModel();
          return SavedrouteItemWidget(model);
        },
      );
    }));
  }

  // Section Widget
  Widget _buildFloatingactionb(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 150.h),
      child: CustomFloatingButton(
        height: 48,
        width: 48,
        backgroundColor: theme.colorScheme.primary,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.h),
          
        ),
        child: CustomImageView(
          imagePath: ImageConstant.imgPlus,
          height: 24.0.h,
          width: 24.0.h,
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return _buildOverlayContent();
            },
          );
        },
      ),
    );
  }

  Widget _buildOverlayContent() {
    return Container(
      height: 300, // Set the desired height of the overlay
      decoration: BoxDecoration(
        // Example background color
        borderRadius: BorderRadius.circular(25.h),
      ),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 22.h,
                vertical: 23.h
              ),
            ),
            onPressed: () {
              // Handle "Instant route" button press
              Navigator.of(context).pop(); // Close the overlay
            },
            child: Text(
              'Instant route',
              style: CustomTextStyles.labelLargeGray400?.copyWith(color: Colors.black87)
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 22.h,
                vertical: 23.h
              ),
            ),
            onPressed: () {
              // Handle "Schedule route" button press
              Navigator.of(context).pop(); // Close the overlay
            },
            child: Text(
              'Schedule route',
              style: CustomTextStyles.labelLargeGray400?.copyWith(color: Colors.black87)
            ),
          ),
          const SizedBox(height: 20),
          CustomFloatingButton(
            height: 48,
            width: 48,
            backgroundColor: theme.colorScheme.primary,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.h)
            ),
            child: CustomImageView(
              imagePath: ImageConstant.imgWhiteCancel,
              height: 24.0.h,
              width: 24.0.h,
            ),
            onTap: () {
              Navigator.of(context).pop(); // Close the overlay
            },
          )
        ],
      ),
    );
  }
}
