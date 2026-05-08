import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../routes/auth_route_guard.dart';
import '../completed_bottomsheet/completed_bottomsheet.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/movr_loading_indicator.dart';
import 'models/list_item_model.dart';
import 'notifier/notification_notifier.dart';
import 'widgets/list_item_widget.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(notificationNotifier.notifier).refreshNotifications();
      await ref.read(notificationNotifier.notifier).markAllAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      backgroundColor: theme.colorScheme.onPrimary,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(left: 16.h, top: 20.h, right: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildNotification(context)],
        ),
      ),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 60.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeft,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(text: "Notifications"),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildNotification(BuildContext context) {
    return Expanded(
      child: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(notificationNotifier);
          if (state.isLoading) {
            return const Center(child: MovrLoadingIndicator());
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

          final items = state.notificationModelObj?.listItemList ??
              const <ListItemModel>[];
          if (items.isEmpty) {
            return Center(
              child: Text(
                "No notifications yet.",
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
              padding: EdgeInsets.only(bottom: 24.h),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                ListItemModel model = items[index];
                return ListItemWidget(
                  model,
                  onTap: () => _openNotification(context, model),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 18.h,
                );
              },
              itemCount: items.length);
        },
      ),
    );
  }

  Future<void> _openNotification(
    BuildContext context,
    ListItemModel model,
  ) async {
    final actionType = model.actionType?.trim() ?? '';
    if (actionType.isEmpty) {
      await _showNotificationDetails(context, model);
      return;
    }

    final shouldOpenTask = await _showNotificationDetails(context, model);
    if (shouldOpenTask == true && context.mounted) {
      _openLinkedTask(context, model);
    }
  }

  Future<bool?> _showNotificationDetails(
    BuildContext context,
    ListItemModel model,
  ) async {
    return showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
        return FractionallySizedBox(
          heightFactor: 0.38,
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.h),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(24.h, 10.h, 24.h, 24.h + bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 52.h,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD7D7D7),
                          borderRadius: BorderRadius.circular(3.h),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      model.time ?? '',
                      style: TextStyle(
                        fontSize: 14.fSize,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF3D3D3D),
                        height: 1.43,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      model.title ?? '',
                      style: TextStyle(
                        fontSize: 18.fSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1D1D1F),
                        height: 1.22,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          model.message ?? '',
                          style: TextStyle(
                            fontSize: 16.fSize,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF565656),
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    if ((model.actionType?.trim().isNotEmpty ?? false))
                      SizedBox(
                        width: double.maxFinite,
                        child: TextButton(
                          onPressed: () => Navigator.of(sheetContext).pop(true),
                          child: Text(
                            _actionButtonLabel(model.actionType),
                            style: TextStyle(
                              fontSize: 16.fSize,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openLinkedTask(BuildContext context, ListItemModel model) {
    final actionType = model.actionType?.trim() ?? '';
    final args = Map<String, dynamic>.from(
      model.actionArguments ?? const <String, dynamic>{},
    );

    switch (actionType) {
      case 'wallet_history':
        NavigatorService.pushNamed(
          AppRoutes.transactionHistoryScreen,
          arguments: args,
        );
        return;
      case 'hire_mover':
        NavigatorService.pushNamed(
          AppRoutes.hireMoverScreen,
          arguments: args,
        );
        return;
      case 'mover_delivery_pickup':
      case 'mover_delivery_active':
        NavigatorService.pushNamed(
          AppRoutes.deliveryPickupScreenOne,
          arguments: args,
        );
        return;
      case 'mover_ride_waiting':
        NavigatorService.pushNamed(
          AppRoutes.rideSharingPickupOne,
          arguments: args,
        );
        return;
      case 'mover_ride_active':
        NavigatorService.pushNamed(
          AppRoutes.rideSharingPickupTwo,
          arguments: args,
        );
        return;
      case 'requester_delivery_active':
        NavigatorService.pushNamed(
          AppRoutes.userDeliveryBottomsheetTwo,
          arguments: args,
        );
        return;
      case 'requester_ride_active':
        NavigatorService.pushNamed(
          AppRoutes.userDeliveryBottomsheetOne,
          arguments: args,
        );
        return;
      case 'completed_task':
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => const AuthRouteGuard(
              redirectRoute: AppRoutes.signInScreen,
              child: CompletedBottomsheet(),
            ),
            settings: RouteSettings(arguments: args),
          ),
        );
        return;
      default:
        return;
    }
  }

  String _actionButtonLabel(String? actionType) {
    if ((actionType?.trim() ?? '') == 'wallet_history') {
      return 'Open wallet';
    }
    return 'Open task';
  }

  // Navigate back to the previous screen
  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }
}
