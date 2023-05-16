import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context,String title) {
  return AppBar(
    iconTheme: IconThemeData(
        color: Colors
            .black), // set backbutton color here which will reflect in all screens.
    leading: BackButton(),
    backgroundColor: Colors.transparent,
    title: Text(title,style: TextStyle(
      fontSize: 30,
      color: FitnessAppTheme.nearlyWhite
    ),),
    elevation: 0,
  );
}
