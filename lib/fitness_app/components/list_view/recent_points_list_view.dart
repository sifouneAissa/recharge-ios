import 'package:best_flutter_ui_templates/fitness_app/components/jawaker_accelerator/add_token_form.dart';
import 'package:best_flutter_ui_templates/fitness_app/ui_view/wave_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'package:best_flutter_ui_templates/components/datatables/recent_point_transaction_datatable.dart';

class RecentPointsListView extends StatefulWidget {
  const RecentPointsListView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation,this.parentScrollController})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final ScrollController? parentScrollController;

  @override
  _RecentPointsListViewState createState() => _RecentPointsListViewState();
}

class _RecentPointsListViewState extends State<RecentPointsListView> with TickerProviderStateMixin {
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
                    // HexColor('#F0AB2B'),
                    // HexColor(FitnessAppTheme.gradiantFc).withOpacity(0.7),
                    HexColor(FitnessAppTheme.gradiantFc),
                    HexColor(FitnessAppTheme.nearlyBlack.value.toString()),

                    HexColor(FitnessAppTheme.gradiantFc),
                    // HexColor('#F0AB2B'),
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  color: FitnessAppTheme.nearlyBlack,
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
                      top: 16, left: 16, right: 16, bottom: 16),
                  child: RecentPointTransactionDatatable(
                    parentScrollController : widget.parentScrollController,
                     mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.mainScreenAnimation!,
                curve: Interval(0.7, 1.0,
                    curve: Curves.slowMiddle))),
        mainScreenAnimationController: widget.mainScreenAnimationController,
    
                  )
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
