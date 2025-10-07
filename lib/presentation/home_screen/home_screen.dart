import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../core/utils/error_boundary.dart';

class HomeScreen extends ConsumerStatefulWidget{
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

// ignore for file, class must be immutable
class HomeScreenState extends ConsumerState<HomeScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorBoundary(
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1.0)),
          child: SingleChildScrollView(
            child: ErrorBoundary(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 812.0,
                child: LayoutBuilder(
                  builder: (BuildContext context, constraints) => Stack(
                    children: [
                      //Map
                      Positioned(
                        left: 0.0,
                        top: 0.0,
                        child: ErrorBoundary(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1.0),
                            ),
                            child: ErrorBoundary(
                              child: LayoutBuilder(
                                builder: (BuildContext context, constraints) => SizedBox(
                                  width: 375.0,
                                  height: 812.0,
                                  child: Container(
                                    child: LayoutBuilder(
                                      builder:
                                          (
                                            BuildContext context,
                                            constraints,
                                          ) => Stack(
                                            children: [
                                              //Map of Birmingham (City)
                                              Positioned(
                                                top: -11.0,
                                                left: -328.63525390625,
                                                child: ErrorBoundary(
                                                  child: CustomImageView(
                                                    imagePath: ImageConstant.imgMap,
                                                    fit: BoxFit.cover,
                                                    width: 1305.2703857421875,
                                                    height: 864.0,
                                                  )
                                                ),
                                              ), //Illustrations
                                              // Positioned(
                                              //   top: -322.0,
                                              //   left: -700.0,
                                              //   child: ErrorBoundary(
                                              //     child: SvgPicture.asset(
                                              //       "assets/images/illustrations.svg",
                                              //       height: 1471.0,
                                              //       width: 1814.0,
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ), //Frame 343
                      Positioned(
                        left: 311.0,
                        top: 516.0,
                        child: ErrorBoundary(
                          child: Container(
                            clipBehavior: Clip.none,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(120.00000762939453),
                                topRight: Radius.circular(120.00000762939453),
                                bottomLeft: Radius.circular(120.00000762939453),
                                bottomRight: Radius.circular(
                                  120.00000762939453,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0.0, 0.0),
                                  blurRadius: 30.0,
                                  spreadRadius: 10.0,
                                  color: Color.fromRGBO(
                                    0,
                                    0,
                                    0,
                                    0.07999999821186066,
                                  ),
                                ),
                              ],
                              color: Color.fromRGBO(255, 255, 255, 1.0),
                              border: Border.all(
                                color: Color.fromRGBO(209, 209, 209, 1.0),
                                width: 1.2000000476837158,
                                style: BorderStyle.solid,
                                strokeAlign: BorderSide.strokeAlignInside,
                              ),
                            ),
                            child: ErrorBoundary(
                              child: Container(
                                width: 48.0,
                                height: 48.0,
                                child: LayoutBuilder(
                                  builder:
                                      (
                                        BuildContext context,
                                        constraints,
                                      ) => Stack(
                                        children: [
                                          //location
                                          Positioned(
                                            top:
                                                (constraints.maxHeight / 2) -
                                                (48.0 / 2 - 11.999993324279785),
                                            left:
                                                (constraints.maxWidth / 2) -
                                                (48.0 / 2 - 11.999993324279785),
                                            child: ErrorBoundary(
                                              child: ErrorBoundary(
                                                child: Container(
                                                  decoration: BoxDecoration(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ), //Frame 431
                      Positioned(
                        top: 48.0,
                        left: 16.0,
                        child: ErrorBoundary(
                          child: Container(
                            decoration: BoxDecoration(),
                            child: ErrorBoundary(
                              child: Container(
                                width: 343.0,
                                height: 40.0,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ErrorBoundary(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: ErrorBoundary(
                                          child: Container(
                                            height: 40.0,
                                            width: 191.0,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ErrorBoundary(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(
                                                          100.00001525878906,
                                                        ),
                                                        topRight:
                                                            Radius.circular(
                                                              100.00001525878906,
                                                            ),
                                                        bottomLeft:
                                                            Radius.circular(
                                                              100.00001525878906,
                                                            ),
                                                        bottomRight:
                                                            Radius.circular(
                                                              100.00001525878906,
                                                            ),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Color.fromRGBO(
                                                            0,
                                                            0,
                                                            0,
                                                            0.10000000149011612,
                                                          ),
                                                          offset: Offset(
                                                            0.0,
                                                            0.0,
                                                          ),
                                                          spreadRadius: 2.0,
                                                          blurRadius: 19.0,
                                                        ),
                                                      ],
                                                      color: Color.fromRGBO(
                                                        255,
                                                        255,
                                                        255,
                                                        1.0,
                                                      ),
                                                    ),
                                                    clipBehavior: Clip.none,
                                                    child: ErrorBoundary(
                                                      child: Container(
                                                        width: 40.0,
                                                        height: 40.0,
                                                        child: LayoutBuilder(
                                                          builder:
                                                              (
                                                                BuildContext
                                                                context,
                                                                constraints,
                                                              ) => Stack(
                                                                children: [
                                                                  //filters
                                                                  Positioned(
                                                                    left:
                                                                        (constraints.maxWidth /
                                                                            2) -
                                                                        (40.0 / 2 -
                                                                            10.999791145324707),
                                                                    top:
                                                                        (constraints.maxHeight /
                                                                            2) -
                                                                        (40.0 / 2 -
                                                                            11.000052452087402),
                                                                    child: ErrorBoundary(
                                                                      child: ErrorBoundary(
                                                                        child: Container(
                                                                          decoration:
                                                                              BoxDecoration(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                ErrorBoundary(
                                                  child: Container(
                                                    clipBehavior: Clip.none,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                        246,
                                                        246,
                                                        246,
                                                        1.0,
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          offset: Offset(
                                                            0.0,
                                                            0.0,
                                                          ),
                                                          blurRadius: 30.0,
                                                          spreadRadius: 10.0,
                                                          color: Color.fromRGBO(
                                                            0,
                                                            0,
                                                            0,
                                                            0.07999999821186066,
                                                          ),
                                                        ),
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                  100.0,
                                                                ),
                                                            topRight:
                                                                Radius.circular(
                                                                  100.0,
                                                                ),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                  100.0,
                                                                ),
                                                            bottomRight:
                                                                Radius.circular(
                                                                  100.0,
                                                                ),
                                                          ),
                                                    ),
                                                    child: ErrorBoundary(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              vertical: 8.0,
                                                              horizontal: 16.0,
                                                            ),
                                                        height: 28.0,
                                                        width: 147.0,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            ErrorBoundary(
                                                              child: CustomImageView(
                                                                imagePath: ImageConstant.imgRedDot,
                                                                width: 6.0,
                                                                height: 6.0,
                                                              )
                                                            ),
                                                            SizedBox(
                                                              width: 6.0,
                                                            ),
                                                            ErrorBoundary(
                                                              child: Text(
                                                                "1000+ routes are live",
                                                                style: CustomTextStyles.interErrorContainer,
                                                              )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ErrorBoundary(
                                      child: Container(
                                        clipBehavior: Clip.none,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(
                                                0,
                                                0,
                                                0,
                                                0.10000000149011612,
                                              ),
                                              offset: Offset(0.0, 0.0),
                                              spreadRadius: 2.0,
                                              blurRadius: 19.0,
                                            ),
                                          ],
                                          color: Color.fromRGBO(
                                            255,
                                            255,
                                            255,
                                            1.0,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                              100.00000762939453,
                                            ),
                                            topRight: Radius.circular(
                                              100.00000762939453,
                                            ),
                                            bottomLeft: Radius.circular(
                                              100.00000762939453,
                                            ),
                                            bottomRight: Radius.circular(
                                              100.00000762939453,
                                            ),
                                          ),
                                        ),
                                        child: ErrorBoundary(
                                          child: Container(
                                            width: 40.0,
                                            height: 40.0,
                                            child: LayoutBuilder(
                                              builder:
                                                  (
                                                    BuildContext context,
                                                    constraints,
                                                  ) => Stack(
                                                    children: [
                                                      //notification-bing
                                                      Positioned(
                                                        left:
                                                            (constraints
                                                                    .maxWidth /
                                                                2) -
                                                            (40.0 / 2 - 11.0),
                                                        top:
                                                            (constraints
                                                                    .maxHeight /
                                                                2) -
                                                            (40.0 / 2 - 11.0),
                                                        child: ErrorBoundary(
                                                          child: ErrorBoundary(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ), //Bottom Navigation
                      Positioned(
                        bottom: 32.0,
                        left: (constraints.maxWidth / 2) - (375.0 / 2 - 16.0),
                        child: ErrorBoundary(
                          child: ErrorBoundary(
                            child: Container(
                              clipBehavior: Clip.none,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 16.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(0.0, -1.840000033378601),
                                    color: Color.fromRGBO(
                                      0,
                                      0,
                                      0,
                                      0.07999999821186066,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ), //Man
                      Positioned(
                        top: 196.5,
                        left: 58.94791030883789,
                        child: ErrorBoundary(
                          child: Container(
                            width: 11.624993324279785,
                            height: 18.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/man.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ), //arrow-left
                      Positioned(
                        left: 306.0,
                        top: 459.0,
                        child: ErrorBoundary(
                          child: ErrorBoundary(
                            child: Container(decoration: BoxDecoration()),
                          ),
                        ),
                      ), //Frame 430
                      Positioned(
                        top: 92.0,
                        left: 16.0,
                        child: ErrorBoundary(
                          child: Container(
                            clipBehavior: Clip.none,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(
                                    0,
                                    0,
                                    0,
                                    0.10000000149011612,
                                  ),
                                  offset: Offset(0.0, 0.0),
                                  spreadRadius: 2.0,
                                  blurRadius: 19.0,
                                ),
                              ],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(100.0),
                                topRight: Radius.circular(100.0),
                                bottomLeft: Radius.circular(100.0),
                                bottomRight: Radius.circular(100.0),
                              ),
                              color: Color.fromRGBO(255, 255, 255, 1.0),
                            ),
                            child: ErrorBoundary(
                              child: Container(
                                width: 34.0,
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 8.0,
                                ),
                                height: 309.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 16.0),
                                    ErrorBoundary(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: ErrorBoundary(
                                          child: Container(
                                            height: 27.0,
                                            width: 18.0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ErrorBoundary(
                                                  child: Container(
                                                    decoration: BoxDecoration(),
                                                  ),
                                                ),
                                                SizedBox(height: 2.0),
                                                ErrorBoundary(
                                                  child: Text(
                                                                "1000+ routes are live",
                                                                style: CustomTextStyles.interErrorContainer,
                                                              )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    ErrorBoundary(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: ErrorBoundary(
                                          child: Container(
                                            height: 27.0,
                                            width: 18.0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ErrorBoundary(
                                                  child: Container(
                                                    decoration: BoxDecoration(),
                                                  ),
                                                ),
                                                SizedBox(height: 2.0),
                                                ErrorBoundary(
                                                  child: Text(
                                                                "1000+ routes are live",
                                                                style: CustomTextStyles.interErrorContainer,
                                                              )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    ErrorBoundary(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: ErrorBoundary(
                                          child: Container(
                                            height: 27.0,
                                            width: 18.0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ErrorBoundary(
                                                  child: Container(
                                                    decoration: BoxDecoration(),
                                                  ),
                                                ),
                                                SizedBox(height: 2.0),
                                                ErrorBoundary(
                                                  child: Text(
                                                                "1000+ routes are live",
                                                                style: CustomTextStyles.interErrorContainer,
                                                              )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    ErrorBoundary(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: ErrorBoundary(
                                          child: Container(
                                            height: 27.0,
                                            width: 18.0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ErrorBoundary(
                                                  child: Container(
                                                    decoration: BoxDecoration(),
                                                  ),
                                                ),
                                                SizedBox(height: 2.0),
                                                ErrorBoundary(
                                                  child: Text(
                                                                "1000+ routes are live",
                                                                style: CustomTextStyles.interErrorContainer,
                                                              )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    ErrorBoundary(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: ErrorBoundary(
                                          child: Container(
                                            height: 27.0,
                                            width: 18.0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ErrorBoundary(
                                                  child: Container(
                                                    decoration: BoxDecoration(),
                                                  ),
                                                ),
                                                SizedBox(height: 2.0),
                                                ErrorBoundary(
                                                  child: Text(
                                                                "1000+ routes are live",
                                                                style: CustomTextStyles.interErrorContainer,
                                                              )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    ErrorBoundary(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: ErrorBoundary(
                                          child: Container(
                                            height: 27.0,
                                            width: 18.0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ErrorBoundary(
                                                  child: Container(
                                                    decoration: BoxDecoration(),
                                                  ),
                                                ),
                                                SizedBox(height: 2.0),
                                                ErrorBoundary(
                                                  child: Text(
                                                                "1000+ routes are live",
                                                                style: CustomTextStyles.interErrorContainer,
                                                              )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    ErrorBoundary(
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: ErrorBoundary(
                                          child: Container(
                                            height: 27.0,
                                            width: 18.0,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ErrorBoundary(
                                                  child: Container(
                                                    decoration: BoxDecoration(),
                                                  ),
                                                ),
                                                SizedBox(height: 2.0),
                                                ErrorBoundary(
                                                  child: Text(
                                                                "1000+ routes are live",
                                                                style: CustomTextStyles.interErrorContainer,
                                                              )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}