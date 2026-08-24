import 'package:flutter/material.dart';
import 'auth_route_guard.dart';
import '../presentation/save_your_route_dialog/save_your_route_dialog.dart';
import '../presentation/splash_screen_two/splash_screen_two.dart';
import '../presentation/splash_screen_three/splash_screen_three.dart';
import '../presentation/splash_screen_four/splash_screen_four.dart';
import '../presentation/create_account_screen/create_account_screen.dart';
import '../presentation/email_verified_screen/email_verified_screen.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/password_check_mail_screen/password_check_mail_screen.dart';
import '../presentation/home_one_screen/home_one_screen.dart';
import '../presentation/password_success_screen/password_success_screen.dart';
import '../presentation/reset_password_screen/reset_password_screen.dart';
import '../presentation/sign_in_screen/sign_in_screen.dart';
import '../presentation/splash_screen_one/splash_screen_one.dart';
import '../presentation/check_mail_screen/check_mail_screen.dart';
import '../presentation/home_screen_dialog/home_screen_dialog.dart';
import '../presentation/my_route_page/my_route_page.dart';
import '../presentation/add_route_screen/add_route_screen.dart';
import '../presentation/instant_add_route_screen_one/add_route_screen_one.dart';
import '../presentation/add_route_screen_two/add_route_screen_two.dart';
import '../presentation/add_route_screen_three/add_route_screen_three.dart';
import '../presentation/route_settings_bottomsheet/add_route_three_bottomsheet.dart';
import '../presentation/set_date_bottomsheet/set_date_bottomsheet.dart';
import '../presentation/set_date_bottomsheet_two/set_date_bottomsheet_two.dart';
import '../presentation/personal_information_screen/personal_information_screen.dart';
import '../presentation/verification_screen/verification_screen.dart';
import '../presentation/vehicle_information_screen/vehicle_information_screen.dart';
import '../presentation/identification_screen/identification_screen.dart';
// import '../presentation/my_route_plus_page/my_route_plus_page.dart';
import '../presentation/verification_screen_one/verification_screen_one.dart';
import '../presentation/under_review_screen/under_review_screen.dart';
import '../presentation/select_plan_screen/select_plan_screen.dart';
import '../presentation/home_delivery_request_screen/home_delivery_request_screen.dart';
import '../presentation/delivery_task_one_bottomsheet/delivery_task_one_bottomsheet.dart';
import '../presentation/ride_sharing_task_bottomsheet_one/ride_sharing_task_bottomsheet_one.dart';
import '../presentation/delivery_rating_screen_one/delivery_rating_screen_one.dart';
import '../presentation/delivery_rating_screen_two/delivery_rating_screen_two.dart';
import '../presentation/ride_cancel_screen_one/ride_cancel_screen_one.dart';
import '../presentation/ride_sharing_pickup_one/ride_sharing_pickup_one.dart';
import '../presentation/ride_sharing_pickup_two/ride_sharing_pickup_two.dart';
import '../presentation/hire_mover_screen/hire_mover_screen.dart';
import '../presentation/hire_mover_screen_one/hire_mover_screen_one.dart';
import '../presentation/no_mover_screen/no_mover_screen.dart';
import '../presentation/payment_bottomsheet/payment_bottomsheet.dart';
import '../presentation/search_mover_bottomsheet/search_mover_bottomsheet.dart';
import '../presentation/delivery_details_screen/delivery_details_screen.dart';
import '../presentation/delivery_pickup_screen_one/delivery_pickup_screen_one.dart';
import '../presentation/user_move_screen/user_move_screen.dart';
import '../presentation/user_delivery_bottomsheet_one/user_delivery_bottomsheet_one.dart';
import '../presentation/user_delivery_bottomsheet_two/user_delivery_bottomsheet_two.dart';
import '../presentation/delivery_screen/delivery_screen.dart';
import '../presentation/share_ride_screen/share_ride_screen.dart';
import '../presentation/share_ride_payment/share_ride_payment.dart';
import '../presentation/share_ride_screen_one/share_ride_screen_one.dart';
import '../presentation/deposit_screen/deposit_screen.dart';
import '../presentation/deposit_bottomsheet/deposit_bottomsheet.dart';
import '../presentation/deposit_screen_two/deposit_screen_two.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/transaction_history_screen/transaction_history_screen.dart';
import '../presentation/account_funded_screen/account_funded_screen.dart';
import '../presentation/activity_in_progress_page/activity_in_progress_page.dart';
import '../presentation/schedule_trip_bottomsheet/schedule_trip_bottomsheet.dart';
import '../presentation/refer_friends_screen/refer_friends_screen.dart';
import '../presentation/scan_screen/scan_screen.dart';
import '../presentation/delivery_pickup_screen_two/delivery_pickup_screen_two.dart';
import '../presentation/scan_screen_one/scan_screen_one.dart';
import '../presentation/notification_screen/notification_screen.dart';
import '../presentation/paystack_payment_screen/paystack_payment_screen.dart';
import '../presentation/monnify_payment_screen/monnify_payment_screen.dart';
import '../presentation/schedule_move_bottomsheet/schedule_move_bottomsheet.dart';
import '../presentation/ride_sharing_details_screen/ride_sharing_details_screen.dart';
import '../presentation/schedule_move_bottomsheet_one/schedule_move_bottomsheet_one.dart';
import '../presentation/task_chat_screen/task_chat_screen.dart';
import '../presentation/debug/rive_marker_preview_screen.dart';

