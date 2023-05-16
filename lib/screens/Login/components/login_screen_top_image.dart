import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset("assets/icons/logot.png"),
            ),
            const Spacer(),
          ],
        ),
        // SizedBox(height: defaultPadding * 2),
        Text(
          S.of(context).login,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: FitnessAppTheme.lightText,
          ),
        ),
        SizedBox(height: defaultPadding * 0.5),
      ],
    );
  }
}
