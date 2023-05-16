import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/common.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/jawaker_accelerator_list_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/list_view/recent_points_list_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/list_view/recent_tokens_list_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../constants.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddJawakerAcceleratorForm extends StatefulWidget {
  const AddJawakerAcceleratorForm(
      {Key? key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.onChangeBody,
      this.parentScrollController})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final ScrollController? parentScrollController;
  final onChangeBody;

  @override
  _AddJawakerAcceleratorForm createState() => _AddJawakerAcceleratorForm();
}

class _AddJawakerAcceleratorForm extends State<AddJawakerAcceleratorForm> {
  final ImagePicker _picker = ImagePicker();
  bool _hasConnection = true;

  PickedFile? _imageFile;
  TextEditingController quantity = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  bool _isLoading = false;
  bool _hasError = false;
  double _cost = 0;
  bool _hasCash = true;
  bool _showRecent = false;
  double _tokens = 0;
  List<PackagePointData> data = [];

  String? selectedPoint;
  var costs = {
    '100%': defaultAcceleratorToken,
    '150%': defaultAcceleratorToken * 2,
    '300%': defaultAcceleratorToken * 3
  };

  void _checkCash() async {
    var user = await GetData().getAuth();

    setState(() {
      _hasCash = user['cash_point'] + .0 >= _cost;
    });
  }

  setHasConnection(hasI) {
    setState(() {
      _hasConnection = hasI;
    });
    if (_hasConnection) {
      print('has connection');
    } else {
      print('has no connection');
    }
  }

  @override
  void initState() {
    super.initState();

    setConnectionListner((hasI) {
      setHasConnection(hasI);
    });
    // quantity.addListener(() {
    //   final isV = quantity.value.text.isEmpty;
    //   if (!isV) {
    //     setState(() {
    //       if(selectedPoint!=null)
    //           _cost = costs[selectedPoint] as double;
    //       // _cost = double.parse(quantity.value.text) * defaultAcceleratorToken;
    //       else _cost = 0;
    //       // quantity.value.text = Common.formatNumber(quantity.value.text);
    //       // validate the cash of the user
    //       _checkCash();
    //     });
    //   } else
    //     setState(() {
    //       _cost = 0;
    //     });
    // });
  }

