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

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    try {
      ref.read(paystackPaymentNotifier.notifier).setLoading(true);

      final paymentUrl = await _paystackServices.getPaymentUrl(
        amount: widget.amount,
        email: widget.email,
        reference: widget.reference,
      );

      if (!mounted) return;

      ref.read(paystackPaymentNotifier.notifier).setPaymentUrl(paymentUrl);
      ref.read(paystackPaymentNotifier.notifier).setLoading(false);

      _initializeWebView(paymentUrl);
    } catch (e) {
      if (!mounted) return;
      ref.read(paystackPaymentNotifier.notifier).setError(e.toString());
      ref.read(paystackPaymentNotifier.notifier).setLoading(false);
      
      Fluttertoast.showToast(
        msg: 'Failed to initialize payment: $e',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void _initializeWebView(String paymentUrl) {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            _handleUrlNavigation(url);
          },
          onPageFinished: (String url) {
            _handleUrlNavigation(url);
          },
          onWebResourceError: (WebResourceError error) {
            Fluttertoast.showToast(
              msg: 'Payment page error: ${error.description}',
              toastLength: Toast.LENGTH_LONG,
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));
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
          if (paymentState.paymentUrl.isNotEmpty)
            WebViewWidget(controller: _webViewController)
          else if (paymentState.isLoading)
            const Center(
              child: LoadingDialog(message: 'Processing payment...'),
            )
          else if (paymentState.error.isNotEmpty)
            Center(
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