import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/common.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';

class AccountCardView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;
  final ScrollController? parentScrollController;
  final bool? isPoint;
  const AccountCardView(
      {Key? key,
      this.animationController,
      this.animation,
      this.parentScrollController,
      this.isPoint})
      : super(key: key);

  @override
  _AccountCardView createState() => _AccountCardView();
}

class _AccountCardView extends State<AccountCardView> {
  var user;
  bool _loading = false;

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
    _loading = !_loading;
    var auth = await GetData().getAuth();
    if(this.mounted)
    setState(() {
      user = auth;
    });

    // update user
    var res = await AuthApi().getUser();

    var data = await AuthApi().getData(jsonDecode(res.body));
    // print('data');
    // print(data);
    if(this.mounted)
    setState(() {
      user = data['user'];
    });


    await AuthApi().updateUser(data);

    _loading = !_loading;
  }

  getCash() {
    String textToShow = '';
    bool forPoint = widget.isPoint != null;
    if (!forPoint)
      textToShow = user != null && user['cash'] != null
          ? Common.formatNumber(user['cash'])
          : '0';
    else
      textToShow = user != null && user['cash_point'] != null
          ? Common.formatNumber(user['cash_point'])
          : '0';

    return textToShow;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  // color: FitnessAppTheme.nearlyBlackCard,
                  gradient: LinearGradient(colors: [
                    HexColor('00FFFFFF').withOpacity(0.5),
                    HexColor(FitnessAppTheme.nearlyBlack.value.toString()),
                    HexColor(FitnessAppTheme.gradiantFc),
                    HexColor(FitnessAppTheme.nearlyBlack.value.toString()),
                    HexColor(FitnessAppTheme.gradiantFc),
                    
                    HexColor('00FFFFFF').withOpacity(0.5),
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  border: Border.all(color: Colors.black87),
                  // border: Border.all(color: Colors.black26),
                  // color: FitnessAppTheme.nearlyBlackCard,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.nearlyDarkREd.withOpacity(0.1),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 0, left: 16, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 4, bottom: 8, top: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).balance,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      color: FitnessAppTheme.lightText),
                                ),
                                _loading
                                    ? Container(
                                        margin: EdgeInsets.only(right: 3),
                                        child: Image.asset(
                                          'assets/icons/loading.gif',
                                          width: 20,
                                        ))
                                    : Container()
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 0, left: 0, bottom: 3),
                                    child: Container(
                                      child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            getCash(),
                                            softWrap: false,
                                            textAlign: TextAlign.center,
                                            // overflow: TextOverflow.fade,
                                            style: TextStyle(
                                              fontFamily:
                                                  FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 32,
                                              color:
                                                  FitnessAppTheme.nearlyWhite,
                                            ),
                                          )),
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //       left: 8, bottom: 8),
                                  //   child: Text(
                                  //     'Ibs',
                                  //     textAlign: TextAlign.center,
                                  //     style: TextStyle(
                                  //       fontFamily: FitnessAppTheme.fontName,
                                  //       fontWeight: FontWeight.w500,
                                  //       fontSize: 18,
                                  //       letterSpacing: -0.2,
                                  //       color: FitnessAppTheme.nearlyDarkREd,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   crossAxisAlignment: CrossAxisAlignment.end,
                              //   children: <Widget>[
                              //     Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: <Widget>[
                              //         Icon(
                              //           Icons.access_time,
                              //           color: FitnessAppTheme.grey
                              //               .withOpacity(0.5),
                              //           size: 16,
                              //         ),
                              //         Padding(
                              //           padding:
                              //               const EdgeInsets.only(left: 4.0),
                              //           child: Text(
                              //             user != null ? user['name'] : '',
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //               fontFamily:
                              //                   FitnessAppTheme.fontName,
                              //               fontWeight: FontWeight.w500,
                              //               fontSize: 14,
                              //               letterSpacing: 0.0,
                              //               color: FitnessAppTheme.grey
                              //                   .withOpacity(0.5),
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //     Padding(
                              //       padding: const EdgeInsets.only(
                              //           top: 4, bottom: 14),
                              //       child: Text(
                              //         user != null ? user['email'] : '',
                              //         textAlign: TextAlign.center,
                              //         style: TextStyle(
                              //           fontFamily: FitnessAppTheme.fontName,
                              //           fontWeight: FontWeight.w500,
                              //           fontSize: 12,
                              //           letterSpacing: 0.0,
                              //           color: FitnessAppTheme.nearlyDarkREd,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 4, bottom: 4),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.nearlyGrey,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  user != null
                                      ? user['tpcountd'].toString()
                                      : '0',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                    color: FitnessAppTheme.lightText,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Image.asset(
                                    'assets/fitness_app/tab_3s.png',
                                    width: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      user != null
                                          ? user['ttcountd'].toString()
                                          : '0',
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: FitnessAppTheme.lightText,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Image.asset(
                                        'assets/fitness_app/tab_2s.png',
                                        width: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      user != null
                                          ? user['ncountd'].toString()
                                          : '0',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: FitnessAppTheme.lightText,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Icon(
                                        Icons.notifications_active,
                                        color: FitnessAppTheme.nearlyDarkREd,
                                        size: 20.0,
                                        semanticLabel:
                                            'Text to announce in accessibility modes',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
