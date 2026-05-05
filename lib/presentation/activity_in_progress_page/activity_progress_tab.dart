import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/section_list_placeholder.dart';
import 'models/progress_item_model.dart';
import 'notifier/activity_progress_notifier.dart';
import 'widgets/progress_item_widget.dart';

class ActivityProgressTab extends ConsumerStatefulWidget {
  const ActivityProgressTab({Key? key}) : super(key: key);

  @override
  ActivityProgressTabState createState() => ActivityProgressTabState();
}

class ActivityProgressTabState extends ConsumerState<ActivityProgressTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(activityProgressNotifier.notifier).fetchActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: [
          SizedBox(
            height: 32.h,
          ),
          _buildProgress(context),
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildProgress(BuildContext context) {
    return Expanded(
      child: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(activityProgressNotifier);
          if (state.isLoading) {
            return const SectionListPlaceholder();
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

          final items = state.activityProgressTabModelObj?.progressList ?? [];
          if (items.isEmpty) {
            return Center(
              child: Text(
                "No active ride or delivery requests right now.",
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 16.h);
            },
            itemCount: items.length,
            itemBuilder: (context, index) {
              ProgressItemModel model = items[index];
              return GestureDetector(
                onTap: () => _openActiveItem(model),
                child: ProgressItemWidget(model),
              );
            },
          );
        },
      ),
    );
  }

  void _openActiveItem(ProgressItemModel model) {
    if (model.isMoverSide == true) {
      if (model.requestType == 'delivery') {
        final taskPhase =
            model.matchStatus == 'accepted' ? 'accepted' : 'active';
        NavigatorService.pushNamed(
          AppRoutes.deliveryPickupScreenOne,
          arguments: {
            'requestData': model.requestData,
            'taskPhase': taskPhase,
          },
        );
        return;
      }

      NavigatorService.pushNamed(
        AppRoutes.rideSharingPickupTwo,
        arguments: {
          'requestData': model.requestData,
        },
      );
      return;
    }

    if (model.requestType == 'delivery') {
      final isPickupPhase = model.matchStatus == 'accepted';
      NavigatorService.pushNamed(
        isPickupPhase
            ? AppRoutes.userDeliveryBottomsheetOne
            : AppRoutes.userDeliveryBottomsheetTwo,
        arguments: {
          'requestId': model.requestId,
          'requestType': model.requestType,
          'pickupLocation': model.pickupLocation,
          'destinationLocation': model.destinationLocation,
          'date': model.date,
          'time': model.time,
          'status': model.status,
          'moverName': model.moverName,
          'rating': model.rating,
          'price': model.price,
          'travelPlanId': model.matchedTravelPlanId,
          'matchId': model.matchId,
          'requestData': model.requestData,
          'matchStatus': model.matchStatus,
        },
      );
      return;
    }

    NavigatorService.pushNamed(
      AppRoutes.userDeliveryBottomsheetOne,
      arguments: {
        'requestId': model.requestId,
        'requestType': model.requestType,
        'pickupLocation': model.pickupLocation,
        'destinationLocation': model.destinationLocation,
        'date': model.date,
        'time': model.time,
        'status': model.status,
        'moverName': model.moverName,
        'rating': model.rating,
        'price': model.price,
        'travelPlanId': model.matchedTravelPlanId,
        'matchId': model.matchId,
        'requestData': model.requestData,
        'matchStatus': model.matchStatus,
      },
    );
  }
}
