import 'package:best_flutter_ui_templates/generated/l10n.dart';

class TokenPackageData {
  TokenPackageData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
    this.kacl = 0,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String>? meals;
  double kacl;

}
