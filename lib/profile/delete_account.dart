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

import '../screens/Login/login_screen.dart';

// This class handles the Page to edit the Name Section of the User Profile.
class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({Key? key, this.updateUser}) : super(key: key);
  final updateUser;
  @override
  DeleteAccountPageState createState() {
    return DeleteAccountPageState();
  }
}

class DeleteAccountPageState extends State<DeleteAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final password = TextEditingController();
  final oldPassword = TextEditingController();
  final confirmPassword = TextEditingController();
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
    });
  }

  @override
  void dispose() {
    password.dispose();
    oldPassword.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  void updateUserValue(String name) {
    user.name = name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: buildAppBar(context, 'تعديل كلمة السر'),
        // backgroundColor: FitnessAppTheme.nearlyBlack,
        body: Container(
          decoration: getBoxBackgroud(),
          child: Column(
            children: [
              buildAppBar(context, 'ازالة الحساب !'),
              Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                              width: 320,
                              child: const Text(
                                "ادخل كلمة السر !",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: FitnessAppTheme.lightText),
                              )),
                          _hasError
                              ? Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    'كلمة السر غير متطابقة',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                              : Container(),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: SizedBox(
                                  height: 100,
                                  width: 320,
                                  child: TextFormField(
                                    obscureText: true,
                                    textInputAction: TextInputAction.next,
                                    // Handles Form Validation
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    validator: (value) =>
                                    value!.isEmpty || (value.isEmpty)
                                        ? 'كلمة السر خاطئة'
                                        : null,
                                    controller: password,
                                    textDirection: TextDirection.ltr,
                                    // decoration: const InputDecoration(
                                    //   labelText: '********',
                                    // ),
                                  ))),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
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
                                      onPressed: _isLoading
                                          ? null
                                          : handleUpdatePassword,
                                      child: const Text(
                                        'تأكيد حذف الحساب',
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

  handleUpdatePassword() async {
    if (_formKey.currentState!.validate()) {
      print('Form is valid');

      // here test the cost if is it bigger then the cash of the user

      setState(() {
        _isLoading = true;
        _hasError = false;
        EasyLoading.show(
            status: 'جاري التعديل', maskType: EasyLoadingMaskType.custom);
      });

      var data = {
        'password': password.value.text,
      };

      try {
        var res = await AuthApi().deleteAccount(data);

        var body = jsonDecode(res.body);

        if (body['status']) {
          await GetData().logout();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginScreen();
              },
            ),
          );
          handleSnackBar();
        } else {
          setState(() {
            print(body);
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
        _hasError = false;
      });
    }
  }

  handleSnackBar() {
    final snackBar = SnackBar(
      content: Text('تم حذف حسابك بنجاح'),
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
