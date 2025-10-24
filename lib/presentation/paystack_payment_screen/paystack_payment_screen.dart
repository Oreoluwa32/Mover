import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/app_export.dart';
import '../../services/paystack_services.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../theme/custom_text_style.dart';
import 'notifier/paystack_payment_notifier.dart';

class PaystackPaymentScreen extends ConsumerStatefulWidget {
  final String amount;
  final String email;
  final String reference;

  const PaystackPaymentScreen({
    Key? key,
    required this.amount,
    required this.email,
    required this.reference,
  }) : super(key: key);

  @override
  PaystackPaymentScreenState createState() => PaystackPaymentScreenState();
}

class PaystackPaymentScreenState extends ConsumerState<PaystackPaymentScreen> {
  late WebViewController _webViewController;
  final PaystackServices _paystackServices = PaystackServices();
  bool _webViewInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    try {
      ref.read(paystackPaymentNotifier.notifier).setLoading(true);
      debugPrint('PaystackPaymentScreen: Initializing payment with:');
      debugPrint('  Amount: ${widget.amount}');
      debugPrint('  Email: ${widget.email}');
      debugPrint('  Reference: ${widget.reference}');

      final paymentUrl = await _paystackServices.getPaymentUrl(
        amount: widget.amount,
        email: widget.email,
        reference: widget.reference,
      );

      if (!mounted) return;

      debugPrint('PaystackPaymentScreen: Payment URL received: $paymentUrl');

      // Debug: Check if URL is empty
      if (paymentUrl.isEmpty) {
        final errorMsg = 'Payment URL is empty - backend may not have returned authorization URL. Please check if:\n1. Backend API is running\n2. Paystack credentials are correct\n3. Network connection is stable';
        debugPrint('PaystackPaymentScreen: ERROR - $errorMsg');
        
        ref.read(paystackPaymentNotifier.notifier).setError(errorMsg);
        ref.read(paystackPaymentNotifier.notifier).setLoading(false);
        
        Fluttertoast.showToast(
          msg: 'Failed to get payment URL',
          toastLength: Toast.LENGTH_LONG,
        );
        return;
      }

      ref.read(paystackPaymentNotifier.notifier).setPaymentUrl(paymentUrl);
      ref.read(paystackPaymentNotifier.notifier).setLoading(false);

      _initializeWebView(paymentUrl);
    } catch (e) {
      if (!mounted) return;
      debugPrint('PaystackPaymentScreen: Exception during initialization: $e');
      
      ref.read(paystackPaymentNotifier.notifier).setError('Error: $e');
      ref.read(paystackPaymentNotifier.notifier).setLoading(false);
      
      Fluttertoast.showToast(
        msg: 'Failed to initialize payment: $e',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void _initializeWebView(String paymentUrl) {
    try {
      // Parse the URL to ensure it's valid
      final uri = Uri.parse(paymentUrl);
      
      if (paymentUrl.isEmpty) {
        throw Exception('Payment URL is empty');
      }
      
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              debugPrint('WebView: Page started loading - $url');
              _handleUrlNavigation(url);
            },
            onPageFinished: (String url) {
              debugPrint('WebView: Page finished loading - $url');
              _handleUrlNavigation(url);
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint('WebView Error: ${error.description}');
              String errorMsg = error.description ?? 'Unknown error loading payment page';
              
              // Check for SSL certificate errors on Android
              if (errorMsg.contains('SSL') || errorMsg.contains('certificate')) {
                errorMsg = 'SSL Certificate Error - Please check your internet connection and try again';
              }
              
              // Check for network errors
              if (errorMsg.contains('net::ERR')) {
                errorMsg = 'Network Error - Please check your internet connection and try again';
              }
              
              ref.read(paystackPaymentNotifier.notifier).setError(errorMsg);
              
              Fluttertoast.showToast(
                msg: 'Payment page error: $errorMsg',
                toastLength: Toast.LENGTH_LONG,
              );
            },
          ),
        )
        ..loadRequest(uri);
      
      _webViewInitialized = true;
      debugPrint('WebView initialized successfully with URL: $paymentUrl');
    } catch (e) {
      debugPrint('Error initializing WebView: $e');
      ref.read(paystackPaymentNotifier.notifier).setError('Error initializing payment: $e');
      Fluttertoast.showToast(
        msg: 'Error initializing payment: $e',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void _handleUrlNavigation(String url) {
    // Check if payment was successful
    if (url.contains('successful') || url.contains('reference=${widget.reference}')) {
      ref.read(paystackPaymentNotifier.notifier).setPaymentSuccessful(
        true,
        widget.reference,
      );

      Fluttertoast.showToast(
        msg: 'Payment successful!',
        toastLength: Toast.LENGTH_LONG,
      );

      // Navigate back with success
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          NavigatorService.goBack();
        }
      });
    }

    // Check if payment was cancelled
    if (url.contains('cancelled') || url.contains('fail')) {
      Fluttertoast.showToast(
        msg: 'Payment cancelled',
        toastLength: Toast.LENGTH_LONG,
      );

      if (mounted) {
        NavigatorService.goBack();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paystackPaymentNotifier);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          if (paymentState.paymentUrl.isNotEmpty && _webViewInitialized)
            WebViewWidget(controller: _webViewController)
          else if (paymentState.isLoading || (paymentState.paymentUrl.isNotEmpty && !_webViewInitialized))
            const Center(
              child: LoadingDialog(message: 'Processing payment...'),
            )
          else if (paymentState.error.isNotEmpty)
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error initializing payment',
                      style: CustomTextStyles.titleMediumGray80001,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      paymentState.error,
                      textAlign: TextAlign.center,
                      style: CustomTextStyles.bodySmallErrorContainer,
                    ),
                    SizedBox(height: 24.h),
                    CustomElevatedButton(
                      text: 'Go Back',
                      onPressed: () {
                        NavigatorService.goBack();
                      },
                    ),
                  ],
                ),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 55.h,
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeftBlack,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () {
          NavigatorService.goBack();
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: 'Complete Payment',
        margin: EdgeInsets.only(top: 20.h, bottom: 30.h),
      ),
      styleType: Style.bgOutline,
    );
  }
}