import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../instant_add_route_screen_one/add_route_screen_one.dart';
import '../add_route_screen_three/add_route_screen_three.dart';
import '../../widgets/custom_floating_button.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/saved_route_model.dart';
import 'notifier/my_route_notifier.dart';
import 'widgets/savedroute_item_widget.dart';

// ignore for file, must be immutable
class MyRoutePage extends ConsumerStatefulWidget {
  final Function(bool)? onOverlayChanged;
  
  const MyRoutePage({Key? key, this.onOverlayChanged})
      : super(
          key: key,
        );

  @override
  MyRoutePageState createState() => MyRoutePageState();
}

class MyRoutePageState extends ConsumerState<MyRoutePage> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.50).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
    widget.onOverlayChanged?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
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
        ),
        if (_isExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleExpanded,
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),
          ),
        if (_isExpanded)
          Positioned(
            right: 16.h,
            bottom: 80.h,
            child: _buildOverlayButtons(context),
          ),
      ],
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
      padding: EdgeInsets.only(bottom: 43.h, right: 1.5.h),
      child: RotationTransition(
        turns: _rotationAnimation,
        child: CustomFloatingButton(
          height: 48,
          width: 48,
          backgroundColor: theme.colorScheme.primary,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.h),
          ),
          child: Icon(
            _isExpanded ? Icons.close : Icons.add,
            color: Colors.white,
            size: 24.h,
          ),
          onTap: _toggleExpanded,
        ),
      ),
    );
  }

  Widget _buildOverlayButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 30.h,
              padding: EdgeInsets.symmetric(
                horizontal: 14.h,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusStyle.roundedBorder4,
              ),
              child: Text(
                'Instant route',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.fSize,
                ),
              ),
            ),
            SizedBox(width: 12.h),
            GestureDetector(
              onTap: () {
                _toggleExpanded();
                onTapInstant(context);
              },
              child: Container(
                height: 40.h,
                width: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomImageView(
                    imagePath: ImageConstant.imgInstantRoute,
                    height: 19.37.h,
                    width: 19.37.h,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 30.h,
              padding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusStyle.roundedBorder4,
              ),
              child: Text(
                'Schedule route',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.fSize,
                ),
              ),
            ),
            SizedBox(width: 12.h),
            GestureDetector(
              onTap: () {
                _toggleExpanded();
                onTapSchedule(context);
              },
              child: Container(
                height: 40.h,
                width: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomImageView(
                    imagePath: ImageConstant.imgCalendarAdd,
                    height: 19.37.h,
                    width: 19.37.h,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        RotationTransition(
          turns: _rotationAnimation,
          child: CustomFloatingButton(
            height: 48,
            width: 48,
            backgroundColor: theme.colorScheme.primary,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.h),
            ),
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 24.h,
            ),
            onTap: _toggleExpanded,
          ),
        ),
      ],
    );
  }

  // Navigates to the instant route screen
  onTapInstant(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.addRouteScreenOne);
  }

  onTapSchedule(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.addRouteScreenThree);
  }
}
