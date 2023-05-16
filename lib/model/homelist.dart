
import 'package:best_flutter_ui_templates/design_course/home_design_course.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_home_screen.dart';
import 'package:best_flutter_ui_templates/fitness_app/ui_view/body_measurement.dart';
import 'package:best_flutter_ui_templates/hotel_booking/hotel_home_screen.dart';
import 'package:best_flutter_ui_templates/introduction_animation/introduction_animation_screen.dart';
import 'package:flutter/widgets.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
    this.cardName,
  });

  Widget? navigateScreen;
  String imagePath;
  String? cardName;





  static List<HomeList> homeList = [
//    HomeList(
//      imagePath: 'assets/introduction_animation/introduction_animation.png',
//      navigateScreen: IntroductionAnimationScreen(),
//    ),
//    HomeList(
//      imagePath: 'assets/hotel/hotel_booking.png',
//      navigateScreen: HotelHomeScreen(),
//    ),
    HomeList(
        imagePath: 'assets/fitness_app/fitness_app.png',
        navigateScreen: null,
        cardName : 'profile_data'
    ),
    // HomeList(
    //   imagePath: 'assets/fitness_app/fitness_app.png',
    //   navigateScreen: FitnessAppHomeScreen(),
    //   cardName: null
    // ),
    HomeList(
      imagePath: 'assets/fitness_app/fitness_app.png',
      navigateScreen: null,
      cardName: 'info_data',
    ),
    HomeList(
      imagePath: 'assets/fitness_app/fitness_app.png',
      navigateScreen: null,
      cardName: 'info2_data',
    ),

//    HomeList(
//        imagePath: 'assets/fitness_app/fitness_app.png',
//        navigateScreen: BodyMeasurementView(),
//        isCard: true
//    ),
//    HomeList(
//      imagePath: 'assets/design_course/design_course.png',
//      navigateScreen: DesignCourseHomeScreen(),
//    ),
  ];
}
