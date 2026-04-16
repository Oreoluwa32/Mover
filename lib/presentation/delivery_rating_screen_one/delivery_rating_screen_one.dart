import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/app_export.dart';
import '../../data/services/mobility_api_service.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_rating_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'notifier/delivery_rating_notifier.dart';

class DeliveryRatingScreenOne extends ConsumerStatefulWidget{
  const DeliveryRatingScreenOne({Key? key})
    : super(key: key,);

  @override
  DeliveryRatingScreenOneState createState() => DeliveryRatingScreenOneState();
}

class DeliveryRatingScreenOneState extends ConsumerState<DeliveryRatingScreenOne>{
  final MobilityApiService _mobilityApiService = MobilityApiService();
  double _selectedRating = 0;
  bool _isSubmitting = false;
  final Set<String> _selectedTags = <String>{};

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final counterpartyName = args['moverName']?.toString() ?? 'Assigned mover';
    final requestType = args['requestType']?.toString() ?? 'delivery';
    final completionTitle =
        requestType == 'ride' ? 'Ride Sharing Complete' : 'Delivery Complete';
    final selectedTags = _buildSuggestionTags(requestType);
    final descriptionController =
        ref.watch(deliveryRatingNotifier).descrController ?? TextEditingController();

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                left: 8.h,
                top: 52.h,
                right: 8.h,
              ),
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  Text(
                    completionTitle,
                    style: CustomTextStyles.titleMediumGray80001,
                  ),
                  SizedBox(height: 10.h),
                  _buildStackratetext(context, counterpartyName: counterpartyName),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 84.h,
                      right: 82.h,
                    ),
                    child: CustomRatingBar(
                      initialRating: _selectedRating,
                      itemSize: 32,
                      onRatingUpdate: (rating) {
                        setState(() {
                          _selectedRating = rating;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 38.h),
                  _buildColumntitle(
                    context,
                    controller: descriptionController,
                    suggestionTags: selectedTags,
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildColumnpost(
          context,
          counterpartyName: counterpartyName,
          requestType: requestType,
          completionTitle: completionTitle,
          controller: descriptionController,
        ),
      );
  }

  // Section Widget 
  Widget _buildStackratetext(BuildContext context, {required String counterpartyName}){
    return SizedBox(
      height: 202.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgGreenCheck,
            height: 76.1.h,
            width: double.maxFinite,
            alignment: Alignment.center,
          ),
          Text(
            "How would you rate your experience\nwith $counterpartyName",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: CustomTextStyles.titleMediumBlack900.copyWith(height: 1.50,),
          ),
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildColumntitle(
    BuildContext context, {
    required TextEditingController controller,
    required List<String> suggestionTags,
  }){
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 8.h),
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${controller.text.length}/500",
                  style: theme.textTheme.labelLarge,
                ),
                SizedBox(height: 4.h),
                CustomTextFormField(
                  controller: controller,
                  hintText: "Describe your experience",
                  textInputAction: TextInputAction.done,
                  maxLines: 3,
                  onChanged: (_) => setState(() {}),
                  contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
                )
              ],
            ),
          ),
          SizedBox(height: 15.h),
          ...suggestionTags.map(
            (tag) => Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: GestureDetector(
                onTap: () => _toggleSuggestion(tag, controller),
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.h,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedTags.contains(tag)
                        ? theme.colorScheme.primary.withValues(alpha: 0.08)
                        : appTheme.gray10001,
                    borderRadius: BorderRadiusStyle.roundedBorder8,
                    border: Border.all(
                      color: _selectedTags.contains(tag)
                          ? theme.colorScheme.primary.withValues(alpha: 0.35)
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    tag,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.bodySmallBlack900!.copyWith(
                      height: 1.20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Widget 
  Widget _buildColumnpost(
    BuildContext context, {
    required String counterpartyName,
    required String requestType,
    required String completionTitle,
    required TextEditingController controller,
  }){
    return Container(
      height: 62.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomElevatedButton(
            text: _isSubmitting ? "Posting..." : "Post",
            margin: EdgeInsets.only(bottom: 12.h),
            buttonStyle: _selectedRating > 0 && !_isSubmitting
                ? CustomButtonStyles.fillPrimaryTL41
                : CustomButtonStyles.fillBlueGray,
            onPressed: _selectedRating > 0 && !_isSubmitting
                ? () => _submitReview(
                      context,
                      controller: controller,
                      counterpartyName: counterpartyName,
                      requestType: requestType,
                      completionTitle: completionTitle,
                    )
                : null,
          )
        ],
      ),
    );
  }

  List<String> _buildSuggestionTags(String requestType) {
    if (requestType == 'ride') {
      return const <String>[
        'Driver arrived on time and made the trip comfortable',
        'The ride was smooth and communication was clear',
        'I felt safe and well taken care of throughout the trip',
      ];
    }

    return const <String>[
      'Items were handled with care, and everything arrived in perfect condition',
      'Movers were prompt and efficient, completing the delivery on time',
      'Excellent communication throughout, keeping me informed about the delivery',
    ];
  }

  void _toggleSuggestion(String tag, TextEditingController controller) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
        if (controller.text.trim().isEmpty) {
          controller.text = tag;
        }
      }
    });
  }

  Future<void> _submitReview(
    BuildContext context, {
    required TextEditingController controller,
    required String counterpartyName,
    required String requestType,
    required String completionTitle,
  }) async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final matchId = args['matchId']?.toString() ?? '';

    if (matchId.isEmpty) {
      Fluttertoast.showToast(msg: 'Completed task information is missing.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _mobilityApiService.submitMatchReview(
        matchId: matchId,
        rating: _selectedRating.round(),
        comment: controller.text.trim(),
        tags: _selectedTags.toList(),
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.deliveryRatingScreenTwo,
        arguments: {
          'moverName': counterpartyName,
          'requestType': requestType,
          'completionTitle': completionTitle,
        },
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSubmitting = false;
      });
      Fluttertoast.showToast(
        msg: _mobilityApiService.extractErrorMessage(error),
      );
    }
  }
}
