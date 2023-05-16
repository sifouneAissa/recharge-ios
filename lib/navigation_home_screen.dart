import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:best_flutter_ui_templates/custom_drawer/drawer_user_controller.dart';
import 'package:best_flutter_ui_templates/custom_drawer/home_drawer.dart';
import 'package:best_flutter_ui_templates/feedback_screen.dart';
import 'package:best_flutter_ui_templates/help_screen.dart';
import 'package:best_flutter_ui_templates/home_screen.dart';
import 'package:best_flutter_ui_templates/invite_friend_screen.dart';
import 'package:best_flutter_ui_templates/about_screen.dart';
import 'package:flutter/material.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;
  var user;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = const MyHomePage();
    _getUser(true);
    super.initState();
  }


  _getUser(bool first) async {
    var auth = await GetData().getAuth();

    setState(() {
      user = auth;
    });

    if(!first){
    // update user
    var res = await AuthApi().getUser();
    // print(jsonDecode(res.body));
    var body = jsonDecode(res.body);
    var data = await AuthApi().getData(jsonDecode(res.body));
    // var body = jsonDecode(res.body);
    // print('data');
    // print(data);
      if(body['status']){
    setState(() {
      user = data['user'];
    });

    await AuthApi().updateUser(data);

    if(user['is_active']==1){
      Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return NavigationHomeScreen();
              },
            ),
          );
      }
    }
    }
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

  buildActiveWidget(){
    return Container(
      color: AppTheme.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }
  buildDisabledWidget(){
      return GestureDetector(
      onTap: () async {
        handleSnackBarError();
        await _getUser(false);
        },
        child: AbsorbPointer(
          child: buildActiveWidget(),
        ) 
      ,);
  }

  @override
  Widget build(BuildContext context) {
    // return buildActiveWidget();

    return (user != null  &&  user['is_active'] == 1)  ? buildActiveWidget() : buildDisabledWidget();
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    // if (drawerIndex != drawerIndexdata) {
    drawerIndex = drawerIndexdata;
    switch (drawerIndex) {
      case DrawerIndex.HOME:
        setState(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return NavigationHomeScreen();
              },
            ),
          );
          // screenView = MyHomePage();
        });
        break;
      // case DrawerIndex.Help:
      //   setState(() {
      //     screenView = HelpScreen();
      //   });
      //   break;
      // case DrawerIndex.FeedBack:
      //   setState(() {
      //     screenView = FeedbackScreen();
      //   });
      //   break;
      case DrawerIndex.Invite:
        setState(() {
          screenView = InviteFriend();
        });
        break;
        case DrawerIndex.About:
        setState(() {
          screenView = AboutScreen();
        });
        break;
      default:
        break;
    }
  }
  // }
}
