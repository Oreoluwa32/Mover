import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/app_export.dart';
import 'models/scheduled_item_model.dart';
import 'notifier/activity_scheduled_notifier.dart';
import 'widgets/scheduled_item_widget.dart'; // ignore for file, class must be immutable

class ActivityScheduledScreen extends ConsumerStatefulWidget{
  const ActivityScheduledScreen({Key? key}) : super(key: key);

  @override
  ActivityScheduledScreenState createState() => ActivityScheduledScreenState();
}

class ActivityScheduledScreenState extends ConsumerState<ActivityScheduledScreen> with AutomaticKeepAliveClientMixin<ActivityScheduledScreen>{
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(activityScheduledNotifier.notifier).fetchActivities();
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
          final state = ref.watch(activityScheduledNotifier);
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
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

          final items = state.activityScheduledModelObj?.scheduledItemList ?? [];
          if (items.isEmpty) {
            return Center(
              child: Text(
                "No scheduled ride or delivery requests yet.",
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
              ScheduledItemModel model = items[index];
              return Dismissible(
                key: ValueKey('scheduled-activity-${model.requestType}-${model.requestId}'),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) => _confirmDelete(
                  context,
                  isMoverSide: model.isMoverSide == true,
                ),
                onDismissed: (_) async {
                  try {
                    await ref
                        .read(activityScheduledNotifier.notifier)
                        .removeScheduledActivity(
                          requestId: model.requestId ?? '',
                          requestType: model.requestType ?? 'delivery',
                          isMoverSide: model.isMoverSide == true,
                          matchId: model.matchId,
                        );
                    Fluttertoast.showToast(
                      msg: model.isMoverSide == true
                          ? 'Scheduled task cancelled'
                          : 'Scheduled activity deleted',
                    );
                  } catch (error) {
                    Fluttertoast.showToast(msg: error.toString().replaceFirst('Exception: ', ''));
                  }
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red.shade400,
                    size: 24.h,
                  ),
                ),
                child: GestureDetector(
                  onTap: () => _openScheduledItem(context, model),
                  child: ScheduledItemWidget(model),
                ),
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

  Future<bool> _confirmDelete(
    BuildContext context, {
    required bool isMoverSide,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: Text(isMoverSide ? 'Cancel scheduled task?' : 'Delete scheduled activity?'),
              content: Text(
                isMoverSide
                    ? 'This will cancel your pending or accepted task from the scheduled list.'
                    : 'This will remove the scheduled ride or delivery request from your activity list.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Keep'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(isMoverSide ? 'Cancel task' : 'Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _openScheduledItem(BuildContext context, ScheduledItemModel model) {
    if (model.isMoverSide == true) {
      final requestData = Map<String, dynamic>.from(
        model.requestData ?? const <String, dynamic>{},
      );
      final matchStatus = model.matchStatus ?? '';

      if (model.requestType == 'ride' && matchStatus == 'accepted') {
        NavigatorService.pushNamed(
          AppRoutes.rideSharingPickupOne,
          arguments: {
            'requestData': requestData,
          },
        );
        return;
      }

      NavigatorService.pushNamed(
        AppRoutes.scheduleTripBottomsheet,
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
        },
      );
      return;
    }

    if ((model.hasPricedOffers ?? false) && !(model.hasAcceptedMover ?? false)) {
      NavigatorService.pushNamed(
        AppRoutes.hireMoverScreen,
        arguments: {
          'requestType': model.requestType,
          'requestData': Map<String, dynamic>.from(model.requestData ?? const <String, dynamic>{}),
        },
      );
      return;
    }

    NavigatorService.pushNamed(
      AppRoutes.scheduleTripBottomsheet,
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
      },
    );
  }
}