// THis class must be immutable
class AppRoutes {
  static Widget _protected(Widget child) {
    return AuthRouteGuard(
      redirectRoute: signInScreen,
      child: child,
    );
  }

  static const String splashScreenOne = '/splash_screen_one';

  static const String splashScreenTwo = '/splash_screen_two';

  static const String splashScreenThree = '/splash_screen_three';

  static const String splashScreenFour = '/splash_screen_four';

  static const String checkMailScreen = '/check_mail_screen';

  static const String createAccountScreen = '/create_account_screen';

  static const String emailVerifiedScreen = '/email_verified_screen';

  static const String forgotPasswordScreen = '/forgot_password_screen';

  static const String passwordCheckMailScreen = '/password_check_mail_screen';

  static const String homeScreenDialog = '/home_screen_dialog';

  static const String scheduleMoveBottomsheetOne =
      '/schedule_move_bottomsheet_one';

  static const String verificationScreen = '/verification_screen';

  static const String verificationScreenOne = '/verification_screen_one';

  static const String personalInformationScreen =
      '/personal_information_screen';

  static const String vehicleInformationScreen = '/vehicle_information_screen';

  static const String identificationScreen = '/identification_screen';

  static const String underReviewScreen = '/under_review_screen';

  static const String selectPlanScreen = '/select_plan_screen';

  static const String homeOneScreen = '/home_one_screen';

  static const String homeOneInitialPage = '/home_one_initial_page';

  static const String passwordSuccessScreen = '/password_success_screen';

  static const String resetPasswordScreen = '/reset_password_screen';

  static const String signInScreen = '/sign_in_screen';

  static const String myRoutePage = '/my_route_page';

  static const String addRouteScreen = '/add_route_screen';

  static const String addRouteScreenOne = '/add_route_screen_one';

  static const String addRouteScreenTwo = '/add_route_screen_two';

  static const String addRouteScreenThree = '/add_route_screen_three';

  static const String addRouteThreeBottomsheet = '/add_route_three_bottomsheet';

  static const String setDateBottomsheet = '/set_date_bottomsheet';

  static const String setDateBottomsheetTwo = '/set_date_bottomsheet_two';

  static const String rideSharingDetailsScreen = '/ride_sharing_details_screen';

  static const String homeDeliveryRequestScreen =
      '/home_delivery_request_screen';

  static const String deliveryTaskOneBottomsheet =
      '/delivery_task_one_bottomsheet';

  static const String rideSharingTaskBottomsheetOne =
      '/ride_sharing_task_bottomsheet_one';

  static const String rideSharingPickupOne = '/ride_sharing_pickup_one';

  static const String rideSharingPickupTwo = '/ride_sharing_pickup_two';

  static const String deliveryRatingScreenOne = '/delivery_rating_screen_one';

  static const String deliveryRatingScreenTwo = '/delivery_rating_screen_two';

  static const String rideCancelScreenOne = '/ride_cancel_screen_one';

  // static const String myRoutePlusPage = '/my_route_plus_page';

  static const String hireMoverScreen = 'hire_mover_screen';

  static const String hireMoverScreenOne = 'hire_mover_screen_one';

  static const String noMoverScreen = 'no_mover_screen';

  static const String paymentBottomsheet = 'payment_bottomsheet';

  static const String searchMoverBottomsheet = 'search_mover_bottomsheet';

  static const String deliveryDetailsScreen = 'delivery_details_screen';

  static const String deliveryPickupScreenOne = 'delivery_pickup_screen_one';

  static const String userMoveScreen = 'user_move_screen.dart';

  static const String userDeliveryBottomsheetOne =
      'user_delivery_bottomsheet_one';

  static const String userDeliveryBottomsheetTwo =
      'user_delivey_bottomsheet_two';

  static const String deliveryScreen = 'delivery_screen';

  static const String shareRideScreen = 'share_ride_screen';

