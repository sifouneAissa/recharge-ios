import 'dart:convert';

import 'package:best_flutter_ui_templates/fitness_app/common.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/jawaker_accelerator/add_jawaker_accelerator_form.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/fitness_app/models/jawaker_list_data.dart';
import 'package:best_flutter_ui_templates/fitness_app/models/meals_list_data.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import '../../main.dart';

import 'package:flutter_spinbox/flutter_spinbox.dart';

class JawakerAcceleratorListView extends StatefulWidget {
  const JawakerAcceleratorListView(
      {Key? key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.onSelectCallback})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final onSelectCallback;

  @override
  _JawakerAcceleratorListViewState createState() =>
      _JawakerAcceleratorListViewState();
}

class _JawakerAcceleratorListViewState extends State<JawakerAcceleratorListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  List<JawakerListData> mealsListData = JawakerListData.tabIconsList;
  int? selectedIndex;
  var packages = [];
  var data = [];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _getPackages();
    super.initState();
  }

  _getPackages() async {
    _getOPackages();
    var res = await AuthApi().getPointPackages();
    var body = jsonDecode(res.body);

    if (body['status']) {
      if(this.mounted)
      setState(() {
        var data = AuthApi().getData(body);
        packages = data['packages'];
      });

      await GetData().updatePointPackages(packages);
    }
  }

  _getOPackages() async {
    var p = await GetData().getPointPackages();

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
              height: widget.onSelectCallback != null ? 250 : 200,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: mealsListData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      mealsListData.length > 10 ? 10 : mealsListData.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController?.forward();

                  var package;
                  try {
                    package = packages.firstWhere((element) =>
                        element['code'] == mealsListData[index].value);
                  } catch (error) {}
                  return GestureDetector(
                      onTap: () {
                        if (widget.onSelectCallback != null) {
                          setState(() {
                            selectedIndex = index;
                          });
                          // return widget
                          //     .onSelectCallback(mealsListData[index].value);
                        }
                      },
                      child: JawakerView(
                          isSelected: index == selectedIndex,
                          mealsListData: mealsListData[index],
                          animation: animation,
                          animationController: animationController!,
                          package: package,
                          callback: widget.onSelectCallback));
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
  JawakerView(
      {Key? key,
      this.mealsListData,
      this.animationController,
      this.animation,
      this.isSelected,
      this.package,
      this.callback})
      : super(key: key);


  final JawakerListData? mealsListData;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final isSelected;
  final package;
  final callback;

  @override
  _JawakerView createState() => _JawakerView();
}
class _JawakerView extends State<JawakerView> {
  PackagePointData? selected;
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
              width: widget.callback != null ? 150 : 130 ,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top:  32,
                        left: 8,
                        right: 8,
                        bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: HexColor(widget.mealsListData!.endColor)
                                  .withOpacity(0.2),
                              offset: const Offset(1.1, 4.0),
                              blurRadius:  50 ),
                        ],
                        gradient: LinearGradient(
                          colors: <HexColor>[
                            HexColor(widget.mealsListData!.startColor),
                            HexColor('#3B0656'),
                            HexColor(widget.mealsListData!.endColor),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            top: widget.callback != null ? 10 : 30, left: 16, right: 16, bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.mealsListData!.titleTxt,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0,
                                color: FitnessAppTheme.white,
                              ),
                            ),
                            // Expanded(
                            //   child: Padding(
                            //     padding:
                            //         const EdgeInsets.only(top: 8, bottom: 8),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.start,
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: <Widget>[
                            //         Text(
                            //           widget.mealsListData!.meals!.join('\n'),
                            //           style: TextStyle(
                            //             fontFamily: FitnessAppTheme.fontName,
                            //             fontWeight: FontWeight.w500,
                            //             fontSize: 10,
                            //             letterSpacing: 0,
                            //             color: FitnessAppTheme.white,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            widget.mealsListData?.kacl != 0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        widget.mealsListData!.kacl.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize:  15 ,
                                          letterSpacing: 0,
                                          color: FitnessAppTheme.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, bottom: 3),
                                        child: Text(
                                          '%',
                                          style: TextStyle(
                                            fontFamily:
                                                FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            letterSpacing: 0,
                                            color: FitnessAppTheme.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: FitnessAppTheme.nearlyWhite,
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: FitnessAppTheme.nearlyBlack
                                                .withOpacity(0.4),
                                            offset: Offset(8.0, 8.0),
                                            blurRadius: 8.0),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.add,
                                        color:
                                            HexColor(widget.mealsListData!.endColor),
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(10),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        Common.formatNumber(widget.package!= null ? widget.package['cost'] : 0),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize:  20,
                                          letterSpacing: 0,
                                          color: FitnessAppTheme.white,
                                        ),
                                      ),
                                    ),
                                  ),
                               widget.callback != null 
                                ? 
                                Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: SpinBox(
                                      max: 100,
                                      value: selected != null ? int.parse(selected!.value) + 0.0 : 0,
                                      step: 1,
                                      spacing: 1,
                                      keyboardType: TextInputType.none,
                                      textStyle: TextStyle(color: Colors.white),
                                      iconColor: MaterialStatePropertyAll(
                                          Colors.white),
                                      decoration: InputDecoration(
                                          labelText: 'ادخل الكمية',
                                          labelStyle:
                                              TextStyle(color: Colors.white)),
                                      onChanged: (value) {
                                        int quantity = 0;
                                        try {
                                          quantity = value.round();
                                          if (widget.callback != null) {
                                            setState(() {
                                              selected = new PackagePointData(
                                              packageData: widget.package,
                                              packageId: widget.package['id'].toString(),
                                              value: quantity.toString()
                                            );
                                            });
                                            
                                            if(widget.package!=null)
                                            return widget.callback(selected);
                                          }
                                        } catch (error) {
                                          // print(error);
                                        }
                                      },
                                    ),
                                  )
                                : Container()
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
                  //       color: FitnessAppTheme.nearlyDarkREd.withOpacity(0.07),
                  //       shape: BoxShape.circle,
                  //     ),
                  //   ),
                  // ),
                  Positioned(
                    top: 40,
                    left: 15,
                    // right: 2,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.asset(widget.mealsListData!.imagePath),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
