import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../routes/auth_route_guard.dart';
import '../../widgets/movr_loading_indicator.dart';
import '../completed_bottomsheet/completed_bottomsheet.dart';
import 'models/completed_item_model.dart';
import 'notifier/activity_completed_notifier.dart';
import 'widgets/completed_item_widget.dart'; // ignore for file, class must be immutable

class ActivityCompletedScreen extends ConsumerStatefulWidget {
  const ActivityCompletedScreen({Key? key}) : super(key: key);

  @override
  ActivityCompletedScreenState createState() => ActivityCompletedScreenState();
}

class ActivityCompletedScreenState
    extends ConsumerState<ActivityCompletedScreen>
    with AutomaticKeepAliveClientMixin<ActivityCompletedScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(activityCompletedNotifier.notifier).fetchActivities();
    });
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 32.h,
            ),
            _buildSchedules(context)
          ],
        ),
      ),
    );
  }

  // Section Widget
  Widget _buildSchedules(BuildContext context) {
    return Expanded(
      child: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(activityCompletedNotifier);
          if (state.isLoading) {
            return const Center(
              child: MovrLoadingIndicator(
                label: 'Loading completed activity...',
              ),
            );
          }

          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.h),
                child: Text(
                  state.errorMessage!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            );
          }

          final items =
              state.activityCompletedModelObj?.completedItemList ?? [];
          if (items.isEmpty) {
            return Center(
              child: Text(
                "No completed ride or delivery requests yet.",
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              CompletedItemModel model = items[index];
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _handleCompletedTap(context, model),
                child: CompletedItemWidget(model),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 16.h,
              );
            },
            itemCount: items.length,
          );
        },
      ),
    );
  }

  void _handleCompletedTap(BuildContext context, CompletedItemModel model) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => const AuthRouteGuard(
          redirectRoute: AppRoutes.signInScreen,
          child: CompletedBottomsheet(),
        ),
        settings: RouteSettings(
          arguments: {
            'requestType': model.requestType,
            'pickupLocation': model.pickupLocation,
            'destinationLocation': model.destinationLocation,
            'pickupLatitude': model.pickupLatitude,
            'pickupLongitude': model.pickupLongitude,
            'destinationLatitude': model.destinationLatitude,
            'destinationLongitude': model.destinationLongitude,
            'date': model.date,
            'time': model.time,
            'moverName': model.moverName,
            'rating': model.rating,
            'price': model.price?.replaceAll('NGN', '').trim(),
            'requestData': model.requestData,
          },
        ),
      ),
    );
  }
}
