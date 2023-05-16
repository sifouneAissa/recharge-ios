import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_home_screen.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:flutter/material.dart';

class InfoCardView extends StatefulWidget {
  final AnimationController? animationController;
  final Animation<double>? animation;

  const InfoCardView({Key? key, this.animationController, this.animation})
      : super(key: key);


  @override
  _InfoCardView createState() => _InfoCardView();

  }

class _InfoCardView extends State<InfoCardView> {
  var user;

   @override
  void initState() {
    _getUser();
    super.initState();
  }

  _getUser() async {
      var auth = await GetData().getAuth();
      setState(() {
        user = auth;
      });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation!.value), 0.0),
            child: GestureDetector(
              onTap: () {
                  
                                          Navigator.push<dynamic>(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                              builder: (BuildContext context) =>
                                                  FitnessAppHomeScreen()
                                            ),
                                          );
              },
              child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  border: Border.all(color: FitnessAppTheme.nearlyDarkREd),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                                  'كل شيء متاح الآن ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                    color: FitnessAppTheme.darkText,
                                  ),
                                ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 10, bottom: 0),
                      child: Row(
                        children: <Widget>[
                            Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    
                                     Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                          border: Border.all(color: FitnessAppTheme.nearlyDarkREd)
                                    
                                        ),
                                      child:  Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(
                                        Icons.wallet_outlined,
                                        color: FitnessAppTheme.nearlyDarkREd,
                                        size: 50.0,
                                        semanticLabel: 'Text to announce in accessibility modes',
                                      ),
                                      ),
                                    ),
                                    Text(
                                      'شحن تاوكنز',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: FitnessAppTheme.darkText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    
                                     Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                              border: Border.all(color: FitnessAppTheme.nearlyDarkREd)
                                    
                                        ),
                                      child:  Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(
                                        IconData(0xf0654, fontFamily: 'MaterialIcons'),
                                        color: FitnessAppTheme.nearlyDarkREd,
                                        size: 50.0,
                                        semanticLabel: 'Text to announce in accessibility modes',
                                      ),
                                      ),
                                    ),
                                    Text(
                                      'شحن مسرعات',
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: FitnessAppTheme.darkText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
        
            )  ),
        );
      },
    );
  }
}
