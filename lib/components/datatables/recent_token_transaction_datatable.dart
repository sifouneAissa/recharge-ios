import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/constants.dart';
import 'package:best_flutter_ui_templates/fitness_app/common.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/jawaker_accelerator/add_token_form.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/services.dart';

class RecentTokenTransactionDatatable extends StatefulWidget {
  const RecentTokenTransactionDatatable(
      {Key? key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.parentScrollController})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final ScrollController? parentScrollController;

  @override
  _RecentTokenTransactionDatatable createState() =>
      _RecentTokenTransactionDatatable();
}

class _RecentTokenTransactionDatatable
    extends State<RecentTokenTransactionDatatable>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  final _bottomSheetScrollController = ScrollController();
  var transactions = [];
  bool _copied = false;
  List<String> columns = [
    '#',
    'الحالة',
    S().count,
    // S().cost_d,
    'معرف الحساب',
    'اسم اللاعب',
    S().date
  ];

  var testT = [
    {'id': '1', 'count': 'count', 'cost': 'cost', 'date': 'date'}
  ];

  __getTransactions() async {
    __getOldTransactions();
    // var t = await AuthApi().getTransactions();
    var t = await AuthApi().getRecentTransactions({'only': 5, 'type': 'token'});

    var body = t.data;

    if (body['status']) {
      if(this.mounted)
      setState(() {
        var data = AuthApi().getData(body);
        transactions = data['transactions'];
        transactions = transactions
            .where((element) => element['type'] == 'token')
            .toList()
            .take(5)
            .toList();
      });

      // await GetData().updateTransactions(transactions);
    }
  }

  __getOldTransactions() async {
    var t = await GetData().getTransaction();
    if (t != null) {
      setState(() {
        transactions = jsonDecode(t);
        transactions = transactions
            .where((element) => element['type'] == 'token')
            .toList()
            .take(5)
            .toList();
      });
    }
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    __getTransactions();
    super.initState();

    widget.parentScrollController?.addListener(() async {
      if (widget.parentScrollController?.position.pixels ==
          widget.parentScrollController?.position.minScrollExtent) {
        await __getTransactions();
      }
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    widget.parentScrollController?.dispose();
    super.dispose();
  }

  transactionStatus(transaction) {
    String text = transactionText(transaction);
    return Text(text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: FitnessAppTheme.lightText));
  }

  transactionText(transaction) {
    String text = '';
    if (transaction['waiting'])
      text = 'يتم مراجعة الطلب';
    else if (transaction['accepted'])
      text = 'تم قبول الطلب';
    else if (transaction['rejected'])
      text = 'تم رفض طلبك';
    else if (transaction['more']) text = transaction['status']['message'];

    return text;
  }

  transactionColors(transaction) {
    Color? color;
    if (transaction['waiting'])
      color = Colors.grey.withOpacity(0.1);
    else if (transaction['accepted'])
      color = Colors.greenAccent.withOpacity(0.1);
    else if (transaction['rejected'])
      color = Colors.redAccent.withOpacity(0.1);
    else if (transaction['more']) color = Colors.redAccent.withOpacity(0.1);

    return color;
  }

  transactionSubStatus(transaction) {
    String text = '';
    if (transaction['status'] == 'waiting')
      text = 'يتم مراجعة الحزمة';
    else if (transaction['status'] == 'accepted')
      text = 'تم قبول الحزمة';
    else if (transaction['status'] == 'rejected')
      text = 'تم رفض الحزمة';
    else if (transaction['more']) text = transaction['status']['message'];

    return Text(text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: FitnessAppTheme.lightText));
  }

  getTokens(tokensPackages) {
    // double _cost = 0;
    var _tokens = 0;
    tokensPackages.forEach((element) {
      PackageTokenData elementT = PackageTokenData(
          value: element['count'] is String
              ? element['count']
              : element['count'].toString(),
          packageData: element['token_package'],
          packageId: element['user_transaction_id']);

      var ttokens = 0;

      // int ncost = elementT.packageData['cost'] * double.parse(elementT.value) + ncost;
      ttokens =
          elementT.packageData['count'] * int.parse(elementT.value) + ttokens;

      // _cost = ncost + .0;
      _tokens = _tokens + ttokens;
    });

    return _tokens;
  }

  _getItemsList(transaction) {
    var tokensPackages = transaction['token_packages'];

    return List.generate(tokensPackages.length, (index) {
      PackageTokenData element = PackageTokenData(
          value: tokensPackages[index]['count'] is String
              ? tokensPackages[index]['count']
              : tokensPackages[index]['count'].toString(),
          packageData: tokensPackages[index]['token_package'],
          packageId: tokensPackages[index]['user_transaction_id']);

      Widget status =
          subTransactionIcon(tokensPackages[index]['token_operation']);

      return GestureDetector(
        onTap: () {
          if (tokensPackages[index]['token_operation'] != null)
            showSubSheetBuilder(tokensPackages[index]['token_operation']);
        },
        child: Container(
          margin: EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.withOpacity(0.08),
            // border: Border.all(color: Colors.black)
          ),
          child: Padding(
            padding: EdgeInsets.all(7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  margin: EdgeInsets.only(right: 0),
                  child: Text(Common.formatNumber(element.packageData['count']),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: FitnessAppTheme.nearlyWhite,
                      )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  margin: EdgeInsets.only(right: 20),
                  child: Text(Common.formatNumber(int.parse(element.value)),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: FitnessAppTheme.nearlyWhite,
                      )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  margin: EdgeInsets.only(right: 10),
                  child: status,
                ),
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.2,
                //   margin: EdgeInsets.only(right: 30),
                //   child:
                //       Text(cost.substring(0, cost.length > 5 ? 5 : cost.length)),
                // )
              ],
            ),
          ),
        ),
      );
    });
  }

  _getPackages(transaction) {
    // var tokensPackages = transaction['token_packages'];
    // int _tokens = getTokens(tokensPackages) - transaction['left_accepted'];
    int _tokens = transaction['token_accepted'] != null
        ? transaction['token_accepted']
        : 0;

    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: '-',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: FitnessAppTheme.lightText)),
                TextSpan(
                    text: S.of(context).transaction_package_selected,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: FitnessAppTheme.lightText))
              ])),
            ),
          ],
        ),
        Container(
          height: 2,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            // border: Border.all(color: Colors.black)
          ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // margin: EdgeInsets.only(left: 60),
                  child: Text(S.of(context).transaction_package,
                      style: TextStyle(
                        color: FitnessAppTheme.lightText,
                      )),
                ),
                Container(
                  width: 60,
                ),
                Container(
                  margin: EdgeInsets.only(right: 0),
                  child: Text(S.of(context).transaction_package_count,
                      style: TextStyle(
                        color: FitnessAppTheme.lightText,
                      )),
                ),
                Container(
                  width: 60,
                ),
                Container(
                  margin: EdgeInsets.only(right: 0),
                  child: Text(' الحالة',
                      style: TextStyle(
                        color: FitnessAppTheme.lightText,
                      )),
                )
              ],
            ),
          ),
        ),
        Container(
          child: Column(
            children: _getItemsList(transaction),
          ),
        ),
        Container(
          height: 15,
        ),
        Container(
          // width: MediaQuery.of(context).size.width * 0.5,
          // height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: FitnessAppTheme.grey.withOpacity(0.4),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 10.0),
              ]),
          child: Column(
            children: [
              Container(
                // height: MediaQuery.of(context).size.height * 0.1,
                // width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <HexColor>[
                        HexColor('#260202'),
                        HexColor('#F0AB2B'),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),

                child: Padding(
                  padding:
                      EdgeInsets.only(top: 20, bottom: 20, right: 50, left: 50),
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(Common.formatNumber(_tokens),
                          style: TextStyle(
                              fontSize: 20, color: Colors.amberAccent))),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    // color: Colors.white
                    ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                          S.of(context).tokens + Common.formatNumber(_tokens))),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  transactionIcon(transaction) {
    Widget? image = SizedBox();
    if (transaction['waiting'])
      image = Image.asset(
        'assets/icons/loading.gif',
        width: 20,
      );
    return image;
  }

  subTransactionIcon(transaction) {
    Widget? image = SizedBox();
    if (transaction != null) if (transaction['status'] == 'waiting')
      image = Image.asset(
        'assets/icons/loading.gif',
        width: 20,
        height: 20,
      );
    else if (transaction['status'] == 'accepted') {
      image = Icon(
        Icons.check,
        color: Colors.green,
        size: 20,
      );
    } else if (transaction['status'] == 'rejected') {
      image = Icon(
        Icons.close,
        color: Colors.redAccent,
        size: 20,
      );
    }

    return image;
  }

  showSubSheetBuilder(transaction) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: 250,
            child: Container(
                decoration: BoxDecoration(
                  gradient: getGradianBg(),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                margin: EdgeInsets.only(top: 0),
                child: Column(children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('معلومات حول الحزمة',
                              style: TextStyle(
                                color: FitnessAppTheme.lightText,
                              )),
                        )
                      ],
                    ),
                  ),
                  transaction['message'] != null
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(transaction['message'].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: FitnessAppTheme.nearlyDarkREd))
                            ],
                          ),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(S.of(context).transaction_status,
                            style: TextStyle(
                              color: FitnessAppTheme.lightText,
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            transactionSubStatus(transaction),
                            SizedBox(
                              width: 10,
                            ),
                            subTransactionIcon(transaction)
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'الحزمة : ',
                          style: TextStyle(
                            color: FitnessAppTheme.lightText,
                          ),
                        ),
                        Text(
                          Common.formatNumber(transaction['total_tokens']),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: FitnessAppTheme.lightText),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('الكمية : ',
                            style: TextStyle(
                              color: FitnessAppTheme.lightText,
                            )),
                        Text(Common.formatNumber(transaction['total_quantity']),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: FitnessAppTheme.lightText))
                      ],
                    ),
                  ),
                  transaction['accepted_token'] != null
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('الكمية التي تم قبولها : ',
                                  style: TextStyle(
                                    color: FitnessAppTheme.lightText,
                                  )),
                              Text(
                                  Common.formatNumber(
                                      transaction['accepted_token'] == null
                                          ? 0
                                          : transaction['accepted_token']),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: FitnessAppTheme.lightText))
                            ],
                          ),
                        )
                      : Container(),
                  transaction['rest_token'] != null
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('الكمية التي تم رفضها : ',
                                  style: TextStyle(
                                    color: FitnessAppTheme.lightText,
                                  )),
                              Text(
                                  Common.formatNumber(
                                      transaction['rest_token']),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ))
                            ],
                          ),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(S.of(context).transaction_date,
                            style: TextStyle(
                              color: FitnessAppTheme.lightText,
                            )),
                        Text(transaction['tupdated_at'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: FitnessAppTheme.white))
                      ],
                    ),
                  ),
                ])),
          );
        });
  }

  getTextToCopy(transaction) {
    String status = 'الحالة : ' + transactionText(transaction);
    String quantity = 'الحزم : ' + Common.formatNumber(transaction['count']);
    String account_id =
        S.of(context).transaction_player_id + transaction['account_id'];
    String day = S.of(context).transaction_date + transaction['tdate'];

    return '$status $quantity $account_id $day';
  }

  bottomSheetBuilder(transaction) {
    bool isW = transaction['waiting'];
    setState(() {
      _copied = false;
    });
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              height: 450,
              // decoration: getBoxBackgroud(),
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      HexColor((transactionColors(transaction) as Color).value.toString()),
                      HexColor(FitnessAppTheme.gradiantFc),
                      HexColor(FitnessAppTheme.gradiantFc),
                      // HexColor(FitnessAppTheme.gradiantSc),
                      // HexColor(FitnessAppTheme.gradiantSc),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    // color: transactionColors(transaction),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  margin: EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                  style: TextStyle(
                                    color: FitnessAppTheme.lightText,
                                  ),
                                  S.of(context).bottom_sheet_transaction_token),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: GestureDetector(
                                onTap: () async {
                                  Clipboard.setData(ClipboardData(
                                      text: getTextToCopy(transaction)));
                                  setState(() {
                                    _copied = true;
                                  });
                                  await Future.delayed(
                                      const Duration(milliseconds: 200));
                                  setState(() {
                                    _copied = false;
                                  });
                                },
                                child: Icon(
                                  Icons.copy,
                                  size: 30,
                                  color: _copied
                                      ? Colors.greenAccent
                                      : FitnessAppTheme.lightText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).transaction_status,
                              style: TextStyle(
                                color: FitnessAppTheme.lightText,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                transactionStatus(transaction),
                                SizedBox(
                                  width: 10,
                                ),
                                transactionIcon(transaction)
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                style: TextStyle(
                                  color: FitnessAppTheme.lightText,
                                ),
                                'الحزم : '),
                            Text(
                              Common.formatNumber(transaction['count']),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: FitnessAppTheme.lightText),
                            )
                          ],
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(right: 10),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       Text(S.of(context).transaction_price),
                      //       Text(Common.formatNumber(transaction['cost']),
                      //           style: TextStyle(fontWeight: FontWeight.bold))
                      //     ],
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).transaction_player_id,
                              style:
                                  TextStyle(color: FitnessAppTheme.lightText),
                            ),
                            Text(transaction['account_id'].toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: FitnessAppTheme.lightText))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).transaction_date,
                              style:
                                  TextStyle(color: FitnessAppTheme.lightText),
                            ),
                            Text(transaction['tdate'].toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: FitnessAppTheme.white))
                          ],
                        ),
                      ),
                      isW
                          ? Container()
                          : transaction['message'] != null ||
                                  transaction['player_name'] != null
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: 20, right: 30, left: 30),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: FitnessAppTheme.nearlyDarkREd),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        transaction['message'] != null
                                            ? Container(
                                                // margin: EdgeInsets.only(right : 50,left: 50),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                          transaction[
                                                              'message'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: FitnessAppTheme
                                                                  .nearlyDarkREd)),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        transaction['player_name'] != null
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(right: 0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'اسم اللاعب : ',
                                                      style: TextStyle(
                                                        color: FitnessAppTheme
                                                            .lightText,
                                                      ),
                                                    ),
                                                    Text(
                                                        transaction[
                                                            'player_name'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: FitnessAppTheme
                                                                .nearlyDarkREd))
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        // Container(
                                        //   margin: EdgeInsets.only(right: 10),
                                        //   child: Row(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.center,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.center,
                                        //     children: [
                                        //       Text('الكمية التي تم رفضها : '),
                                        //       Text(
                                        //           Common.formatNumber(
                                        //               transaction['left_accepted']),
                                        //           style: TextStyle(
                                        //               fontWeight: FontWeight.bold,
                                        //               color: Colors.redAccent))
                                        //     ],
                                        //   ),
                                        // ),
                                        // Container(
                                        //   margin: EdgeInsets.only(right: 10),
                                        //   child: Row(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.center,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.center,
                                        //     children: [
                                        //       Text('الكمية التي تم قبولها : '),
                                        //       Text(
                                        //           Common.formatNumber(
                                        //               transaction['token_accepted']),
                                        //           style: TextStyle(
                                        //               fontWeight: FontWeight.bold,
                                        //               color: FitnessAppTheme
                                        //                   .nearlyDarkREd))
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),

                      Expanded(
                        child: ListView(
                          controller: _bottomSheetScrollController,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10, top: 20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [_getPackages(transaction)],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.mainScreenAnimationController!,
        builder: (BuildContext context, Widget? child) {
          return AdaptiveScrollbar(
            underColor: FitnessAppTheme.grey.withOpacity(0.3),
            sliderDefaultColor: FitnessAppTheme.grey.withOpacity(0.7),
            sliderActiveColor: FitnessAppTheme.grey,
            controller: _verticalScrollController,
            child: AdaptiveScrollbar(
                controller: _horizontalScrollController,
                position: ScrollbarPosition.bottom,
                underColor: FitnessAppTheme.grey.withOpacity(0.3),
                sliderDefaultColor: FitnessAppTheme.grey.withOpacity(0.7),
                sliderActiveColor: FitnessAppTheme.grey,
                child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: SingleChildScrollView(
                      controller: _verticalScrollController,
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              showBottomBorder: true,
                              columns: List<DataColumn>.generate(
                                  columns.length,
                                  (counter) => DataColumn(
                                          label: Text(
                                        columns[counter],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: FitnessAppTheme.white),
                                      ))),
                              rows: List<DataRow>.generate(
                                transactions.length,
                                (counter) => DataRow(
                                  color: MaterialStatePropertyAll(
                                      transactionColors(transactions[counter])),

                                  cells: [
                                    DataCell(
                                      Text(
                                        '#' +
                                            transactions[counter]['id']
                                                .toString(),
                                        style: TextStyle(
                                            color: FitnessAppTheme.lightText,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () {
                                        bottomSheetBuilder(
                                            transactions[counter]);
                                      },
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          transactionStatus(
                                              transactions[counter]),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          transactionIcon(transactions[counter])
                                        ],
                                      ),
                                      onTap: () {
                                        bottomSheetBuilder(
                                            transactions[counter]);
                                      },
                                    ),
                                    DataCell(
                                      Text(
                                        Common.formatNumber(
                                            transactions[counter]['count']),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: FitnessAppTheme.lightText),
                                      ),
                                      onTap: () {
                                        bottomSheetBuilder(
                                            transactions[counter]);
                                      },
                                    ),
                                    // DataCell(
                                    //   Text(
                                    //       Common.formatNumber(
                                    //           transactions[counter]['cost']),
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //           color:
                                    //               FitnessAppTheme.lightText)),
                                    //   onTap: () {
                                    //     bottomSheetBuilder(
                                    //         transactions[counter]);
                                    //   },
                                    // ),
                                    DataCell(
                                        Text(
                                          transactions[counter]['account_id']
                                              .toString(),
                                          style: TextStyle(
                                            color: FitnessAppTheme.lightText,
                                          ),
                                        ), onTap: () {
                                      bottomSheetBuilder(transactions[counter]);
                                    }),
                                    DataCell(
                                        Text(
                                          transactions[counter]['player_name']
                                              .toString(),
                                          style: TextStyle(
                                            color: FitnessAppTheme.lightText,
                                          ),
                                        ), onTap: () {
                                      bottomSheetBuilder(transactions[counter]);
                                    }),
                                    DataCell(
                                      Text(
                                          transactions[counter]['tdate']
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  FitnessAppTheme.lightText)),
                                      onTap: () {
                                        bottomSheetBuilder(
                                            transactions[counter]);
                                      },
                                    )
                                  ],
                                  // color: transactions[counter]['type'].toString() == 'token' ? MaterialStateProperty.all(Colors.lightGreen) : MaterialStateProperty.all(Colors.pinkAccent)
                                ),
                              ))),
                    ))),
          );
        });
  }
}
