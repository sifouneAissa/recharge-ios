import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/constants.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/fitness_app/models/jawaker_list_data.dart';
import 'package:best_flutter_ui_templates/fitness_app/common.dart';
import 'package:best_flutter_ui_templates/fitness_app/models/token_package_data.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

import '../../main.dart';

class TokenPackageListView extends StatefulWidget {
  const TokenPackageListView(
      {Key? key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.callback,
      this.callbackPosition,
      this.parentScrollController
      })
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final callback;
  final callbackPosition;
  final ScrollController? parentScrollController;

  @override
  _TokenPackageListViewState createState() => _TokenPackageListViewState();
}

class _TokenPackageListViewState extends State<TokenPackageListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<JawakerListData> mealsListData = JawakerListData.tabIconsList;
  ScrollController _scrollController = new ScrollController();

  var packages = [];
  var data = [];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _getPackages();
    super.initState();
    _scrollController.addListener(() {
      var max = _scrollController.position.maxScrollExtent;
      var x = _scrollController.position.pixels * 4 / max;
      if (x < 0) x = 0;
      widget.callbackPosition(x.floor());
    });

    widget.parentScrollController?.addListener(() async {
      if (widget.parentScrollController?.position.pixels == widget.parentScrollController?.position.minScrollExtent) {
          await _getPackages();
       }
      });
  }

  _getPackages() async {
    _getOPackages();
    var res = await AuthApi().getTokenPackages();
    var body = jsonDecode(res.body);

    if (body['status']) {
      if(this.mounted)
      setState(() {
        var data = AuthApi().getData(body);
        packages = data['packages'];
      });

      await GetData().updateTokenPackages(packages);
    }
  }

  _getMeals(meal) {
    var meals = [
      meal['type'] == 'recommended' ? S.of(context).recommended : '',
      meal['type'] == 'best_offer' ? S.of(context).best_offer : '',
    ].where((element) => element != '').toList();

    return List<String>.generate(meals.length, (index) => meals[index]);
  }

  _getOPackages() async {
    var p = await GetData().getTokenPackages();

    if (p != null) {
      setState(() {
        packages = jsonDecode(p);
      });
    }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
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
            child: Container(
              height: 250,
              width: double.infinity,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: packages.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count = packages.length > 10 ? 10 : packages.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController?.forward();

                  return JawakerView(
                    data: packages[index],
                    mealsListData: TokenPackageData(
                      imagePath: 'assets/fitness_app/tokens.png',
                      titleTxt: Common.formatNumber(packages[index]['count']),
                      kacl: packages[index]['cost'] + .0,
                      meals: _getMeals(packages[index]),
                      startColor: '#260202',
                      endColor: '#F0AB2B',
                    ),
                    animation: animation,
                    animationController: animationController!,
                    callback: widget.callback,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class JawakerView extends StatefulWidget {
  const JawakerView(
      {Key? key,
      this.mealsListData,
      this.animationController,
      this.animation,
      this.callback,
      this.data})
      : super(key: key);

  final TokenPackageData? mealsListData;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final data;
  final callback;

  @override
  _JawakerViewState createState() => _JawakerViewState();
}

class _JawakerViewState extends State<JawakerView> {
  TextEditingController quantity = TextEditingController();
  var focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    quantity.addListener(() {
      widget.callback(quantity.value.text, widget.data['id'], widget.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - widget.animation!.value), 0.0, 0.0),
            child: SizedBox(
              width: 180,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(focusNode);
                },
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 32, left: 8, right: 8, bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: HexColor(widget.mealsListData!.endColor)
                                    .withOpacity(0.6),
                                offset: const Offset(1.1, 4.0),
                                blurRadius: 8.0),
                          ],
                          gradient: LinearGradient(
                            colors: <HexColor>[
                              HexColor(widget.mealsListData!.startColor),
                              HexColor(FitnessAppTheme.gradiantFc),
                              HexColor(widget.mealsListData!.endColor),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 54, left: 16, right: 16, bottom: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  widget.mealsListData!.titleTxt,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    letterSpacing: 0,
                                    color: FitnessAppTheme.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '',
                                        // widget.mealsListData!.meals!.join('\n'),
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          letterSpacing: 0,
                                          color: FitnessAppTheme.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // widget.mealsListData?.kacl != 0
                              //     ? Row(
                              //         mainAxisAlignment: MainAxisAlignment.start,
                              //         crossAxisAlignment: CrossAxisAlignment.end,
                              //         children: <Widget>[
                              //           Text(
                              //             widget.mealsListData!.kacl.toString(),
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //               fontFamily: FitnessAppTheme.fontName,
                              //               fontWeight: FontWeight.w500,
                              //               fontSize: 24,
                              //               letterSpacing: 0.2,
                              //               color: FitnessAppTheme.white,
                              //             ),
                              //           ),
                              //           Padding(
                              //             padding: const EdgeInsets.only(
                              //                 left: 4, bottom: 3),
                              //             child: Text(
                              //               '\$',
                              //               style: TextStyle(
                              //                 fontFamily:
                              //                     FitnessAppTheme.fontName,
                              //                 fontWeight: FontWeight.w500,
                              //                 fontSize: 20,
                              //                 letterSpacing: 0.2,
                              //                 color: FitnessAppTheme.white,
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       )
                              //     : Container(
                              //         decoration: BoxDecoration(
                              //           color: FitnessAppTheme.nearlyWhite,
                              //           shape: BoxShape.circle,
                              //           boxShadow: <BoxShadow>[
                              //             BoxShadow(
                              //                 color: FitnessAppTheme.nearlyBlack
                              //                     .withOpacity(0.4),
                              //                 offset: Offset(8.0, 8.0),
                              //                 blurRadius: 8.0),
                              //           ],
                              //         ),
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(6.0),
                              //           child: Icon(
                              //             Icons.add,
                              //             color: HexColor(widget.mealsListData!.endColor),
                              //             size: 24,
                              //           ),
                              //         ),
                              //       ),

                              // Container(
                              //     child: TextFormField(
                              //   autovalidateMode:
                              //       AutovalidateMode.onUserInteraction,
                              //   keyboardType: TextInputType.number,
                              //   textInputAction: TextInputAction.next,
                              //   textDirection: TextDirection.rtl,
                              //   controller: quantity,
                              //   focusNode: focusNode,
                              //   onSaved: (email) {},
                              //   decoration: InputDecoration(
                              //     hintText: ' ادخل الكمية',
                              //     hintStyle: TextStyle(
                              //         color: Colors.black, fontSize: 12),
                              //     // prefixIcon: Padding(
                              //     //   padding: const EdgeInsets.all(defaultPadding),
                              //     //   child: Icon(Icons.person,color:FitnessAppTheme.nearlyDarkBlue),
                              //     // ),
                              //   ),
                              // )),
                              Container(
                                // width: 1,
                                child: SpinBox(
                                  max: 100,
                                  value: 0,
                                  step: 1,
                                  spacing: 1,
                                  keyboardType: TextInputType.none,
                                  decoration:
                                      InputDecoration(labelText: 'ادخل الكمية'),
                                      onChanged: (value) {
                                          int quantity = 0;
                                        try{
                                          quantity = value.round();
                                        }catch(error){print(error);}
                                        
                                        widget.callback(quantity, widget.data['id'], widget.data);
                                      },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: 0,
                    //   left: 0,
                    //   child: Container(
                    //     width: 84,
                    //     height: 84,
                    //     decoration: BoxDecoration(
                    //       color: FitnessAppTheme.nearlyWhite.withOpacity(0.2),
                    //       shape: BoxShape.circle,
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      top: 0,
                      left: 8,
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset(widget.mealsListData!.imagePath),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 8,
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset(widget.mealsListData!.imagePath),
                      ),
                    ),
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
