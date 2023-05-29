import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/common.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationDatatable extends StatefulWidget {
  final ScrollController? parentScrollController;

  const NotificationDatatable({Key? key, this.parentScrollController})
      : super(key: key);

  @override
  _NotificationDatatable createState() => _NotificationDatatable();
}

class _NotificationDatatable extends State<NotificationDatatable> {
  var notifications = [];
  var diffs = [];
  Map<String, List<dynamic>> groups = {};

  int _currentPage = 0;
  int _rowsPerPage = 10; // Number of rows to display per page

  @override
  void initState() {
    __getNotifications();
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    super.initState();

    widget.parentScrollController?.addListener(() async {
      if (widget.parentScrollController?.position.pixels ==
          widget.parentScrollController?.position.minScrollExtent) {
        setState(() {
          _currentPage = 0;
        });
        await __getNotifications();
      }

      // if (widget.parentScrollController?.position.pixels ==
      //     widget.parentScrollController?.position.maxScrollExtent) {
      //   setState(() {
      //     _currentPage = _currentPage + 1;
      //   });
      //   await __getNotifications();
      // }
    });
  }

  DateTime convertToDateTime(String timeDifference) {
    final now = DateTime.now();

    if (timeDifference.contains('minute')) {
      final minutes = int.parse(timeDifference.split(' ')[0]);
      return now.subtract(Duration(minutes: minutes));
    } else if (timeDifference.contains('hour')) {
      final hours = int.parse(timeDifference.split(' ')[0]);
      return now.subtract(Duration(hours: hours));
    } else if (timeDifference.contains('day')) {
      final days = int.parse(timeDifference.split(' ')[0]);
      return now.subtract(Duration(days: days));
    }

    return now;
  }

  _gNotificationsList(var list) {
    var notifications = [];
    groups.values.forEach((element) {
      element.forEach((celement) {
        notifications.add(celement);
      });
    });

    list.forEach((element) {
      var exist;
      try {
        exist = notifications.firstWhere((oelement) {
          return oelement['id'] == element['id'];
        });
      } catch (error) {
        print(error);
      }
      if (exist == null) notifications.add(element);
    });

    notifications.sort((a, b) => DateTime.parse(b['created_at'])
        .compareTo(DateTime.parse(a['created_at'])));

    return notifications;
  }

  __getNotifications() async {
    __getOldNotifications();
    // var t = await AuthApi().getNotifications();
    var tp = await AuthApi().getPNotifications(_currentPage + 1);
    var body = jsonDecode(tp.body);
    if (body['status']) {
      List<dynamic> list = body['data']['notifications'];
      Map<String, List<dynamic>> groupedItems = {};
      List<dynamic> allNotifications = _gNotificationsList(list);
      if (this.mounted) {
        allNotifications.forEach((element) {
          var ldate = DateTime.parse(element['created_at']);
          var key = timeago.format(ldate, locale: 'ar');
          if (groupedItems.containsKey(key)) {
            groupedItems[key]!.add(element);
          } else {
            groupedItems[key] = [element];
          }
        });
        setState(() {
          groups = groupedItems;
        });

        await GetData().updateNotifications(groups);
        await GetData().updateDiffs(diffs);
      }
    }
  }

  __getOldNotifications() async {
    var t = await GetData().getNotification();
    var d = await GetData().getDiffs();
    if (t != null && d != null && t != Null && d != Null) {
      setState(() {
        // notifications = jsonDecode(t);
        Map<String, dynamic> jsonMap = jsonDecode(t);

        jsonMap.forEach((key, value) {
          if (value is List<dynamic>) {
            groups[key] = value;
          }
        });
        diffs = jsonDecode(d);
      });
    }
  }

