import 'package:flutter/material.dart';
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

// THis class must be immutable
class AppRoutes {
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

  static const String verificationScreen = '/verification_screen';

  static const String verificationScreenOne = '/verification_screen_one';

  static const String personalInformationScreen =
      '/personal_information_screen';

  static const String vehicleInformationScreen = '/vehicle_information_screen';

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

  static const String setDateBottomsheetTwo = '/set_date_bottomsheet';

  static const String homeDeliveryRequestScreen =
      '/home_delivery_request_screen';

  static const String deliveryTaskOneBottomsheet =
      '/delivery_task_one_bottomsheet';

  static const String rideSharingTaskBottomsheetOne =
      '/ride_sharing_task_bottomsheet_one';

  static const String rideSharingPickupOne = '/ride_sharing_pickup_one';

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


  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    splashScreenOne: (context) => SplashScreenOne(),

    splashScreenTwo: (context) => SplashScreenTwo(),

    splashScreenThree: (context) => SplashScreenThree(),

    splashScreenFour: (context) => SplashScreenFour(),

    checkMailScreen: (context) => CheckMailScreen(email: ''),

    createAccountScreen: (context) => CreateAccountScreen(),

    emailVerifiedScreen: (context) => EmailVerifiedScreen(),

    forgotPasswordScreen: (context) => ForgotPasswordScreen(),

    passwordCheckMailScreen: (context) => PasswordCheckMailScreen(),

    homeOneScreen: (context) => HomeOneScreen(),

    passwordSuccessScreen: (context) => PasswordSuccessScreen(),

    resetPasswordScreen: (context) => ResetPasswordScreen(),

    signInScreen: (context) => SignInScreen(),

    homeScreenDialog: (context) => HomeScreenDialog(),

    verificationScreen: (context) => VerificationScreen(),

    verificationScreenOne: (context) => VerificationScreenOne(),

    personalInformationScreen: (context) => PersonalInformationScreen(),

    vehicleInformationScreen: (context) => VehicleInformationScreen(),

    underReviewScreen: (context) => UnderReviewScreen(),

    selectPlanScreen: (context) => SelectPlanScreen(),

    // myRoutePlusPage: (context) => MyRoutePlusPage(),

    myRoutePage: (context) => MyRoutePage(),

    addRouteScreen: (context) => AddRouteScreen(),

    addRouteScreenOne: (context) => AddRouteScreenOne(),

    addRouteScreenTwo: (context) => AddRouteScreenTwo(),

    addRouteScreenThree: (context) => AddRouteScreenThree(),

    addRouteThreeBottomsheet: (context) => AddRouteThreeBottomsheet(),

    setDateBottomsheet: (context) => SetDateBottomsheet(),

    setDateBottomsheetTwo: (context) => SetDateBottomsheetTwo(),

    homeDeliveryRequestScreen: (context) => HomeDeliveryRequestScreen(),

    deliveryTaskOneBottomsheet: (context) => DeliveryTaskOneBottomsheet(),

    rideSharingTaskBottomsheetOne: (context) => RideSharingTaskBottomsheetOne(),

    deliveryRatingScreenOne: (context) => DeliveryRatingScreenOne(),

    deliveryRatingScreenTwo: (context) => DeliveryRatingScreenTwo(),

    rideCancelScreenOne: (context) => RideCancelScreenOne(),

    hireMoverScreen: (context) => HireMoverScreen(),

    hireMoverScreenOne: (context) => HireMoverScreenOne(),

    noMoverScreen: (context) => NoMoverScreen(),

    paymentBottomsheet: (context) => PaymentBottomsheet(),

    searchMoverBottomsheet: (context) => SearchMoverBottomsheet(),

    rideSharingPickupOne: (context) => RideSharingPickupOne(),

    deliveryDetailsScreen: (context) => DeliveryDetailsScreen(),

    deliveryPickupScreenOne: (context) => DeliveryPickupScreenOne(),

    userMoveScreen: (context) => UserMoveScreen(),

    userDeliveryBottomsheetOne: (context) => UserDeliveryBottomsheetOne(),

    userDeliveryBottomsheetTwo: (context) => UserDeliveryBottomsheetTwo(),

    deliveryScreen: (context) => DeliveryScreen(),

    shareRideScreen: (context) => ShareRideScreen(),

    shareRideScreenOne: (context) => ShareRideScreenOne(),

    shareRidePayment: (context) => ShareRidePayment(),

    depositScreen: (context) => DepositScreen(),

    depositBottomsheet: (context) => DepositBottomsheet(),

    depositScreenTwo: (context) => DepositScreenTwo(),

    profileScreen: (context) => ProfileScreen(),

    transactionHistoryScreen: (context) => TransactionHistoryScreen(),

    accountFundedScreen: (context) => AccountFundedScreen(),

    activityInProgressPage: (context) => ActivityInProgressPage(),

    scheduleTripBottomsheet: (context) => ScheduleTripBottomsheet(),

    referFriendsScren: (context) => ReferFriendsScreen(),

    saveYourRouteDialog: (context) => SaveYourRouteDialog(),

    scanScreen: (context) => ScanScreen(),

    deliveryPickupScreenTwo: (context) => DeliveryPickupScreenTwo(),

    scanScreenOne: (context) => ScanScreenOne(),

    initialRoute: (context) => HireMoverScreen()
  };
}
