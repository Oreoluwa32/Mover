// import 'package:flutter/material.dart';
// import '../../core/app_export.dart';
// import '../../widgets/custom_bottom_bar.dart';
// import '../../widgets/custom_icon_button.dart';
// import '../../widgets/custom_text_form_field.dart';
// import '../activity_in_progress_page/activity_in_progress_page.dart';
// import '../my_route_page/my_route_page.dart';
// import '../move';

// // ignore for file, must be immutable
// class MyRoutePlusPage extends StatelessWidget{
//   MyRoutePlusPage({Key? key})
//     : super(key: key,);

//   TextEditingController addrouteoneController = TextEditingController();

//   GlobalKey<NavigatorState> navigatorKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: Container(
//           height: 690.h,
//           width: double.maxFinite,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               CustomTextFormField(
//                 controller: addrouteoneController,
//                 hintText: "My Route",
//                 hintStyle: CustomTextStyles.titleMediumOnPrimaryContainer,
//                 textInputAction: TextInputAction.done,
//                 alignment: Alignment.topCenter,
//                 contentPadding: EdgeInsets.fromLTRB(12.h, 12.h, 12.h, 20.h),
//                 borderDecoration: TextFormFieldStyleHelper.outlineGray1,
//               ),
//               Container(
//                 height: SizeUtils.height,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Align(
//                       alignment: Alignment.topCenter,
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                           left: 16.h,
//                           top: 108.h,
//                           right: 16.h,
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             _buildSavedroute1(context),
//                             SizedBox(height: 12.h),
//                             SizedBox(
//                               width: double.maxFinite,
//                               child: _buildSavedroute(
//                                 context, 
//                                 workrouteTwo: "Shoprite",
//                                 gatewayzoneTwo: "Gateway Zone, Magodo Phase II, GRA Lagos State",
//                                 time: "7:30PM",
//                                 monfriTwo: "Mon - Fri",
//                               ),
//                             ),
//                             SizedBox(height: 12.h),
//                             SizedBox(
//                               width: double.maxFinite,
//                               child: _buildSavedroute(
//                                 context,
//                                 workrouteTwo: "My Parents",
//                                 gatewayzoneTwo: "Gateway Zone, Magodo Phase II, GRA Lagos State",
//                                 time: "7:30PM",
//                                 monfriTwo: "Mon - Fri",
//                               ),
//                             ),
//                             SizedBox(height: 12.h),
//                             SizedBox(
//                               width: double.maxFinite,
//                               child: _buildSavedroute(
//                                 context,
//                                 workrouteTwo: "My Parents",
//                                 gatewayzoneTwo: "Gateway Zone, Magodo Phase II, GRA Lagos State",
//                                 time: "7:30PM",
//                                 monfriTwo: "Mon - Fri",
//                               ),
//                             ),
//                             SizedBox(height: 12.h),
//                             SizedBox(
//                               width: double.maxFinite,
//                               child: _buildSavedroute(
//                                 context,
//                                 workrouteTwo: "My Parents",
//                                 gatewayzoneTwo: "Gateway Zone, Magodo Phase II, GRA Lagos State",
//                                 time: "7:30PM",
//                                 monfriTwo: "Mon - Fri",
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: double.maxFinite,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 4.h,
//                         vertical: 154.h,
//                       ),
//                       decoration: AppDecoration.black950,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Spacer(),
//                           _buildColumnclock(context),
//                           CustomIconButton(
//                             height: 68.h,
//                             width: 68.h,
//                             padding: EdgeInsets.all(18.h),
//                             decoration: IconButtonStyleHelper.outlineBlackTL34,
//                             alignment: Alignment.centerRight,
//                             child: CustomImageView(
//                               imagePath: ImageConstant.imgPlus,
//                             ),
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//         bottomNavigationBar: Container(
//           width: double.maxFinite,
//           margin: EdgeInsets.symmetric(horizontal: 16.h),
//           child: _buildBottombar(context),
//         ),
//       ),
//     );
//   }

//   // Section Widget
//   Widget _buildSavedroute1(BuildContext context){
//     return Container(
//       width: double.maxFinite,
//       padding: EdgeInsets.symmetric(
//         horizontal: 14.h,
//         vertical: 12.h,
//       ),
//       decoration: AppDecoration.black100.copyWith(
//         borderRadius: BorderRadiusStyle.roundedBorder8,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(
//             width: double.maxFinite,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Work Route",
//                   style: CustomTextStyles.labelLargeGray800,
//                 ),
//                 Spacer(),
//                 Align(
//                   alignment: Alignment.topCenter,
//                   child: Container(
//                     height: 6.h,
//                     width: 6.h,
//                     margin: EdgeInsets.only(top: 4.h),
//                     decoration: BoxDecoration(
//                       color: appTheme.redA700,
//                       borderRadius: BorderRadius.circular(3.h,),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 4.h),
//                   child: Text(
//                     "Live",
//                     style: CustomTextStyles.labelMediumInterRedA700,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           SizedBox(height: 6.h),
//           SizedBox(
//             width: double.maxFinite,
//             child: _buildRowgatewayzone(
//               context,
//               gatewayzoneOne: "Gateway Zone, Magodo Phase II, GRA Lagos State",
//               time: "7:30PM",
//               monfriOne: "Mon - Fri",
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   // Section Widget
//   Widget _buildColumnclock(BuildContext context){
//     return Container(
//       width: double.maxFinite,
//       margin: EdgeInsets.symmetric(horizontal: 10.h),
//       padding: EdgeInsets.symmetric(horizontal: 4.h),
//       child: Column(
//         children: [
//           SizedBox(
//             width: double.maxFinite,
//             child: GestureDetector(
//               onTap: () {},
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 16.h,
//                       vertical: 6.h,
//                     ),
//                     decoration: AppDecoration.shadowx1.copyWith(
//                       borderRadius: BorderRadiusStyle.roundedBorder4,
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           "Instant route",
//                           style: CustomTextStyles.bodySmallInterErrorContainer,
//                         )
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 8.h),
//                     child: CustomIconButton(
//                       height: 40.h,
//                       width: 40.h,
//                       padding: EdgeInsets.all(10.h),
//                       decoration: IconButtonStyleHelper.outlineBlackTL201,
//                       child: CustomImageView(
//                         imagePath: ,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     )
//   }
// }