import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

const double defaultPadding = 16.0;
const double defaultAcceleratorToken = 190000;
const double defaultHeight = 10.0;

getBoxBackgroud() {
  return BoxDecoration(
    color: FitnessAppTheme.nearlyDarkREd,
    gradient: getGradianBg(),
    // shape: BoxShape.circle,
    boxShadow: <BoxShadow>[
      BoxShadow(
          color: FitnessAppTheme.nearlyDarkREd.withOpacity(0.0),
          offset: const Offset(8.0, 16.0),
          blurRadius: 16.0),
    ],
  );
}

getLinearGradianBg(){
  return [
      HexColor(FitnessAppTheme.gradiantFc),
      HexColor(FitnessAppTheme.gradiantFc),
      // HexColor('#4F1516'),
      HexColor(FitnessAppTheme.gradiantSc),
      HexColor(FitnessAppTheme.gradiantSc),
    ];
}

getGradianBg(){
  return LinearGradient(colors: getLinearGradianBg(), begin: Alignment.topLeft, end: Alignment.bottomRight);
}

 handleSnackBarErrorConnection(context) {
    final snackBar = SnackBar(
      content: Text('انت غير متصل بالشبكة'),
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

setConnectionListner(handle){
  InternetConnectionChecker().onStatusChange.listen((status) {
      final hasI = status == InternetConnectionStatus.connected;

      handle(hasI);
    });
}