  static const String shareRideScreenOne = 'share_ride_screen_one';

  static const String shareRidePayment = 'share_ride_payment';

  static const String depositScreen = 'deposit_screen';

  static const String depositBottomsheet = 'deposit_bottomsheet';

  static const String depositScreenTwo = 'deposit_screen_two';

  static const String profileScreen = 'profile_screen';

  static const String transactionHistoryScreen = 'transaction_history_screen';

  static const String accountFundedScreen = 'account_funded_screen';

  static const String activityInProgressPage = 'activity_in_progress_page';

  static const String scheduleTripBottomsheet = 'schedule_trip_bottomsheet';

  static const String referFriendsScren = 'refer_friends_screen';

  static const String saveYourRouteDialog = 'save_your_route_dialog';

  static const String scanScreen = 'scan_screen';

  static const String scanScreenOne = 'scan_screen_one';

  static const String deliveryPickupScreenTwo = 'delivery_pickup_screen_two';

  static const String notificationScreen = '/notification_screen';

  static const String scheduleMoveBottomsheet = 'schedule_move_bottomsheet';

  static const String taskChatScreen = '/task_chat_screen';

  static const String paystackPaymentScreen = '/paystack_payment_screen';

  static const String monnifyPaymentScreen = '/monnify_payment_screen';

  static const String riveMarkerPreviewScreen = '/debug/rive-marker';

  static const String initialRoute = splashScreenOne;

  static Map<String, WidgetBuilder> routes = {
    riveMarkerPreviewScreen: (context) => const RiveMarkerPreviewScreen(),

    splashScreenOne: (context) => SplashScreenOne(),

    splashScreenTwo: (context) => SplashScreenTwo(),

    splashScreenThree: (context) => SplashScreenThree(),

    splashScreenFour: (context) => SplashScreenFour(),

    checkMailScreen: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final email = args?['email'] as String? ?? '';
      return CheckMailScreen(email: email);
    },

    createAccountScreen: (context) => CreateAccountScreen(),

    emailVerifiedScreen: (context) => EmailVerifiedScreen(),

