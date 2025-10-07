import 'package:flutter/material.dart';
import '../core/app_export.dart';

enum BottomBarEnum {Home, Route, Move, Activity, Profile}

// Ignore for file: must be immutable
class CustomBottomBar extends StatefulWidget{
  CustomBottomBar({this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState createState() => CustomBottomBarState();
}

// Ignore for file: must be immutable
class CustomBottomBarState extends State<CustomBottomBar>{
  int selectedIndex = 0;

  List<BottomMenuMode1> bottomMenuList = [
    BottomMenuMode1(
      icon: ImageConstant.imgNavHome,
      activeIcon: ImageConstant.imgNavHomeSelected,
      title: "Home",
      type: BottomBarEnum.Home,
    ),
    BottomMenuMode1(
      icon: ImageConstant.imgNavRoute,
      activeIcon: ImageConstant.imgNavRouteSelected,
      title: "Route",
      type: BottomBarEnum.Route,
    ),
    BottomMenuMode1(
      icon: ImageConstant.imgNavCardinal,
      activeIcon: ImageConstant.imgNavCardinal,
      type: BottomBarEnum.Move,
      isCircle: true,
    ),
    BottomMenuMode1(
      icon: ImageConstant.imgNavActivity,
      activeIcon: ImageConstant.imgNavActivitySelected,
      title: "Activity",
      type: BottomBarEnum.Activity,
    ),
    BottomMenuMode1(
      icon: ImageConstant.imgProfile,
      activeIcon: ImageConstant.imgProfile,
      title: "Profile",
      type: BottomBarEnum.Profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main bottom bar container with cutout
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: Container(
              height: 60.h,
              margin: EdgeInsets.symmetric(horizontal: 16.h),
              child: CustomPaint(
                painter: BottomBarPainter(),
                child: Container(
                  height: 60.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Home
                      _buildBottomBarItem(0),
                      // Route
                      _buildBottomBarItem(1),
                      // Empty space for center button
                      SizedBox(width: 60.h),
                      // Activity
                      _buildBottomBarItem(3),
                      // Profile
                      _buildBottomBarItem(4),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Center circular button (Move) - positioned over the cutout
          Positioned(
            bottom: 55.h, // Adjusted to sit perfectly in the cutout
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  selectedIndex = 2;
                  widget.onChanged?.call(BottomBarEnum.Move);
                  setState(() {});
                },
                child: Container(
                  width: 50.h,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Color(0xFF6A19D3),
                    shape: BoxShape.circle,
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Color(0xFF6A19D3).withValues(alpha: 0.3),
                    //     blurRadius: 15.h,
                    //     offset: Offset(0, 5),
                    //   ),
                    // ],
                  ),
                  child: Center(
                    child: CustomImageView(
                      imagePath: bottomMenuList[2].icon,
                      height: 24.h,
                      width: 24.h,
                      color: Colors.white,
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

  Widget _buildBottomBarItem(int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        selectedIndex = index;
        widget.onChanged?.call(bottomMenuList[index].type);
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImageView(
              imagePath: isSelected 
                  ? bottomMenuList[index].activeIcon 
                  : bottomMenuList[index].icon,
              height: 20.h,
              width: 20.h,
              color: isSelected ? Color(0xFF6A19D3) : Color(0xFF9E9E9E),
            ),
            SizedBox(height: 4.h),
            Text(
              bottomMenuList[index].title ?? "",
              style: TextStyle(
                fontSize: 10.h,
                color: isSelected ? Color(0xFF6A19D3) : Color(0xFF9E9E9E),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ignore for file, must be immutable
class BottomMenuMode1{
  BottomMenuMode1(
    {
      required this.icon,
      required this.activeIcon,
      this.title,
      required this.type,
      this.isCircle = false
    }
  );

  String icon;
  String activeIcon;
  String? title;
  BottomBarEnum type;
  bool isCircle;
}

class DefaultWidget extends StatelessWidget{
  const DefaultWidget({super.key});

//   final Widget child;

//   @override
//   Widget build(BuildContext context){
//     return Navigator(
//       onGenerateRoute: (settings) {
//         return MaterialPageRoute(
//           builder: (context) => child
//         );
//       },
//     );
//   }
// }


  @override
  Widget build(BuildContext context){
    return Container(
      color: Color(0XFFFFFFFF),
      padding: EdgeInsets.all(0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Custom painter to create the bottom bar with cutout effect
class BottomBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Save layer for blend mode to work properly
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    // First, draw the shadow
    Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5);

    // Create shadow path (full rectangle with rounded corners)
    Path shadowPath = _createFullBarPath(size);
    canvas.drawPath(shadowPath.shift(Offset(0, 2)), shadowPaint);

    // Draw the main bar (full rectangle with white color)
    Paint backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path fullBarPath = _createFullBarPath(size);
    canvas.drawPath(fullBarPath, backgroundPaint);

    // Now create the transparent cutout by using BlendMode.clear
    Paint cutoutPaint = Paint()
      ..color = Colors.white // Color doesn't matter with BlendMode.clear
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.clear;

    // Draw the cutout circle to make it transparent
    double cutoutRadius = 35.0;
    double cutoutCenterX = size.width / 2;
    canvas.drawCircle(
      Offset(cutoutCenterX, 0),
      cutoutRadius,
      cutoutPaint,
    );

    // Restore the layer
    canvas.restore();
  }

  Path _createFullBarPath(Size size) {
    Path path = Path();
    double cornerRadius = 20.0;

    // Create a rounded rectangle for the full bar
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(cornerRadius),
      ),
    );
    
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}