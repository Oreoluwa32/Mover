import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:new_project/services/paystack_services.dart';
import '../../models/paystack_auth_response.dart';
import '../../models/transactions.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/deposit_item_two_model.dart';
import 'notifier/deposit_two_notifier.dart';
import 'widgets/deposit_item_two_widget.dart';
import '../deposit_bottomsheet/deposit_bottomsheet.dart';

class DepositScreenTwo extends ConsumerStatefulWidget {
  final String? amount;
  final String? email;
  final String? reference;
  final Object? channels;
  final Function(Object?) onSuccessfulTransaction;
  final Function(Object?) onFailedTransaction;
  
  const DepositScreenTwo({
    super.key,
    required this.amount,
    required this.email,
    required this.reference,
    this.channels,
    required this.onSuccessfulTransaction,
    required this.onFailedTransaction,
  });

  @override
  DepositScreenTwoState createState() => DepositScreenTwoState();

  // Initialize Paystack services here, such as API endpoints, headers, etc.
  // Future<PaystackAuthResponse> createTransaction(Transactions transactions) async {
  //   // Call the Paystack API to initialize a transaction
  //   // final response = await http.post(
  //   //   Uri.parse('https://api.paystack.co/transaction/initialize'),
  //   //   headers: {
  //   //     'Content-Type': 'application/json',
  //   //   },
  //   // );
  //   const String url = 'https://api.paystack.co/transaction/initialize';
  //   final data = transactions.toJson();

  //   try{
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Authorization': 'Bearer',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(data),
  //     );
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       return PaystackAuthResponse.fromJson(jsonResponse['data']);
  //     } else {
  //       throw ('Failed to initialize transaction: ${response.reasonPhrase}');
  //     }
  //   }
  //   on Exception {
  //     throw ('An error occurred while initializing the transaction');
  //   }
  // }

  // Future<String> initializeTransaction(WidgetRef ref) async {
  //   try{
  //     final price = double.parse(ref.read(depositTwoNotifier).amountController!.text);
  //     final transactions = Transactions(
  //       amount: (price * 100).toInt(),
  //       currency: 'NGN',
  //       email: ref.read(depositTwoNotifier).emailController!.text,
  //       // Add other necessary fields for the transaction
  //     );
  //     final authResponse = await createTransaction(transactions);
  //     return authResponse.authorizationUrl ?? '';
  //   } catch (e) {
  //     throw Exception('Failed to initialize transaction: $e');
  //   }
  // }
}

class DepositScreenTwoState extends ConsumerState<DepositScreenTwo> {
  bool showWebView = false;
  PaystackAuthResponse? paystackResponse;
  bool isLoading = false;
  String? errorMessage;

  // Future<void> _startDeposit(BuildContext context, WidgetRef ref) async {
  //   setState(() {
  //     isLoading = true;
  //     errorMessage = null;
  //   });
  //   try {
  //     final amountText = ref.read(depositTwoNotifier).amountController?.text ?? widget.amount ?? '';
  //     final emailText = ref.read(depositTwoNotifier).emailController?.text ?? widget.email ?? '';
  //     final referenceText = widget.reference ?? '';

  //     // Paystack expects amount in kobo (multiply by 100)
  //     final amountDouble = double.tryParse(amountText) ?? 0;
  //     final amountInt = (amountDouble * 100).toInt();

  //     // Direct Paystack API call with secret key (for testing only)
  //     const String secretKey = 'sk_test_9589d42fc73907f36768aed2f96d4e4ef95b6dcc'; // <-- Replace with your actual secret key
  //     // const String url = 'https://api.paystack.co/transaction/initialize';

  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Authorization': 'Bearer $secretKey',
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'email': emailText,
  //         'amount': amountInt,
  //         'reference': referenceText,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       setState(() {
  //         paystackResponse = PaystackAuthResponse.fromJson(jsonResponse['data']);
  //         showWebView = true;
  //         isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         errorMessage = 'Failed to initialize transaction: ${response.body}';
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = 'Failed to initialize transaction: $e';
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppbar(context),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(left: 16.h, top: 22.h, right: 16.h),
              child: Column(
                children: [
                  _buildAmount(context),
                  SizedBox(height: 16.h),
                  _buildEmail(context),
                  SizedBox(height: 70.h),
                  _buildDivider(context),
                  SizedBox(height: 4.h),
                  // if (isLoading)
                  //   Center(child: CircularProgressIndicator()),
                  // if (errorMessage != null)
                  //   Center(child: Text(errorMessage!, style: TextStyle(color: Colors.red))),
                  // if (showWebView && paystackResponse?.authorizationUrl != null)
                  //   Expanded(
                  //     child: WebViewWidget(
                  //       controller: WebViewController()
                  //         ..loadRequest(Uri.parse(paystackResponse!.authorizationUrl!))
                  //         ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  //         ..setNavigationDelegate(
                  //           NavigationDelegate(
                  //             onPageFinished: (url) {
                  //               if (url.contains('success')) {
                  //                 widget.onSuccessfulTransaction(paystackResponse);
                  //               } else if (url.contains('error')) {
                  //                 widget.onFailedTransaction('Transaction failed');
                  //               }
                  //             },
                  //           ),
                  //         ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildButtonnav(context, ref),
    );
  }

  // Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 92.h,
      leadingWidth: 24.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgChevronLeftBlack,
        margin: EdgeInsets.only(left: 16.h, top: 44.h, bottom: 24.h),
        onTap: () {
          onTapBack(context);
        },
      ),
      centerTitle: true,
      title: AppbarSubtitle(
        text: "Debit/Credit Card",
        margin: EdgeInsets.only(top: 44.h, bottom: 23.h),
      ),
      styleType: Style.bgOutline,
    );
  }

  // Section Widget
  Widget _buildAmount(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Amount",
            style: CustomTextStyles.labelLargeGray600,
          ),
          SizedBox(
            height: 4.h,
          ),
          Consumer(
            builder: (context, ref, _) {
              return CustomTextFormField(
                controller: ref.watch(depositTwoNotifier).amountController,
                hintText: "NGN",
                hintStyle: theme.textTheme.bodySmall!,
                textInputAction: TextInputAction.done,
                contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildEmail(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email",
            style: CustomTextStyles.labelLargeGray600,
          ),
          SizedBox(
            height: 4.h,
          ),
          Consumer(
            builder: (context, ref, _) {
              return CustomTextFormField(
                controller: ref.watch(depositTwoNotifier).emailController,
                hintText: "Enter your email",
                hintStyle: theme.textTheme.bodySmall!,
                textInputAction: TextInputAction.done,
                contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
              );
            },
          )
        ],
      ),
    );
  }

  // Section Wigdet
  Widget _buildDivider(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Divider(
                      thickness: 1.h,
                      color: appTheme.blueGray10002,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Choose payment card",
                    style: CustomTextStyles.labelLargeGray800,
                  ),
                ),
                SizedBox(
                  width: 10.h,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Divider(
                      thickness: 1.h,
                      color: appTheme.blueGray10002,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 22.h,
          ),
          Consumer(
            builder: (context, ref, _) {
              return ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DepositItemTwoModel model = ref
                            .watch(depositTwoNotifier)
                            .depositModelTwoObj
                            ?.depositItemTwoList[index] ??
                        DepositItemTwoModel();
                    return DepositItemTwoWidget(
                      model,
                      changeRadioBtn: (value) {
                        ref
                            .read(depositTwoNotifier.notifier)
                            .changeRadioBtn(index, value);
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 16.h,
                    );
                  },
                  itemCount: ref
                          .watch(depositTwoNotifier)
                          .depositModelTwoObj
                          ?.depositItemTwoList
                          .length ??
                      0);
            },
          ),
          SizedBox(
            height: 22.h,
          ),
          SizedBox(
            width: double.maxFinite,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                        context: context, 
                        builder: (_) => DepositBottomsheet(),
                        isScrollControlled: true,
                        isDismissible: true
                      );
              },
              child: Row(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgPurplePlus,
                    height: 18.h,
                    width: 18.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.h),
                    child: Text(
                      "Add Debit/Credit Card",
                      style: CustomTextStyles.labelLargePurple900,
                    ),
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildButtonnav(BuildContext context, WidgetRef ref) {
    return Container(
      height: 98.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 24.h,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: appTheme.blueGray10002,
            width: 1.h,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomElevatedButton(
            text: "Deposit",
            buttonStyle: CustomButtonStyles.fillBlueGray,
            onPressed: isLoading
                ? null
                : () {
                    // _startDeposit(context, ref);
                  },
          )
        ],
      ),
    );
  }

  // Navigates back to the previous screen
  onTapBack(BuildContext context) {
    NavigatorService.goBack();
  }
}