    forgotPasswordScreen: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final email = args?['email'] as String?;
      return ForgotPasswordScreen(
        key: ValueKey(email ?? 'forgot-password'),
      );
    },

    passwordCheckMailScreen: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final email = args?['email'] as String?;
      return PasswordCheckMailScreen(email: email);
    },

    homeOneScreen: (context) => _protected(HomeOneScreen()),

    passwordSuccessScreen: (context) => PasswordSuccessScreen(),

    resetPasswordScreen: (context) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final resetToken = args?['resetToken'] as String?;
      final resetUid = args?['resetUid'] as String?;
      return ResetPasswordScreen(resetUid: resetUid, resetToken: resetToken);
    },

    signInScreen: (context) => SignInScreen(),

    homeScreenDialog: (context) => _protected(HomeScreenDialog()),

    verificationScreen: (context) => _protected(VerificationScreen()),

    verificationScreenOne: (context) => _protected(VerificationScreenOne()),

    personalInformationScreen: (context) =>
        _protected(PersonalInformationScreen()),

    vehicleInformationScreen: (context) =>
        _protected(VehicleInformationScreen()),

    identificationScreen: (context) => _protected(IdentificationScreen()),

    rideSharingDetailsScreen: (context) =>
        _protected(RideSharingDetailsScreen()),

    underReviewScreen: (context) => _protected(UnderReviewScreen()),

    selectPlanScreen: (context) => _protected(SelectPlanScreen()),

    scheduleMoveBottomsheetOne: (context) =>
        _protected(ScheduleMoveBottomsheetOne()),

    // myRoutePlusPage: (context) => MyRoutePlusPage(),

    myRoutePage: (context) => _protected(MyRoutePage()),

    addRouteScreen: (context) => _protected(AddRouteScreen()),

    addRouteScreenOne: (context) => _protected(AddRouteScreenOne()),

    addRouteScreenTwo: (context) => _protected(AddRouteScreenTwo()),

    addRouteScreenThree: (context) => _protected(AddRouteScreenThree()),

    addRouteThreeBottomsheet: (context) =>
        _protected(AddRouteThreeBottomsheet()),

    setDateBottomsheet: (context) => _protected(SetDateBottomsheet()),

    setDateBottomsheetTwo: (context) => _protected(SetDateBottomsheetTwo()),

    homeDeliveryRequestScreen: (context) =>
        _protected(HomeDeliveryRequestScreen()),

    deliveryTaskOneBottomsheet: (context) =>
        _protected(DeliveryTaskOneBottomsheet()),

    rideSharingTaskBottomsheetOne: (context) =>
        _protected(RideSharingTaskBottomsheetOne()),

    deliveryRatingScreenOne: (context) => _protected(DeliveryRatingScreenOne()),

    deliveryRatingScreenTwo: (context) => _protected(DeliveryRatingScreenTwo()),

    rideCancelScreenOne: (context) => _protected(RideCancelScreenOne()),

    hireMoverScreen: (context) => _protected(HireMoverScreen()),

    hireMoverScreenOne: (context) => _protected(HireMoverScreenOne()),

    noMoverScreen: (context) => _protected(NoMoverScreen()),

    paymentBottomsheet: (context) => _protected(PaymentBottomsheet()),

    searchMoverBottomsheet: (context) => _protected(SearchMoverBottomsheet()),

    rideSharingPickupOne: (context) => _protected(RideSharingPickupOne()),

    rideSharingPickupTwo: (context) => _protected(RideSharingPickupTwo()),

    deliveryDetailsScreen: (context) => _protected(DeliveryDetailsScreen()),

    deliveryPickupScreenOne: (context) => _protected(DeliveryPickupScreenOne()),

    userMoveScreen: (context) => _protected(UserMoveScreen()),

    userDeliveryBottomsheetOne: (context) =>
        _protected(UserDeliveryBottomsheetOne()),

    userDeliveryBottomsheetTwo: (context) =>
        _protected(UserDeliveryBottomsheetTwo()),

    deliveryScreen: (context) => _protected(DeliveryScreen()),

    shareRideScreen: (context) => _protected(ShareRideScreen()),

    shareRideScreenOne: (context) => _protected(ShareRideScreenOne()),

    shareRidePayment: (context) => _protected(ShareRidePayment()),

    depositScreen: (context) => _protected(DepositScreen()),

    depositBottomsheet: (context) => _protected(DepositBottomsheet()),

    depositScreenTwo: (context) => _protected(
          DepositScreenTwo(
            amount: '',
            email: '',
            reference: '',
            onSuccessfulTransaction: (Object? result) {},
            onFailedTransaction: (Object? error) {},
          ),
        ),

    profileScreen: (context) => _protected(ProfileScreen()),

    transactionHistoryScreen: (context) =>
        _protected(TransactionHistoryScreen()),

    accountFundedScreen: (context) => _protected(AccountFundedScreen()),

    activityInProgressPage: (context) => _protected(ActivityInProgressPage()),

    scheduleTripBottomsheet: (context) => _protected(ScheduleTripBottomsheet()),

    referFriendsScren: (context) => _protected(ReferFriendsScreen()),

    saveYourRouteDialog: (context) => _protected(SaveYourRouteDialog()),

    scanScreen: (context) => _protected(ScanScreen()),

    deliveryPickupScreenTwo: (context) => _protected(DeliveryPickupScreenTwo()),

    scanScreenOne: (context) => _protected(ScanScreenOne()),

    notificationScreen: (context) => _protected(NotificationScreen()),

    scheduleMoveBottomsheet: (context) => _protected(ScheduleMoveBottomsheet()),

    taskChatScreen: (context) => _protected(const TaskChatScreen()),
  };

  /// Handle routes with parameters
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case paystackPaymentScreen:
        return MaterialPageRoute(
          builder: (context) => _protected(
            PaystackPaymentScreen(
              amount: args?['amount'] ?? '',
              email: args?['email'] ?? '',
              reference: args?['reference'] ?? '',
            ),
          ),
        );
      case monnifyPaymentScreen:
        return MaterialPageRoute(
          builder: (context) => _protected(
            MonnifyPaymentScreen(
              amount: args?['amount'] ?? '',
              email: args?['email'] ?? '',
              reference: args?['reference'] ?? '',
            ),
          ),
        );
      case resetPasswordScreen:
        final resetToken = args?['resetToken'] as String?;
        final resetUid = args?['resetUid'] as String?;
        return MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(
            resetUid: resetUid,
            resetToken: resetToken,
          ),
        );
      default:
        return null;
    }
  }

  /// Handle deep links (e.g., movr://reset-password?uid=abc&token=xyz)
  static Route<dynamic>? onDeepLinkRoute(String? deepLink) {
    if (deepLink == null || deepLink.isEmpty) {
      return null;
    }

    final uri = Uri.parse(deepLink);

    // Handle password reset deep link: movr://reset-password?uid=abc&token=xyz
    if (uri.scheme == 'movr' && uri.host == 'reset-password') {
      final token = uri.queryParameters['token'];
      final uid = uri.queryParameters['uid'];
      if (token != null && token.isNotEmpty && uid != null && uid.isNotEmpty) {
        return MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(
            resetUid: uid,
            resetToken: token,
          ),
        );
      }
    }

    return null;
  }
}
