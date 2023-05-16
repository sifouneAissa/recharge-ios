import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/constants.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/profile/appbar_widget.dart';
import 'package:best_flutter_ui_templates/profile/user/user.dart';
import 'package:best_flutter_ui_templates/profile/user/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// This class handles the Page to edit the Phone Section of the User Profile.
class EditPhoneFormPage extends StatefulWidget {
  const EditPhoneFormPage({Key? key, this.updateUser}) : super(key: key);
  final updateUser;
  @override
  EditPhoneFormPageState createState() {
    return EditPhoneFormPageState();
  }
}

class EditPhoneFormPageState extends State<EditPhoneFormPage> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
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
      phoneController.text = user.phone;
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  vPhone(value) {
    return value!.length == 10;
  }

  void updateUserValue(String phone) {
    String formattedPhoneNumber = "(" +
        phone.substring(0, 3) +
        ") " +
        phone.substring(3, 6) +
        "-" +
        phone.substring(6, phone.length);
    user.phone = formattedPhoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //   appBar: buildAppBar(context,'تعديل رقم الهاتف'),
        // backgroundColor: FitnessAppTheme.nearlyBlack,
        body: Container(
      decoration: getBoxBackgroud(),
      child: Column(
        children: [
          buildAppBar(context, 'تعديل رقم الهاتف'),
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
                            "ادخل الهاتف الجديد !",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: FitnessAppTheme.lightText),
                          )),
                      _hasError
                          ? Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                'رقم الهاتف مأخود',
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
                                inputFormatters: <TextInputFormatter>[
                                  // for below version 2 use this
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.phone,
                                textDirection: TextDirection.ltr,
                                // Handles Form Validation
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      !vPhone(value)) {
                                    return 'من فضلك ادخل رقم هاتف صالح';
                                  }
                                  return null;
                                },
                                controller: phoneController,
                                decoration: const InputDecoration(
                                  labelText: 'رقم الهاتف',
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
                                    backgroundColor: MaterialStatePropertyAll(
                                        FitnessAppTheme.nearlyDarkREd),
                                  ),
                                  onPressed:
                                      _isLoading ? null : handleUpdatePhone,
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

  handleUpdatePhone() async {
    if (_formKey.currentState!.validate()) {
      // here test the cost if is it bigger then the cash of the user

      setState(() {
        _isLoading = true;
        _hasError = false;

        EasyLoading.show(
            status: 'جاري التعديل', maskType: EasyLoadingMaskType.custom);
      });

      var data = {'phone': phoneController.text};

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
      content: Text('تم تعديل رقم الهاتف '),
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