  _getItemsList() {
    return List.generate(data.length, (index) {
      PackagePointData element = data[index];

      String cost = (element.packageData['cost'] * double.parse(element.value))
          .toString();
      String text = 'لقد اخترت ';
      var ncost = 0.0;
      var ttokens = 0.0;
      data.forEach((element) {
        String cost =
            (element.packageData['cost'] * double.parse(element.value))
                .toString();

        String subtext = 'المسرع : ' +
            element.packageData['count'].toString() +
            ' الكمية : ' +
            element.value.toString() +
            ' الكلفة : ' +
            cost.substring(0, cost.length > 5 ? 5 : cost.length);
        text = text + '\n' + subtext;
        ncost =
            element.packageData['cost'] * double.parse(element.value) + ncost;
        ttokens =
            element.packageData['cost'] * double.parse(element.value) + ttokens;
      });

      setState(() {
        _cost = ncost + .0;
        _tokens = ttokens;
        // print(_cost);
        // print(_tokens);
      });

      _checkCash();

      return Container(
        margin: EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.withOpacity(0.08),
          // border: Border.all(color: Colors.black)
        ),
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                margin: EdgeInsets.only(left: 0),
                child: Text(element.packageData['code'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: FitnessAppTheme.lightText)),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                margin: EdgeInsets.only(right: 40, left: 20),
                child: Text(Common.formatNumber(int.parse(element.value)),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: FitnessAppTheme.lightText)),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                margin: EdgeInsets.only(right: 0),
                child: Text(
                    Common.formatNumber(
                        element.packageData['cost'] * int.parse(element.value)),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: FitnessAppTheme.lightText)),
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.2,
              //   margin: EdgeInsets.only(right: 30),
              //   child:
              //       Text(cost.substring(0, cost.length > 5 ? 5 : cost.length)),
              // )
            ],
          ),
        ),
      );
    });
  }

  _getPackages() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Text.rich(TextSpan(children: [
                // WidgetSpan(
                //     child: Icon(
                //   Icons.shop,
                //   size: 18,
                // )),

                TextSpan(
                    text: data.length.toString() + '-',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: FitnessAppTheme.lightText)),
                TextSpan(
                    text: 'المسرعات التي تم اختيارها',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: FitnessAppTheme.lightText))
              ])),
            ),
          ],
        ),
        Container(
          height: 2,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            // border: Border.all(color: Colors.black)
          ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 30),
                  child: Text(
                    'المسرع',
                    style: TextStyle(color: FitnessAppTheme.lightText),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 40, left: 40),
                  child: Text(' الكمية',
                      style: TextStyle(color: FitnessAppTheme.lightText)),
                ),
                Container(
                  margin: EdgeInsets.only(right: 50, left: 30),
                  child: Text(' السعر',
                      style: TextStyle(color: FitnessAppTheme.lightText)),
                ),
                // Container(
                //   margin: EdgeInsets.only(right: 80),
                //   child: Text(' الكلفة'),
                // )
              ],
            ),
          ),
        ),
        Container(
          child: Column(
            children: _getItemsList(),
          ),
        ),
        Container(
          height: 15,
        ),
        Container(
          // width: MediaQuery.of(context).size.width * 0.5,
          // height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: FitnessAppTheme.grey.withOpacity(0.4),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 10.0),
              ]),
          child: Column(
            children: [
              Container(
                // height: MediaQuery.of(context).size.height * 0.1,
                // width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <HexColor>[
                        HexColor('#CF2928'),
                        HexColor('#CF2928'),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15)),

                child: Padding(
                  padding:
                      EdgeInsets.only(top: 20, bottom: 20, right: 50, left: 50),
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(Common.formatNumber(_tokens),
                          style: TextStyle(
                              fontSize: 20,
                              color: FitnessAppTheme.nearlyWhite))),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //       // color: Colors.white
              //       ),
              //   child: Padding(
              //     padding: EdgeInsets.all(10),
              //     child: FittedBox(
              //       fit : BoxFit.scaleDown,
              //       child : Text("الكلفة : " + Common.formatNumber(_tokens))
              //     ),
              //   ),
              // ),
            ],
          ),
        )
      ],
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        AspectRatio(
          aspectRatio: 1.5,
          child: Image(
              image: _imageFile == null
                  ? AssetImage("assets/fitness_app/account_id.png")
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

  handleSnackBar() {
    final snackBar = SnackBar(
      content: Text(S.of(context).request_success),
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
    widget.onChangeBody();
  }

  handleSelectPackage(PackagePointData extra) {
    PackagePointData elementt = extra;
    // get the list without the selected element
    List<PackagePointData> nData = data
        .where((element) => element.packageId != elementt.packageId)
        .toList();
    // update the data
    nData.add(elementt);
    // validate all data
    nData = nData
        .where((element) => element.value != '' && element.value != '0')
        .toList();
    // set the data
    setState(() {
      data = nData;
    });
    print(data.length);
    // setState(() {
    //     // _checkCash();
    // });

    // setState(() {
    //   _cost = 0;
    // });
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          JawakerAcceleratorListView(
            mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.mainScreenAnimation!,
                    curve: Interval(0.6, 1.0, curve: Curves.fastOutSlowIn))),
            mainScreenAnimationController: widget.mainScreenAnimationController,
            onSelectCallback: handleSelectPackage,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: _hasError || !_hasCash
                  ? Text(
                      S.of(context).invalid_cash,
                      style: TextStyle(color: Colors.red),
                    )
                  : null),

          // TextFormField(
          //   autovalidateMode: AutovalidateMode.onUserInteraction,
          //   validator: (value) => value!.isEmpty ||
          //           (value.isNotEmpty && (double.parse(value) + .0) == 0)
          //       ? S.of(context).invalid_quantity
          //       : null,
          //   controller: quantity,
          //   keyboardType: TextInputType.number,
          //   textInputAction: TextInputAction.next,
          //   cursorColor: kPrimaryColor,
          //   onSaved: (quantity) {},
          //   decoration: InputDecoration(
          //     hintText: S.of(context).your_quantity,
          //     hintStyle: TextStyle(color: Colors.black),
          //     prefixIcon: Padding(
          //       padding: const EdgeInsets.all(defaultPadding),
          //       child:
          //           Icon(Icons.numbers, color: FitnessAppTheme.nearlyDarkREd),
          //     ),
          //   ),
          // ),
          Column(
            children: [
              Container(
                child: data.isNotEmpty
                    ? _getPackages()
                    : Text(
                        'ادخل الكمية من كل حزمة',
                        style: TextStyle(color: FitnessAppTheme.lightText),
                      ),
              )
            ],
          ),
          TextFormField(
             inputFormatters: <TextInputFormatter>[
                // for below version 2 use this
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
// for version 2 and greater youcan also use this
                FilteringTextInputFormatter.digitsOnly
              ],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) =>
                value!.isEmpty || (value.isEmpty) ? 'اسم خاطئ' : null,
            controller: name,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (quantity) {},
            decoration: InputDecoration(
              hintText: 'معرف اللاعب ',
              hintStyle: TextStyle(color: FitnessAppTheme.nearlyWhite),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person, color: FitnessAppTheme.nearlyDarkREd),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          //   child: imageProfile(),
          // ),
          const SizedBox(height: defaultPadding),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Text(
          //       S().cost + Common.formatNumber(_cost),
          //       style: const TextStyle(color: Colors.pink),
          //     ),
          //     // GestureDetector(
          //     //   onTap: () => {

          //     //   },
          //     //   child: Text(
          //     //     login ? "Sign Up" : "Sign In",
          //     //     style: const TextStyle(
          //     //       color: kPrimaryColor,
          //     //       fontWeight: FontWeight.bold,
          //     //     ),
          //     //   ),
          //     // )
          //   ],
          // ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled))
                  return FitnessAppTheme.nearlyDarkREd.withOpacity(0.4);
                return FitnessAppTheme.nearlyDarkREd.withOpacity(0.9);
              })),
              onPressed: data.isEmpty || !_hasCash || _isLoading
                  ? null
                  : handleAddToken,
              child: Text(
                S.of(context).confirm.toUpperCase(),
                style:
                    TextStyle(fontSize: 20, color: FitnessAppTheme.background),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: ' اخر العمليات ',
                  style: TextStyle(color: FitnessAppTheme.lightText)),
              WidgetSpan(
                  child: Icon(Icons.history,
                      size: 14, color: FitnessAppTheme.lightText))
            ]),
          ),
          RecentPointsListView(
            parentScrollController: widget.parentScrollController,
            mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.mainScreenAnimation!,
                    curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn))),
            mainScreenAnimationController: widget.mainScreenAnimationController,
          ),
        ],
      ),
    );
  }

  handleAddToken() async {
    if (_hasConnection) {
      if (_hasCash) {
        
        if (_formKey.currentState!.validate()) {
          // here test the cost if is it bigger then the cash of the user
          setState(() {
            _isLoading = true;
            EasyLoading.show(
                status: S().sending_add_jawker,
                maskType: EasyLoadingMaskType.custom);
          });

          var packages = [];

          data.forEach((element) {
            packages
                .add({'package_id': element.packageId, 'count': element.value});
          });

          var ndata = {
            'name_of_player': name.text,
            'count': _cost.toString(),
            'cost': _cost,
            'point_packages': packages,
            'type': 'point',
          };

          AuthApi().updatePointCashUser(_cost);

          try {
            var res = await AuthApi().addPointWithoutP(ndata,_hasConnection);
            var body = jsonDecode(res.body);

            if (body['status']) {
              var data = AuthApi().getData(body);
              await AuthApi().updateUser(data);
              handleSnackBar();
            } else {
              
              AuthApi().updatePointCashUser(-_cost);
              setState(() {
                _hasError = false;
              });
            }
          } catch (error) {
            AuthApi().updatePointCashUser(-_cost);
            handleSnackBarError();
          }

          setState(() {
            _isLoading = false;
          });
          EasyLoading.dismiss();
        } else {
          

          setState(() {
            _hasError = false;
          });
        }
      }
    } else {
      handleSnackBarErrorConnection(context);
    }
  }
}

class PackagePointData {
  PackagePointData({this.value = '', this.packageId = '', this.packageData});

  String value;
  String packageId;
  var packageData;
}
