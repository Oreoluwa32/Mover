import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';
import '../payment_bottomsheet/payment_bottomsheet.dart';

class HireMoverScreenOne extends ConsumerStatefulWidget {
  const HireMoverScreenOne({Key? key}) : super(key: key);

  @override
  HireMoverScreenOneState createState() => HireMoverScreenOneState();
}

class HireMoverScreenOneState extends ConsumerState<HireMoverScreenOne> {
  bool _offerAccepted = false;

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final offerData =
        Map<String, dynamic>.from(args['offerData'] as Map? ?? const <String, dynamic>{});
    final travelPlan =
        Map<String, dynamic>.from(offerData['travel_plan'] as Map? ?? const <String, dynamic>{});
    final createdBy =
        Map<String, dynamic>.from(travelPlan['created_by'] as Map? ?? const <String, dynamic>{});
    final metadata =
        Map<String, dynamic>.from(travelPlan['metadata'] as Map? ?? const <String, dynamic>{});

    final moverName = createdBy['full_name']?.toString() ?? 'Nearby mover';
    final moverLocation = createdBy['current_city']?.toString().isNotEmpty == true
        ? createdBy['current_city']!.toString()
        : travelPlan['origin_name']?.toString() ?? 'Route available';
    final vehicleType = _titleCase(
      travelPlan['vehicle_type']?.toString().replaceAll('_', ' ') ?? 'Car',
    );
    final completedJobs = _safeInt(
      createdBy['completed_jobs'] ?? metadata['completed_jobs'],
    );
    final ratingCount = _safeInt(
      createdBy['rating_count'] ?? metadata['rating_count'],
    );
    final socialLinks = Map<String, dynamic>.from(
      createdBy['linked_socials'] as Map? ??
          metadata['linked_socials'] as Map? ??
          const <String, dynamic>{},
    );
    final reviews = (offerData['reviews'] as List? ?? const [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
    final badgeCodes = _buildBadgeCodes(createdBy, metadata);
    final matchId = offerData['id']?.toString() ?? '';
    final hasPricedOffer = offerData['agreed_price'] != null;
    final hasAcceptableOffer = matchId.isNotEmpty && hasPricedOffer;
    final isAccepted = _offerAccepted || offerData['status']?.toString() == 'accepted';
    final agreedPrice = offerData['agreed_price'] ?? travelPlan['price_per_seat'] ?? 0;
    final priceLabel = '\u20A6${_formatMoney(agreedPrice)}';
    final averageRating = _safeDouble(
      createdBy['average_rating'] ?? metadata['average_rating'],
    );

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: _buildAppBar(context),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(left: 16.h, top: 24.h, right: 16.h),
        child: Column(
          children: [
            _buildHeader(
              moverName: moverName,
              moverLocation: moverLocation,
              vehicleType: vehicleType,
              completedJobs: completedJobs,
              ratingCount: ratingCount,
              averageRating: averageRating,
              priceLabel: priceLabel,
              badgeCodes: badgeCodes,
            ),
            SizedBox(height: 24.h),
            Container(
              width: double.maxFinite,
              height: 1.h,
              color: appTheme.gray20001,
            ),
            SizedBox(height: 24.h),
            _buildReviewsRow(
              ratingCount: ratingCount,
              socialLinks: socialLinks,
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: _buildReviewsContent(
                reviews: reviews,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAction(
        context,
        offerData: offerData,
        hasPricedOffer: hasPricedOffer,
        hasAcceptableOffer: hasAcceptableOffer,
        isAccepted: isAccepted,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgLeftArrow,
        margin: EdgeInsets.only(left: 16.h, top: 1.h),
        onTap: () {
          NavigatorService.goBack();
        },
      ),
      centerTitle: true,
      title: AppbarTitle(text: 'Mover'),
    );
  }

  Widget _buildHeader({
    required String moverName,
    required String moverLocation,
    required String vehicleType,
    required int completedJobs,
    required int ratingCount,
    required double averageRating,
    required String priceLabel,
    required List<String> badgeCodes,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgProfile,
          height: 76.h,
          width: 76.h,
          radius: BorderRadius.circular(38.h),
          alignment: Alignment.topCenter,
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      moverName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (badgeCodes.isNotEmpty)
                    Wrap(
                      spacing: 4.h,
                      runSpacing: 4.h,
                      children: badgeCodes
                          .map((badge) => _buildBadgeChip(badge))
                          .toList(),
                    ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      moverLocation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.bodySmallInterGray600,
                    ),
                  ),
                  SizedBox(width: 6.h),
                  CustomImageView(
                    imagePath: _vehicleIconFor(vehicleType),
                    height: 14.h,
                    width: 14.h,
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                'Completed jobs: $completedJobs',
                style: CustomTextStyles.labelMediumGray80001,
              ),
              SizedBox(height: 4.h),
              Text(
                ratingCount > 0
                    ? '${averageRating.toStringAsFixed(1)} average rating'
                    : 'No ratings or reviews',
                style: CustomTextStyles.bodySmallInterGray600,
              ),
            ],
          ),
        ),
        SizedBox(width: 12.h),
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Text(
            priceLabel,
            style: theme.textTheme.titleSmall?.copyWith(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsRow({
    required int ratingCount,
    required Map<String, dynamic> socialLinks,
  }) {
    return Row(
      children: [
        Text(
          'Reviews ($ratingCount)',
          style: CustomTextStyles.titleSmallMedium?.copyWith(color: Colors.black87),
        ),
        const Spacer(),
        _buildSocialIcon(ImageConstant.imgFacebook, socialLinks['facebook']),
        SizedBox(width: 16.h),
        _buildSocialIcon(ImageConstant.imgInstagram, socialLinks['instagram']),
        SizedBox(width: 16.h),
        _buildSocialIcon(ImageConstant.imgLinkedin, socialLinks['linkedin']),
      ],
    );
  }

  Widget _buildReviewsContent({
    required List<Map<String, dynamic>> reviews,
  }) {
    if (reviews.isEmpty) {
      return Center(
        child: Text(
          'No ratings or reviews',
          style: CustomTextStyles.labelLargeBluegray400,
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) => _buildReviewCard(reviews[index]),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final reviewer = Map<String, dynamic>.from(
      review['reviewer'] as Map? ?? const <String, dynamic>{},
    );
    final reviewerName = reviewer['full_name']?.toString().trim().isNotEmpty == true
        ? reviewer['full_name'].toString().trim()
        : 'Anonymous user';
    final comment = review['comment']?.toString().trim() ?? '';
    final rating = _safeDouble(review['rating']);
    final createdAt = _formatReviewDate(review['created_at']?.toString());
    final tags = (review['tags'] as List? ?? const [])
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(16.h),
        border: Border.all(
          color: appTheme.gray20001,
          width: 1.h,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.h,
                height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: appTheme.deepPurple50,
                  borderRadius: BorderRadius.circular(20.h),
                ),
                child: Text(
                  reviewerName.substring(0, 1).toUpperCase(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewerName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (starIndex) => Padding(
                            padding: EdgeInsets.only(right: 2.h),
                            child: Icon(
                              starIndex < rating.round()
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              size: 16.h,
                              color: const Color(0xFFF7B500),
                            ),
                          ),
                        ),
                        if (createdAt.isNotEmpty) ...[
                          SizedBox(width: 8.h),
                          Text(
                            createdAt,
                            style: CustomTextStyles.bodySmallInterGray600,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (comment.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              comment,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: appTheme.gray80001,
                height: 1.45,
              ),
            ),
          ],
          if (tags.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.h,
              runSpacing: 8.h,
              children: tags.map(_buildReviewTag).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.h),
      decoration: BoxDecoration(
        color: appTheme.gray100,
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: Text(
        tag,
        style: CustomTextStyles.bodySmallInterGray600.copyWith(
          color: appTheme.gray80001,
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String imagePath, dynamic link) {
    final isEnabled = link != null && link.toString().trim().isNotEmpty;
    return Opacity(
      opacity: isEnabled ? 1 : 0.55,
      child: CustomImageView(
        imagePath: imagePath,
        height: 18.h,
        width: 18.h,
      ),
    );
  }

  Widget _buildBadgeChip(String label) {
    return Container(
      width: 16.h,
      height: 16.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(3.h),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 9.fSize,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }

  Widget _buildBottomAction(
    BuildContext context, {
    required Map<String, dynamic> offerData,
    required bool hasPricedOffer,
    required bool hasAcceptableOffer,
    required bool isAccepted,
  }) {
    return Container(
      height: 98.h,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 24.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 1),
        border: Border(
          top: BorderSide(color: appTheme.gray20001, width: 1.h),
        ),
      ),
      child: CustomElevatedButton(
        text: isAccepted
            ? 'Mover Selected'
            : hasPricedOffer
                ? 'Hire mover'
                : 'Waiting for price',
        buttonStyle: hasPricedOffer && !isAccepted
            ? CustomButtonStyles.fillPrimaryTL41
            : CustomButtonStyles.fillBlueGray,
        buttonTextStyle: CustomTextStyles.titleMediumOnPrimary,
        onPressed: isAccepted
            ? null
            : () => _openPaymentBottomsheet(
                  context,
                  offerData: offerData,
                  hasAcceptableOffer: hasAcceptableOffer,
                ),
      ),
    );
  }

  String _vehicleIconFor(String vehicleType) {
    final normalized = vehicleType.toLowerCase();
    if (normalized.contains('bike')) {
      return ImageConstant.imgBlackBike;
    }
    if (normalized.contains('walk')) {
      return ImageConstant.imgBlackManWalk;
    }
    return ImageConstant.imgBlackCar;
  }

  List<String> _buildBadgeCodes(
    Map<String, dynamic> createdBy,
    Map<String, dynamic> metadata,
  ) {
    final rawBadges = createdBy['badges'] ?? metadata['badges'];
    if (rawBadges is List) {
      final values = rawBadges
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .take(5)
          .toList();
      if (values.isNotEmpty) {
        return values;
      }
    }

    final homeAwayLabel = createdBy['home_away_label']?.toString();
    if (homeAwayLabel == 'away') {
      return const ['A'];
    }
    if (homeAwayLabel == 'home') {
      return const ['H'];
    }
    return const <String>[];
  }

  int _safeInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  double _safeDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _formatMoney(dynamic value) {
    final number = double.tryParse(value?.toString() ?? '') ?? 0;
    if (number == number.roundToDouble()) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(2);
  }

  String _titleCase(String value) {
    return value
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  String _formatReviewDate(String? rawValue) {
    if (rawValue == null || rawValue.isEmpty) {
      return '';
    }
    final parsed = DateTime.tryParse(rawValue)?.toLocal();
    if (parsed == null) {
      return '';
    }
    final month = _monthShort(parsed.month);
    return '$month ${parsed.day}';
  }

  String _monthShort(int month) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Future<void> _openPaymentBottomsheet(
    BuildContext context, {
    required Map<String, dynamic> offerData,
    required bool hasAcceptableOffer,
  }) async {
    if (!hasAcceptableOffer) {
      Fluttertoast.showToast(
        msg: 'This mover has not submitted a bid yet.',
      );
      return;
    }

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final result = await showModalBottomSheet<bool>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.h),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return PaymentBottomsheet(
          offerData: offerData,
          requestType: args['requestType']?.toString(),
          requestData: Map<String, dynamic>.from(
            args['requestData'] as Map? ?? const <String, dynamic>{},
          ),
        );
      },
    );

    if (result == true && mounted) {
      setState(() {
        _offerAccepted = true;
      });
    }
  }
}
