import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:best_flutter_ui_templates/constants.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_home_screen.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/fitness_app/ui_view/body_measurement.dart';
import 'package:best_flutter_ui_templates/fitness_app/ui_view/title_view.dart';
import 'package:best_flutter_ui_templates/home/account_card_view.dart';
import 'package:best_flutter_ui_templates/home/info2_card_view.dart';
import 'package:best_flutter_ui_templates/home/info_card_view.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'model/homelist.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<HomeList> homeList = HomeList.homeList;

  AnimationController? animationController;
  bool multiple = true;
  var user;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  _getUser() async {
    var auth = await GetData().getAuth();

    setState(() {
      user = auth;
    });

    // update user
    var res = await AuthApi().getUser();

    var data = await AuthApi().getData(jsonDecode(res.body));

    var body = jsonDecode(res.body);
    
      if(body['status']){
        setState(() {
          user = data['user'];
        });

        await AuthApi().updateUser(data);
          }
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  handleSnackBarError() {
    final snackBar = SnackBar(
      content: Text('حسابك قيد التفعيل الرجاء الانتظار'),
      // action: SnackBarAction(
      //   label: 'Undo',
      //   onPressed: () {
      //     // Some code to undo the change.
      //   },
      // ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  buildDisabledScreen() {
    var brightness = Theme.of(context).brightness;

    bool isLightMode = brightness == Brightness.light;
    return GestureDetector(
      onTap: () {
        handleSnackBarError();
      },
      child: AbsorbPointer(
        child: Scaffold(
          backgroundColor:
              isLightMode == true ? AppTheme.white : AppTheme.nearlyBlack,
          body: FutureBuilder<bool>(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else {
                return Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      appBar(),
                      Expanded(child: FitnessAppHomeScreen()),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  buildActiveScreen() {
    var brightness = Theme.of(context).brightness;

    bool isLightMode = brightness == Brightness.light;
    return Scaffold(
      backgroundColor:
          isLightMode == true ? AppTheme.white : AppTheme.nearlyBlack,
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  appBar(),
                  Expanded(child: FitnessAppHomeScreen()),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if(user!=null)
    // return user['is_active'] == 1 ? buildActiveScreen() : buildDisabledScreen();
    return buildActiveScreen();
  }


  Widget appBar() {
    var brightness = Theme.of(context).brightness;
    bool isLightMode = brightness == Brightness.light;
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Container(
        decoration: BoxDecoration(
                        color: FitnessAppTheme.nearlyDarkREd,
                        gradient: LinearGradient(
                            colors: [
                              HexColor('#3B0656'),
                              HexColor('#3B0656'),
                              HexColor('#3B0656'),
                              HexColor('#3B0656'),
                              // HexColor('#4F1516'),
                              // HexColor('#080808'),
                              HexColor('#080808'),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight
                            ),
                        // shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: FitnessAppTheme.nearlyDarkREd
                                  .withOpacity(0.0),
                              offset: const Offset(8.0, 16.0),
                              blurRadius: 16.0),
                        ],
                      ),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Afandena Cards',
                  style: TextStyle(
                    fontSize: 22,
                    color: isLightMode ? AppTheme.darkText : AppTheme.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              // color: isLightMode ? Colors.white : AppTheme.nearlyBlack,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                  child: Container(),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class HomeListCard extends StatelessWidget {
  const HomeListCard(
      {Key? key,
      this.listData,
      this.callBack,
      this.animationController,
      this.animation})
      : super(key: key);

  final HomeList? listData;
  final VoidCallback? callBack;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    Widget mchild;

    if (listData!.cardName == 'profile_data')
      mchild = AccountCardView(
          animationController: animationController, animation: animation);
    else if (listData!.cardName == 'info_data')
      mchild = InfoCardView(
          animationController: animationController, animation: animation);
    else if (listData!.cardName == 'info2_data')
      mchild = Info2CardView(
          animationController: animationController, animation: animation);
    else
      mchild = BodyMeasurementView(
          animationController: animationController, animation: animation);

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                child: mchild,
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeListView extends StatelessWidget {
  const HomeListView(
      {Key? key,
      this.listData,
      this.callBack,
      this.animationController,
      this.animation})
      : super(key: key);

  final HomeList? listData;
  final VoidCallback? callBack;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            FadeTransition(
              opacity: animation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 50 * (1.0 - animation!.value), 0.0),
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Stack(
                          children: [
                            Image.asset(
                              listData!.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.grey.withOpacity(0.2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                            onTap: callBack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
