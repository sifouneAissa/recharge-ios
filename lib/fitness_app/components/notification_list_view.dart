import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/ui_view/wave_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';

class NotificationListView extends StatefulWidget {
  const NotificationListView(
      {Key? key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.onChangeBody,
      this.parentScrollController})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final ScrollController? parentScrollController;

  final onChangeBody;

  @override
  _NotificationListViewState createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView>
    with TickerProviderStateMixin {
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  var user;

  @override
  void initState() {
    _getUser();
    super.initState();

    widget.parentScrollController?.addListener(() async {
      if (widget.parentScrollController?.position.pixels ==
          widget.parentScrollController?.position.minScrollExtent) {
        await _getUser();
      }
    });
  }

  _getUser() async {
    var auth = await GetData().getAuth();
    setState(() {
      user = auth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: GestureDetector(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                child: Container(
                  margin: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    // color: FitnessAppTheme.nearlyBlackCard,
                    gradient: LinearGradient(colors: [
                      HexColor(FitnessAppTheme.nearlyBlack.value.toString()),
                      // HexColor(FitnessAppTheme.gradiantFc).withOpacity(0.7),
                      HexColor(FitnessAppTheme.gradiantFc),
                      HexColor(FitnessAppTheme.nearlyBlack.value.toString()),

                      HexColor(FitnessAppTheme.gradiantFc),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    border: Border.all(color: Colors.black87),
                    // color: FitnessAppTheme.nearlyBlackCard,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.nearlyDarkREd.withOpacity(0.1),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16, left: 16, right: 16, bottom: 16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    child: Image.asset(
                                      'assets/fitness_app/tab_4s.png',
                                      width: 45,
                                    ),
                                    onTap: () {
                                      widget.onChangeBody();
                                    },
                                  ),
                                  Text(
                                    'الاشعارات',
                                    style: TextStyle(
                                        color: FitnessAppTheme.lightText),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, bottom: 3),
                                        child: Text(
                                          user != null
                                              ? user['ncount'].toString()
                                              : '0',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily:
                                                FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color:
                                                FitnessAppTheme.nearlyDarkREd,
                                          ),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(
                                      //       left: 8, bottom: 8),
                                      //   child: Text(
                                      //     'ml',
                                      //     textAlign: TextAlign.center,
                                      //     style: TextStyle(
                                      //       fontFamily: FitnessAppTheme.fontName,
                                      //       fontWeight: FontWeight.w500,
                                      //       fontSize: 18,
                                      //       letterSpacing: -0.2,
                                      //       color: FitnessAppTheme.nearlyDarkBlue,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 4, top: 2, bottom: 14),
                                  //   child: Text(
                                  //     'of daily goal 3.5L',
                                  //     textAlign: TextAlign.center,
                                  //     style: TextStyle(
                                  //       fontFamily: FitnessAppTheme.fontName,
                                  //       fontWeight: FontWeight.w500,
                                  //       fontSize: 14,
                                  //       letterSpacing: 0.0,
                                  //       color: FitnessAppTheme.darkText,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, right: 4, top: 0, bottom: 10),
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: FitnessAppTheme.nearlyGrey,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        // Padding(
                                        //   padding: const EdgeInsets.only(left: 4),
                                        //   child: Icon(
                                        //     Icons.access_time,
                                        //     color: FitnessAppTheme.grey
                                        //         .withOpacity(0.5),
                                        //     size: 16,
                                        //   ),
                                        // ),
                                        Expanded(
                                          // padding:
                                          //     const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            user != null
                                                ? S
                                                        .of(context)
                                                        .last_notification +
                                                    (user['lst_notification'] !=
                                                            null
                                                        ? user['lst_notification']
                                                            .toString()
                                                        : 'لايوجد')
                                                : '0',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily:
                                                  FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                              letterSpacing: 0.0,
                                              color: FitnessAppTheme.lightText,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 4),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.start,
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.center,
                                    //     children: <Widget>[
                                    //       SizedBox(
                                    //         width: 24,
                                    //         height: 24,
                                    //         child: Image.asset(
                                    //             'assets/fitness_app/bell.png'),
                                    //       ),
                                    //       Flexible(
                                    //         child: Text(
                                    //           'Your bottle is empty, refill it!.',
                                    //           textAlign: TextAlign.start,
                                    //           style: TextStyle(
                                    //             fontFamily:
                                    //                 FitnessAppTheme.fontName,
                                    //             fontWeight: FontWeight.w500,
                                    //             fontSize: 12,
                                    //             letterSpacing: 0.0,
                                    //             color: HexColor('#F65283'),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   width: 34,
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: <Widget>[
                        //       Container(
                        //         decoration: BoxDecoration(
                        //           color: FitnessAppTheme.nearlyWhite,
                        //           shape: BoxShape.circle,
                        //           boxShadow: <BoxShadow>[
                        //             BoxShadow(
                        //                 color: FitnessAppTheme.nearlyDarkBlue
                        //                     .withOpacity(0.4),
                        //                 offset: const Offset(4.0, 4.0),
                        //                 blurRadius: 8.0),
                        //           ],
                        //         ),
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(6.0),
                        //           child: Icon(
                        //             Icons.add,
                        //             color: FitnessAppTheme.nearlyDarkBlue,
                        //             size: 24,
                        //           ),
                        //         ),
                        //       ),
                        //       const SizedBox(
                        //         height: 28,
                        //       ),
                        //       Container(
                        //         decoration: BoxDecoration(
                        //           color: FitnessAppTheme.nearlyWhite,
                        //           shape: BoxShape.circle,
                        //           boxShadow: <BoxShadow>[
                        //             BoxShadow(
                        //                 color: FitnessAppTheme.nearlyDarkBlue
                        //                     .withOpacity(0.4),
                        //                 offset: const Offset(4.0, 4.0),
                        //                 blurRadius: 8.0),
                        //           ],
                        //         ),
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(6.0),
                        //           child: Icon(
                        //             Icons.remove,
                        //             color: FitnessAppTheme.nearlyDarkBlue,
                        //             size: 24,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.only(left: 16, right: 8, top: 16),
                        //   child: Container(
                        //     width: 60,
                        //     height: 160,
                        //     decoration: BoxDecoration(
                        //       color: HexColor('#E8EDFE'),
                        //       borderRadius: const BorderRadius.only(
                        //           topLeft: Radius.circular(80.0),
                        //           bottomLeft: Radius.circular(80.0),
                        //           bottomRight: Radius.circular(80.0),
                        //           topRight: Radius.circular(80.0)),
                        //       boxShadow: <BoxShadow>[
                        //         BoxShadow(
                        //             color: FitnessAppTheme.grey.withOpacity(0.4),
                        //             offset: const Offset(2, 2),
                        //             blurRadius: 4),
                        //       ],
                        //     ),
                        //     child: WaveView(
                        //       percentageValue: 60.0,
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () {
                widget.onChangeBody();
              },
            ),
          ),
        );
      },
    );
  }
}
