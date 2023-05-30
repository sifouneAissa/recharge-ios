import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:best_flutter_ui_templates/navigation_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Signup/signup_screen.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginForm createState() => _LoginForm();
}

class _LoginForm extends State<LoginForm> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _hasError = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _hasConnection = true;


  @override
  void initState() {
    super.initState();
    
    FirebaseMessaging.instance.getToken().then((value) async {
        var storage = await GetData().getInstance();
        storage.setString('firebase_token',value);
    },);

    setConnectionListner((hasI){
      setHasConnection(hasI);
    });
  }

  setHasConnection(hasI){
      setState(() {
        _hasConnection = hasI;
      });
      if(_hasConnection){
          print('has connection');
      }
      else{
          print('has no connection');
      }
  }



Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  AccessToken? accessToken  = loginResult.accessToken;
  // user id 
  // loginResult.accessToken!.userId
  print(
    '''
         Logged in!
         
         Token: ${accessToken!.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.grantedPermissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
  
  // Once signed in, return the UserCredential
  UserCredential user = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
 
 Map<String , dynamic>? profile = user.additionalUserInfo!.profile;

 var userId;
 var name;
 var email;
 var profile_image;

 profile!.forEach((key, value) {
      if (key == 'id')
        userId = value;
      else if (key == 'name')
        name = value;
      else if (key == 'profile_image') profile_image = value;
      // profile image
      if (value is Map) {
        value.forEach((key, value) {
          if (value is Map) {
            value.forEach((key, value) {
              profile_image = value;
            });
          }
        });
      }
    });

    var data = {
      'name': name,
      'email': email,
      'profile_image': profile_image,
      'social_user_id': userId,
      'social': true,
      'driver': 'facebook'
    };

  await handleSLogin('facebook',userId,data);

  return user ;
}


//  handleSnackBarErrorConnection() {
//     final snackBar = SnackBar(
//       content: Text('انت غير متصل بالشبكة'),
//       // action: SnackBarAction(
//       //   label: 'Undo',
//       //   onPressed: () {
//       //     // Some code to undo the change.
//       //   },
//       // ),
//     );

//     // Find the ScaffoldMessenger in the widget tree
//     // and use it to show a SnackBar.
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }


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
  showAlertDialog(BuildContext context,data) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("لا",style: TextStyle(
      color: FitnessAppTheme.nearlyWhite
    )),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text("نعم",style: TextStyle(
      color: FitnessAppTheme.nearlyDarkREd
    ),),
    onPressed:  () {
      print(data);
      handleSRegister(data);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    // title: Text("AlertDialog"),
    content: Text("لا يوجد حساب هل تريد انشاء حساب؟"),
    backgroundColor: HexColor(FitnessAppTheme.gradiantFc),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

   handleSnackBarErrorFacebook(data) {
    print('check');
    showAlertDialog(context,data);
    // final snackBar = SnackBar(
    //   content: Text('لا يوجد حساب'),
    //   // action: SnackBarAction(
    //   //   label: 'Undo',
    //   //   onPressed: () {
    //   //     // Some code to undo the change.
    //   //   },
    //   // ),
    // );

    // // Find the ScaffoldMessenger in the widget tree
    // // and use it to show a SnackBar.
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              signInWithFacebook();
            },
            child: Container(
              padding: EdgeInsets.only(top: 8,right: 1,left: 1,bottom: 8),
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10)
              ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                   Icon(Icons.facebook,color: Colors.white,),
                   Text(' التسجيل عن طريق Facebook' ,style: TextStyle(color: Colors.white),)
              ],
            ),
          ),
          ),
          
          const SizedBox(height: defaultPadding),
          GestureDetector(
            onTap: (){
                    print('check this tap');
                    _googleSignIn.signIn().then((value)  async {
                      String? userName = value!.displayName;
                      String? profilePicture = value.photoUrl;
                      
                      var data = {
                        'name': userName,
                        'email': value.email,
                        'profile_image': profilePicture,
                        'social_user_id': value.id,
                        'social': true,
                        'driver': 'gmail'
                      };
                      // this is the id of the google user ;
                      // print(value.id);
                      // print(userName);
                      // print(profilePicture);
                      await handleSLogin('gmail',value.id,data);
                    });
            },
            child: Container(
              padding: EdgeInsets.only(top: 8,right: 1,left: 1,bottom: 8),
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10)
              ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                   Icon(Icons.email,color: Colors.white,),
                   Text(' التسجيل عن طريق ال Gmail ' ,style: TextStyle(color: Colors.white),)
              ],
            ),
          ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: _hasError
                  ? Text(
                      S.of(context).invalid_email_password,
                      style: TextStyle(color: Colors.red),
                    )
                  : null),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            textDirection: TextDirection.rtl,
            validator: (value) => value!.isEmpty || !vEmail(value)
                ? S.of(context).invalid_email
                : null,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: S.of(context).your_email,
              hintStyle: TextStyle(color: FitnessAppTheme.nearlyWhite),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child:
                    Icon(Icons.person, color: FitnessAppTheme.nearlyDarkREd),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textDirection: TextDirection.ltr,
              controller: password,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              validator: (value) =>
                  value!.isEmpty ? S.of(context).invalid_password : null,
              decoration: InputDecoration(
                hintText: S.of(context).your_password,
                hintStyle: TextStyle(color: FitnessAppTheme.nearlyWhite),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(
                    Icons.lock,
                    color: FitnessAppTheme.nearlyDarkREd,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: FitnessAppTheme.nearlyDarkREd),
              onPressed: _isLoading ? null : handleLogin,
              child: Text(
                S.of(context).login.toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
           AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),

        ],
      ),
    );
  }

handleLogin() async {
    if(_hasConnection){
    if (_formKey.currentState!.validate()) {
      
      setState(() {
        _isLoading = true;

        EasyLoading.show(
            status: 'جاري التحقق ...', maskType: EasyLoadingMaskType.custom);
      });

      var data = {'email': email.text, 'password': password.text};

      try {
        var res = await AuthApi().login(data);

        var body = jsonDecode(res.body);

        if (body['status']) {
          var data = AuthApi().getData(body);

          SharedPreferences localeStorage =
              await SharedPreferences.getInstance();
          // save the token

          localeStorage.setString('token', data['token']);
          localeStorage.setString('user', jsonEncode(data['user']));

          localeStorage.setString(
              'transactions', jsonEncode(data['transactions']));
          localeStorage.setString(
              'notifications', jsonEncode(data['notifications']));
          localeStorage.setString('months', jsonEncode(data['months']));
          localeStorage.setString('diffs', jsonEncode(data['diffs']));

          var user = localeStorage.getString('user');
          var token = localeStorage.getString('token');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return NavigationHomeScreen();
              },
            ),
          );
        } else {
          print(data);
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

      setState(() {
        _hasError = true;
      });
    }
    }else {
      handleSnackBarErrorConnection(context);
    }
  }

  
  handleSnackBarErrorSocial() {
    final snackBar = SnackBar(
      content: Text('الحساب مأخود'),
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

handleSRegister(var data) async {
    if (_hasConnection) {

      setState(() {
        _isLoading = true;
        EasyLoading.show(
            status: 'جاري انشاء الحساب ...',
            maskType: EasyLoadingMaskType.custom);
      });

      // var data = {
      //   'email': email.text,
      //   'phone': phone.text,
      //   'name': name.text
      // };

      try {
        var res = await AuthApi().register(data,_hasConnection);

        var body = jsonDecode(res.body);

        if (body['status']) {
          var data = AuthApi().getData(body);

          SharedPreferences localeStorage =
              await SharedPreferences.getInstance();
          // save the token

          localeStorage.setString('token', data['token']);
          localeStorage.setString('user', jsonEncode(data['user']));
          localeStorage.setString(
              'transactions', jsonEncode(data['transactions']));
          localeStorage.setString(
              'notifications', jsonEncode(data['notifications']));
          localeStorage.setString('months', jsonEncode(data['months']));
          localeStorage.setString('diffs', jsonEncode(data['diffs']));

          var user = localeStorage.getString('user');
          var token = localeStorage.getString('token');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return NavigationHomeScreen();
              },
            ),
          );
        } else {
          print(body);
          handleSnackBarErrorSocial();
        }
      } catch (error) {
        handleSnackBarError();
      }

      setState(() {
        _isLoading = false;
      });

      EasyLoading.dismiss();
    } else {
      handleSnackBarErrorConnection(context);
    }
  }

handleSLogin(String driver,userId,sdata) async {
  
      if(_hasConnection){
      setState(() {
        _isLoading = true;

        EasyLoading.show(
            status: 'جاري التحقق ...', maskType: EasyLoadingMaskType.custom);
      });

      var data = {'driver': driver, 'userId': userId,'social' : true};

      try {
        var res = await AuthApi().login(data);

        var body = jsonDecode(res.body);

        if (body['status']) {
          var data = AuthApi().getData(body);

          SharedPreferences localeStorage =
              await SharedPreferences.getInstance();
          // save the token

          localeStorage.setString('token', data['token']);
          localeStorage.setString('user', jsonEncode(data['user']));

          localeStorage.setString(
              'transactions', jsonEncode(data['transactions']));
          localeStorage.setString(
              'notifications', jsonEncode(data['notifications']));
          localeStorage.setString('months', jsonEncode(data['months']));
          localeStorage.setString('diffs', jsonEncode(data['diffs']));

          var user = localeStorage.getString('user');
          var token = localeStorage.getString('token');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return NavigationHomeScreen();
              },
            ),
          );
        } else {
          setState(() {
            // _hasError = true;
          });

          handleSnackBarErrorFacebook(sdata);
        }
      } catch (error) {
        handleSnackBarError();
      }

      setState(() {
        _isLoading = false;
      });

      EasyLoading.dismiss();
      }else {
        handleSnackBarErrorConnection(context);
      }
  }

  vEmail(value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }
}