  _getColumns() {
    // print(groups.values.toList());
    var keys = groups.keys.toList();
    return List<Column>.generate(keys.length, (index) {
      return index != 0
          ? Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      keys[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: FitnessAppTheme.lightText),
                    ),
                  ),
                  Column(
                    children: _getSubContainer(groups[keys[index]]),
                  )
                ])
          : Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 120),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: Text(
                            S().last_notifications,
                            // textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: FitnessAppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: 0,
                              color: FitnessAppTheme.lightText,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          keys[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: FitnessAppTheme.lightText),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: _getSubContainer(groups[keys[index]]),
                  )
                ]);
    });
  }

  _getSubContainer(notifications) {
    return List<Container>.generate(
        notifications.length,
        (index) => Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: FitnessAppTheme.oligthText)),
              child: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 10, top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60)),
                            border: Border.all(
                                color: FitnessAppTheme.nearlyDarkREd)),
                        // color: FitnessAppTheme.nearlyDarkBlue, // Button color
                        // shadowColor: FitnessAppTheme.nearlyDarkBlue,

                        child: InkWell(
                            splashColor: null, // Splash color
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Image.asset(
                                    'assets/fitness_app/tab_4s.png',
                                    width: 40,
                                  )),
                            )),
                      )),
                  Flexible(child: _getTexts(notifications[index])),
                ],
              ),
            ));
  }

  _getTexts(notification) {
    bool isMtransaction = notification['type'] == 'Mtransaction';
    bool isTransaction = notification['type'] == 'transaction';

    bool isTorP = (notification['info']['type'] == 'token' ||
            notification['info']['type'] == 'point') &&
        !isMtransaction;
    var leftC = notification['info']['left_accepted'];

    bool left = (leftC != 0 && leftC != null) ||
        (notification['info']['type'] == 'point');

    if (isTorP)
      return Text.rich(
        notification['data']['action'] == null
            ? TextSpan(
                style: TextStyle(
                  color: FitnessAppTheme.lightText,
                ),
                text: S.of(context).transaction_request,
                children: <InlineSpan>[
                    TextSpan(
                      text: notification['info']['type'] == 'token'
                          ? S.of(context).token + ' '
                          : S.of(context).point + ' ',
                      style: TextStyle(
                        fontSize: 15,
                        // fontWeight: FontWeight.bold,
                        // color: Colors.lightGreen
                      ),
                    ),
                    TextSpan(
                      text: S.of(context).transaction_value,
                      // style: TextStyle(
                      //     fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    notification['info']['type'] == 'token'
                        ? TextSpan(
                            text: notification['info']['count'] != null
                                ? Common.formatNumber(
                                        notification['info']['count']) +
                                    ' '
                                : '0' + ' ',
                            style: TextStyle(
                              fontSize: 15,
                              // fontWeight: FontWeight.bold,
                              // color: Colors.pinkAccent
                            ),
                          )
                        : TextSpan(
                            text: notification['info']['cost'] != null
                                ? Common.formatNumber(
                                        notification['info']['cost']) +
                                    ' '
                                : '0 ' + ' ',
                            style: TextStyle(
                              fontSize: 15,
                              // fontWeight: FontWeight.bold,
                              // color: Colors.pinkAccent
                            ),
                          ),
                    TextSpan(
                      text: S.of(context).day + notification['date'],
                      // style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                  ])
            : (notification['data']['action'] == 'accepted'
                ? TextSpan(
                    style: TextStyle(
                      color: FitnessAppTheme.lightText,
                    ),
                    text: !left
                        ? 'لقد تم قبول طلبك المتعلق ب'
                        : 'لقد تم قبول : ' +
                            Common.formatNumber(notification['info'][
                                notification['info']['type'] == 'token'
                                    ? 'token_accepted'
                                    : 'accepted_point']) +
                            ' من ',
                    children: <InlineSpan>[
                        TextSpan(
                          text: notification['info']['type'] == 'token'
                              ? S.of(context).token + ' '
                              : S.of(context).point + ' ',
                          style: TextStyle(
                            fontSize: 15,
                            // fontWeight: FontWeight.bold,
                            // color: Colors.lightGreen
                          ),
                        ),
                        TextSpan(
                          text: S.of(context).transaction_value,
                          // style: TextStyle(
                          //     fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        notification['info']['type'] == 'token'
                            ? TextSpan(
                                text: Common.formatNumber(
                                        notification['info']['count']) +
                                    ' ',
                                style: TextStyle(
                                  fontSize: 15,
                                  // fontWeight: FontWeight.bold,
                                  // color: Colors.pinkAccent
                                ),
                              )
                            : TextSpan(
                                text: Common.formatNumber(
                                        notification['info']['cost']) +
                                    ' ',
                                style: TextStyle(
                                  fontSize: 15,
                                  // fontWeight: FontWeight.bold,
                                  // color: Colors.pinkAccent
                                ),
                              ),
                        TextSpan(
                          text: S.of(context).day + notification['date'],
                          // style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                      ])
                : TextSpan(
                    style: TextStyle(
                      color: FitnessAppTheme.lightText,
                    ),
                    text: !left
                        ? 'لقد تم رفض طلبك المتعلق ب'
                        : 'لقد تم رفض : ' +
                            (Common.formatNumber(notification['info'][
                                notification['info']['type'] == 'token'
                                    ? 'rejected_token'
                                    : 'rejected_point'])) +
                            ' من ',
                    children: <InlineSpan>[
                        TextSpan(
                          text: notification['info']['type'] == 'token'
                              ? S.of(context).token + ' '
                              : S.of(context).point + ' ',
                          style: TextStyle(
                            fontSize: 15,
                            // fontWeight: FontWeight.bold,
                            // color: Colors.lightGreen
                          ),
                        ),
                        TextSpan(
                          text: S.of(context).transaction_value,
                          // style: TextStyle(
                          //     fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        notification['info']['type'] == 'token'
                            ? TextSpan(
                                text: Common.formatNumber(
                                        notification['info']['count']) +
                                    ' ',
                                style: TextStyle(
                                  fontSize: 15,
                                  // fontWeight: FontWeight.bold,
                                  // color: Colors.pinkAccent
                                ),
                              )
                            : TextSpan(
                                text: Common.formatNumber(
                                        notification['info']['cost']) +
                                    ' ',
                                style: TextStyle(
                                  fontSize: 15,
                                  // fontWeight: FontWeight.bold,
                                  // color: Colors.pinkAccent
                                ),
                              ),
                        TextSpan(
                          text: S.of(context).day + notification['date'],
                          // style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                      ])),
        textAlign: TextAlign.start,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    else
      return Text.rich(
        TextSpan(
            text: 'لقد تم اضافة رصيد  ',
            style: TextStyle(
              color: FitnessAppTheme.lightText,
            ),
            children: <InlineSpan>[
              TextSpan(
                text: notification['info']['type'] == 'point'
                    ? 'من النقاط  '
                    : 'من توكنز ',
                // style: TextStyle(
                //     fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: S.of(context).transaction_value,
                // style: TextStyle(
                //     fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: Common.formatNumber(notification['info']['cost']) + ' ',
                style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                  // color: Colors.pinkAccent
                ),
              ),
              TextSpan(
                text: ' الى رصيدك ',
                style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                  // color: Colors.lightGreen
                ),
              ),
              TextSpan(
                text: S.of(context).day + notification['date'],
                // style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
            ]),
        textAlign: TextAlign.start,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            // scrollDirection: Axis.horizontal,
            child: Column(
          children: [
            groups.length == 0
                ? Container(
                    margin: EdgeInsets.only(top: 0, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: HexColor(FitnessAppTheme.gradiantFc)
                                .withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              // top: MediaQuery.of(context).padding.top,
                              left: 16,
                              right: 16),
                          child: Image.asset(
                            'assets/icons/logot.png',
                            width: 250,
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(right: 11, left: 11, bottom: 11),
                          child: Text(
                            'لا توجد أي إشعارات',
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            Column(
              children: [
                Column(
                  children: _getColumns(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.transparent),
                      ),
                      onPressed: () async {
                        setState(() {
                          _currentPage = _currentPage + 1;
                        });
                        await __getNotifications();
                      },
                      child: Text(
                        'تحميل المزيد',
                        style: TextStyle(fontSize: 16 ,color: FitnessAppTheme.nearlyDarkREd),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        )));
  }
}
