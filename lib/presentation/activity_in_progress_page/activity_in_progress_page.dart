// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../core/app_export.dart';
// import '../../theme/custom_button_style.dart';
// import '../../widgets/app_bar/appbar_subtitle.dart';
// import '../../widgets/app_bar/custom_app_bar.dart';
// import '../../widgets/app_bar/appbar_trailing_image.dart';
// import '../../widgets/custom_elevated_button.dart';
// import '../../widgets/custom_icon_button.dart';
// import '../../widgets/custom_text_form_field.dart';

// // ignore for file, msut be immutable
// class ActivityInProgressPage extends StatelessWidget{
//   ActivityInProgressPage({Key? key})
//     : super(key: key,);

//   TextEditingController activevalueoneController = TextEditingController();
//   Completer<GoogleMapController> googleMapController = Completer();
//   Completer<GoogleMapController> googleMapController1 = Completer();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         body: SizedBox(
//           width: double.maxFinite,
//           child: Column(
//             children: [
//               _buildAddroute(context),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Container(
//                     width: double.maxFinite,
//                     padding: EdgeInsets.symmetric(horizontal: 16.h),
//                     child: Column(
//                       children: [
//                         SizedBox(height: 32.h),
//                         _buildTripcard(context),
//                         SizedBox(height: 16.h),
//                         _buildTripcard1(context)
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Section Widget 
//   Widget _buildAddroute(BuildContext context){
//     return Container(
//       width: double.maxFinite,
//       decoration: AppDecoration.outlineGray20001,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(height: 42.h),
//           CustomAppBar(
//             height: 26.h,
//             centerTitle: true,
//             title: AppbarSubtitle(
//               text: "Activity",
//             ),
//             actions: [
//               AppbarTrailingImage(
//                 imagePath: ImageConstant.imgFi,
//               )
//             ],
//           )
//         ],
//       ),
//     )
//   }
// }