import 'package:best_flutter_ui_templates/fitness_app/components/jawaker_accelerator/add_jawaker_accelerator_form.dart';
import 'package:best_flutter_ui_templates/fitness_app/ui_view/wave_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';

class AcceleratorListView extends StatefulWidget {
  const AcceleratorListView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation,this.onChangeBody,this.parentScrollController})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final ScrollController? parentScrollController;
  final onChangeBody;

  @override
  _AcceleratorListViewState createState() => _AcceleratorListViewState();
}

class _AcceleratorListViewState extends State<AcceleratorListView> with TickerProviderStateMixin {
  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    HexColor('00FFFFFF').withOpacity(0.5),
                    HexColor(FitnessAppTheme.nearlyBlack.value.toString()),
                    HexColor(FitnessAppTheme.gradiantFc),
                    HexColor(FitnessAppTheme.nearlyBlack.value.toString()),
                    HexColor(FitnessAppTheme.gradiantFc),
                    
                    HexColor('00FFFFFF').withOpacity(0.5),
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  border: Border.all(color: Colors.black87),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.nearlyDarkREd.withOpacity(0.1),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 16, right: 16, bottom: 16),
                  child: AddJawakerAcceleratorForm(
                    onChangeBody : widget.onChangeBody,
                    mainScreenAnimation: widget.mainScreenAnimation,
                    mainScreenAnimationController: widget.mainScreenAnimationController,
                    parentScrollController : widget.parentScrollController
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
