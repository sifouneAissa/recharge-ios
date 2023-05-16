import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  const SignUpScreenTopImage({
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
            // const Spacer(),
          ],
        ),
        // SizedBox(height: defaultPadding),
        Text(
          S.of(context).sign_up.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold,color: FitnessAppTheme.lightText,),
        ),
        SizedBox(height: defaultPadding),
      ],
    );
  }
}
