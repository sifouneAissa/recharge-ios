import 'package:best_flutter_ui_templates/generated/l10n.dart';

class JawakerListData {
  JawakerListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
    this.kacl = 0,
    this.value
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String>? meals;
  int kacl;
  String? value;

  static List<JawakerListData> tabIconsList = <JawakerListData>[
    JawakerListData(
      imagePath: 'assets/fitness_app/rocketw.png',
      titleTxt: 'مسرع أحمر',
      kacl: 100,
      meals: <String>['100 %'],
      startColor: '#e65019',
      endColor: '#8e310f',
      value:'100%',
    ),
    JawakerListData(
      imagePath: 'assets/fitness_app/rocketw.png',
      titleTxt: 'مسرع أزرق',
      kacl: 150,
      meals: <String>['150 %'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
      value:'150%',
    ),
    
    JawakerListData(
      imagePath: 'assets/fitness_app/rocketw.png',
      titleTxt: 'مسرع أسود',
      kacl: 300,
      meals: <String>['300 %'],
      startColor: '#57372d',
      endColor: '#30201b',
      value:'300%',
    ),
    // JawakerListData(
    //   imagePath: 'assets/fitness_app/rocketw.png',
    //   titleTxt: 'Dinner',
    //   kacl: 0,
    //   meals: <String>['Recommend:', '703 kcal'],
    //   startColor: '#6F72CA',
    //   endColor: '#1E1466',
    // ),
  ];
}
