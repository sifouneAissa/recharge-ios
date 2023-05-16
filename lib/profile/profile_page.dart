import 'dart:async';

import 'package:best_flutter_ui_templates/constants.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/profile/appbar_widget.dart';
import 'package:best_flutter_ui_templates/profile/display_image_widget.dart';
import 'package:best_flutter_ui_templates/profile/edit_description.dart';
import 'package:best_flutter_ui_templates/profile/edit_email.dart';
import 'package:best_flutter_ui_templates/profile/edit_image.dart';
import 'package:best_flutter_ui_templates/profile/edit_name.dart';
import 'package:best_flutter_ui_templates/profile/edit_password.dart';
import 'package:best_flutter_ui_templates/profile/edit_phone.dart';
import 'package:best_flutter_ui_templates/profile/user/user_data.dart';
import 'package:best_flutter_ui_templates/profile/user/user.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// This class handles the Page to dispaly the user's info on the "Edit Profile" Screen
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user = UserData.myUser;
  @override
  initState() {
    _getUser();
    super.initState();
  }

  _getUser() async {
    var res = await UserData.getUser();
    setState(() {
      user = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: buildAppBar(context, 'تعديل الحساب'),
        // backgroundColor: FitnessAppTheme.nearlyBlack,
        body: Container(
      decoration: getBoxBackgroud(),
      child: Column(
        children: [
          buildAppBar(context, 'تعديل الحساب'),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                InkWell(
                    onTap: () {
                      navigateSecondPage(EditImagePage(updateUser: () {
                        _getUser();
                      }));
                    },
                    child: DisplayImage(
                      imagePath: user.image,
                      onPressed: () {},
                    )),
                buildUserInfoDisplay(user.name, 'الاسم', EditNameFormPage(
                  updateUser: () {
                    _getUser();
                  },
                )),
                buildUserInfoDisplay(user.phone, 'الهاتف', EditPhoneFormPage(
                  updateUser: () {
                    _getUser();
                  },
                )),
                buildUserInfoDisplay(user.email, 'البريد الالكتروني',
                    EditEmailFormPage(
                  updateUser: () {
                    _getUser();
                  },
                )),
                buildUserInfoDisplay('*********', 'كلمة السر',
                    EditPasswordFormPage(
                  updateUser: () {
                    _getUser();
                  },
                )),
                // Expanded(
                //   child: buildAbout(user),
                //   flex: 4,
                // )
              ],
            ),
          )
        ],
      ),
    ));
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage) =>
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: FitnessAppTheme.nearlyWhite,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              navigateSecondPage(editPage);
                            },
                            child: Text(
                              getValue,
                              style: TextStyle(
                                  fontSize: 16,
                                  height: 1.4,
                                  color: FitnessAppTheme.nearlyWhite),
                            ))),
                    Icon(
                      Icons.keyboard_arrow_left,
                      color: FitnessAppTheme.nearlyWhite,
                      size: 40.0,
                    )
                  ]))
            ],
          ));

  // Widget builds the About Me Section
  Widget buildAbout(User user) => Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tell Us About Yourself',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 1),
          Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ))),
              child: Row(children: [
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          navigateSecondPage(EditDescriptionFormPage());
                        },
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'this is the user description',
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                  ),
                                ))))),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                  size: 40.0,
                )
              ]))
        ],
      ));

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
