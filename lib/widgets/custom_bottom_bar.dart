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
  Widget build (BuildContext context){
    return SizedBox(
      height: 61.h,
      width: 343.h,
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          if(bottomMenuList[index].isCircle){
            return BottomNavigationBarItem(
              icon: SizedBox(
                height: 88.17.h,
                width: 69.h,
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () {},
                      constraints: BoxConstraints(
                        minHeight: 49.83.h,
                        minWidth: 49.83.h,
                      ),
                      padding: EdgeInsets.all(0),
                      icon: Container(
                        width: 49.83.h,
                        height: 49.83.h,
                        decoration: BoxDecoration(
                          color: Color(0XFF6A19D3),
                          borderRadius: BorderRadius.circular(
                            24.915.h,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0X26000000),
                              spreadRadius: 2.h,
                              blurRadius: 2.h,
                              offset: Offset(
                                0, 
                                3.833333730697632,
                              ),
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(13.410004.h),
                        child: CustomImageView(
                          imagePath: bottomMenuList[index].icon,
                          color: Color(0XFF6D6D6D),
                        ),
                      ),
                    ),
                    CustomImageView(
                      imagePath: bottomMenuList[index].icon,
                      height: 61.33.h,
                      width: 69.h,
                      color: Color(0XFF6D6D6D),
                    )
                  ],
                ),
              ),
              label: '',
            );
          }
          return BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 10.h,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary.withOpacity(1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    imagePath: bottomMenuList[index].icon,
                    height: 18.h,
                    width: 18.h,
                    color: Color(0XFF6D6D6D),
                  ),
                  SizedBox(height: 2.h,),
                  Text(
                    bottomMenuList[index].title ?? "",
                    style: CustomTextStyles.bodySmallGray400!.copyWith(
                      color: Color(0XFF6D6D6D),
                    ),
                  ),
                ],
              ),
            ),
            activeIcon: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 10.h,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary.withOpacity(1),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(12.h),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    imagePath: bottomMenuList[index].activeIcon,
                    height: 18.h,
                    width: 18.h,
                    color: Color(0XFF6A19D3),
                  ),
                  Text(
                    bottomMenuList[index].title ?? "",
                    style: CustomTextStyles.bodySmallGray400!.copyWith(
                      color: Color(0XFF6A19D3),
                    ),
                  )
                ],
              ),
            ),
            label: '',
          );
        }),
        onTap: (index) {
          selectedIndex = index;
          widget.onChanged?.call(bottomMenuList[index].type);
          setState(() {});
        },
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