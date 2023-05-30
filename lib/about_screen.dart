import 'package:best_flutter_ui_templates/app_theme.dart';
import 'package:best_flutter_ui_templates/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    var brightness = Theme.of(context).brightness;
    bool isLightMode = brightness == Brightness.light;
    return Container(
      decoration: getBoxBackgroud(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor:Colors.transparent,
          body: Container(
            decoration: getBoxBackgroud(),
            child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 16,
                    right: 16),
                child: Image.asset('assets/icons/logot.png'),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'AFANDENA Cards',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isLightMode ? Colors.black : Colors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'هي شركة مختصة لبيع بطاقات و كروت الالعاب و برامج الشحن بمختلف انواعها , للتواصل رقم الشركة' + ' : 00962792891533',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: isLightMode ? Colors.black : Colors.white),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      width: 140,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isLightMode ? Colors.blue : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              offset: const Offset(4, 4),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // launch("tel:00962792891533")
                            launchUrl(Uri.parse("https://wa.me/+962792891533"),mode: LaunchMode.externalApplication);
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                 Text(
                                'تواصل معنا',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isLightMode ? Colors.greenAccent : Colors.black,
                                ),
                               ),  
                               Container(width: 5,),
                               Icon(Icons.call,size: 20,color: Colors.greenAccent,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
       
          ) ),
      ),
    );
  }
}
