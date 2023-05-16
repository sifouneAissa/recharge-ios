import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/constants.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_home_screen.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/profile/appbar_widget.dart';
import 'package:best_flutter_ui_templates/profile/user/user.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/profile/display_image_widget.dart';
import 'package:best_flutter_ui_templates/profile/edit_description.dart';
import 'package:best_flutter_ui_templates/profile/edit_email.dart';
import 'package:best_flutter_ui_templates/profile/edit_image.dart';
import 'package:best_flutter_ui_templates/profile/edit_name.dart';
import 'package:best_flutter_ui_templates/profile/edit_phone.dart';
import 'package:best_flutter_ui_templates/profile/user/user_data.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// This class handles the Page to edit the Name Section of the User Profile.
class EditNameFormPage extends StatefulWidget {
  const EditNameFormPage({Key? key, this.updateUser}) : super(key: key);
  final updateUser;
  @override
  EditNameFormPageState createState() {
    return EditNameFormPageState();
  }
}

class EditNameFormPageState extends State<EditNameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  User user = UserData.myUser;
  bool _hasError = false;
  bool _isLoading = false;

  @override
  initState() {
    _getUser();
    super.initState();
  }

  _getUser() async {
    var res = await UserData.getUser();
    setState(() {
      user = res;
      firstNameController.text = user.name;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    super.dispose();
  }

  void updateUserValue(String name) {
    user.name = name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: buildAppBar(context, 'تعديل الاسم'),
        // backgroundColor: FitnessAppTheme.nearlyBlack,
        body: Container(
          decoration: getBoxBackgroud(),
          child: Column(
            children: [
              buildAppBar(context,'تعديل الاسم'),
              Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                              width: 320,
                              child: const Text(
                                "ادخل الاسم !",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: FitnessAppTheme.lightText),
                              )),
                          Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: SizedBox(
                                  height: 100,
                                  width: 320,
                                  child: TextFormField(
                                    // Handles Form Validation
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) =>
                                        value!.isEmpty || (value.isEmpty)
                                            ? 'اسم خاطئ'
                                            : null,
                                    controller: firstNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'الاسم',
                                    ),
                                  ))),
                          Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                    width: 320,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                FitnessAppTheme.nearlyDarkREd),
                                      ),
                                      onPressed:
                                          _isLoading ? null : handleUpdateName,
                                      child: const Text(
                                        'تعديل',
                                        style: TextStyle(fontSize: 25),
                                      ),
                                    ),
                                  )))
                        ]),
                  )),
            ],
          ),
        ));
  }

  handleUpdateName() async {
    if (_formKey.currentState!.validate()) {
      print('Form is valid');

      // here test the cost if is it bigger then the cash of the user

      setState(() {
        _isLoading = true;

        EasyLoading.show(
            status: 'جاري التعديل', maskType: EasyLoadingMaskType.custom);
      });

      var data = {'name': firstNameController.text};

      try {
        var res = await AuthApi().update(data);

        var body = jsonDecode(res.body);

        if (body['status']) {
          var data = AuthApi().getData(body);
          await AuthApi().updateUser(data);
          handleSnackBar();
          widget.updateUser();
        } else {
          setState(() {
            _hasError = false;
          });
        }
      } catch (error) {
        handleSnackBarError();
      }

      setState(() {
        _isLoading = false;
      });
      EasyLoading.dismiss();
    } else {
      print('Form is invalid');

      setState(() {
        _hasError = false;
      });
    }
  }

  handleSnackBar() {
    final snackBar = SnackBar(
      content: Text('تم تعديل الاسم '),
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
    // widget.onChangeBody();
  }

  handleSnackBarError() {
    final snackBar = SnackBar(
      content: Text('فشل الاتصال'),
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
}
