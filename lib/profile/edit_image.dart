import 'dart:convert';
import 'dart:io';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/constants.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
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
import 'package:image_picker/image_picker.dart';


class EditImagePage extends StatefulWidget {
  const EditImagePage({Key? key,this.updateUser}) : super(key: key);
  final updateUser;
  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  User user = UserData.myUser;
  final ImagePicker _picker = ImagePicker();
  PickedFile? _imageFile;
  
  
  bool _hasError = false;
  bool _isLoading = false;
  
  @override 
  initState(){
    _getUser();
    super.initState();

  }

  _getUser() async {
    var res = await UserData.getUser();
    setState(()  {
      user =  res;
    });
  }


   Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        AspectRatio(
          aspectRatio: 1.5,
          child: Image(
              image: _imageFile == null
                  ? NetworkImage(user.image)
                  : FileImage(File(_imageFile!.path)) as ImageProvider,
              fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: _imageFile != null ? Colors.teal : Colors.red,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            S.of(context).choose_image,
            
            style: TextStyle(
              fontSize: 15.0,
              color: FitnessAppTheme.lightText
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text(S.of(context).camera),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text(S.of(context).gallery),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: FitnessAppTheme.nearlyBlack,
      // appBar: buildAppBar(context,'تعديل الصورة الشخصية'),
      body: Container(
       decoration: getBoxBackgroud(),
        child: Column(
          children: [
            buildAppBar(context,'تعديل الصورة الشخصية'),
            Container(
        margin: EdgeInsets.only(top: 100),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
              width: 330,
              child: const Text(
                "حمل الصورة الجديد !",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: FitnessAppTheme.lightText
                ),
              )),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                  width: 330,
                  child: imageProfile(),
                  )),
          Padding(
              padding: EdgeInsets.only(top: 40),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 330,
                    height: 50,
                    child: ElevatedButton(
                       style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(FitnessAppTheme.nearlyDarkREd),
                            ),
                      onPressed: _isLoading ? null : handleUpdateImage,
                      child: const Text(
                            'تعديل',
                            style: TextStyle(fontSize: 25),
                          ),
                    ),
                  )))
        ],
      ),
      )
      
          ],
        ),
      ));
  }

     handleUpdateImage() async {
      if (_imageFile!=null) {

        // here test the cost if is it bigger then the cash of the user
       
        setState(() {
          _isLoading = true;
          _hasError = false;

          EasyLoading.show(
              status: 'جاري التعديل',
              maskType: EasyLoadingMaskType.custom);
        });



        try {
          var res = await AuthApi().updatePhoto(_imageFile);

          var body = res.data;

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
          print(error);
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
      content: Text('تم تعديل الصورة الشخصية '),
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
