import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/constants.dart';
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

// This class handles the Page to edit the Email Section of the User Profile.
class EditEmailFormPage extends StatefulWidget {
  const EditEmailFormPage({Key? key, this.updateUser}) : super(key: key);
  final updateUser;
  @override
  EditEmailFormPageState createState() {
    return EditEmailFormPageState();
  }
}

class EditEmailFormPageState extends State<EditEmailFormPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
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
      emailController.text = user.email;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void updateUserValue(String email) {
    user.email = email;
  }

  vEmail(value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //   appBar: buildAppBar(context,'تعديل البريد الالكتروني'),
        // backgroundColor: FitnessAppTheme.nearlyBlack,
        body: Container(
      decoration: getBoxBackgroud(),
      child: Column(
        children: [
          buildAppBar(context, 'تعديل البريد الالكتروني'),
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
                            "ادخل البريد الالكتروني الجديد !",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: FitnessAppTheme.lightText),
                            textAlign: TextAlign.right,
                          )),
                      _hasError
                          ? Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                'البريد الالكتروني مأخود',
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : Container(),
                      Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: SizedBox(
                              height: 100,
                              width: 320,
                              child: TextFormField(
                                textDirection: TextDirection.ltr,
                                // Handles Form Validation
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      !vEmail(value)) {
                                    return 'من فضلك ادخل بريد الكتروني صالح';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'بريدك الالكتروني'),
                                controller: emailController,
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
                                    backgroundColor: MaterialStatePropertyAll(
                                        FitnessAppTheme.nearlyDarkREd),
                                  ),
                                  onPressed:
                                      _isLoading ? null : handleUpdateEmail,
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

  handleUpdateEmail() async {
    if (_formKey.currentState!.validate()) {
      // here test the cost if is it bigger then the cash of the user

      setState(() {
        _isLoading = true;
        _hasError = false;

        EasyLoading.show(
            status: 'جاري التعديل', maskType: EasyLoadingMaskType.custom);
      });

      var data = {'email': emailController.text};

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
            _hasError = true;
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
        // _hasError = false;
      });
    }
  }

  handleSnackBar() {
    final snackBar = SnackBar(
      content: Text('تم تعديل البريد الالكتروني '),
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
