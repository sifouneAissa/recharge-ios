import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/constants.dart';
import 'package:best_flutter_ui_templates/fitness_app/common.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HistoryChart extends StatefulWidget {
  const HistoryChart({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _HistoryChartState createState() => _HistoryChartState();
}

class _HistoryChartState extends State<HistoryChart> {
  bool _showD = false;
  late ZoomPanBehavior _zoomPanBehavior;
  var data;
  bool _loading = false;
  double t_tokens = 0;
  double t_points = 0;
  var transactions;
  var stransactions;
  String? sDate;
  String? eDate;
  List<String> months = [
    'جانفي',
    'فيفري',
    'مارس',
    'افريل',
    'ماي',
    'جوان',
    'جويلية',
    'أوت',
    'سبتمبر',
    'اكتوبر',
    'نوفمبر',
    'ديسمبر'
  ];

  var monthsN = {
    '1': {'token_cash': 0, 'point_cash': 0.0},
    '2': {'token_cash': 0, 'point_cash': 0.0},
    '3': {'token_cash': 0, 'point_cash': 0.0},
    '4': {'token_cash': 0, 'point_cash': 0.0},
    '5': {'token_cash': 0, 'point_cash': 0.0},
    '6': {'token_cash': 0, 'point_cash': 0.0},
    '7': {'token_cash': 0, 'point_cash': 0.0},
    '8': {'token_cash': 0, 'point_cash': 0.0},
    '9': {'token_cash': 0, 'point_cash': 0.0},
    '10': {'token_cash': 0, 'point_cash': 0.0},
    '11': {'token_cash': 0, 'point_cash': 0.0},
    '12': {'token_cash': 0, 'point_cash': 0.0}
  };

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      // Enables pinch zooming
      enableSelectionZooming: true,
      selectionRectBorderColor: Colors.red,
      selectionRectBorderWidth: 1,
      selectionRectColor: Colors.grey,
      enablePinching: true,
    );

    __getOldTransactions();
    _getData();
    super.initState();
  }

  initSMonths() {
    return {
      '1': {'token_cash': 0, 'point_cash': 0.0},
      '2': {'token_cash': 0, 'point_cash': 0.0},
      '3': {'token_cash': 0, 'point_cash': 0.0},
      '4': {'token_cash': 0, 'point_cash': 0.0},
      '5': {'token_cash': 0, 'point_cash': 0.0},
      '6': {'token_cash': 0, 'point_cash': 0.0},
      '7': {'token_cash': 0, 'point_cash': 0.0},
      '8': {'token_cash': 0, 'point_cash': 0.0},
      '9': {'token_cash': 0, 'point_cash': 0.0},
      '10': {'token_cash': 0, 'point_cash': 0.0},
      '11': {'token_cash': 0, 'point_cash': 0.0},
      '12': {'token_cash': 0, 'point_cash': 0.0}
    };
  }

  var pointPackages;

  getSDates() {
    if (sDate != null && eDate != null) {
      return PickerDateRange(
          DateTime.parse(sDate ?? ''), DateTime.parse(eDate ?? ''));
    }
    return null;
  }

  initPointPackages() {
    return {'100%': 0, '150%': 0, '300%': 0};
  }

  getPointPackages() {
    var codes = ['100%', '150%', '300%'];

    var names = ['مسرع احمر', 'مسرع أزرق', 'مسرع أسود'];

    var colors = [Colors.red, Colors.blue, Colors.black87];

    return List.generate(
        pointPackages.length,
        (index) => Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.remove,
                      color: colors[index],
                    ),
                    Text(
                      'مجموع ماشحنت من ' + names[index] + ' : ',
                      style: TextStyle(color: FitnessAppTheme.lightText),
                    ),
                    Text(
                        style: TextStyle(
                            color: FitnessAppTheme.lightText, fontSize: 15),
                        Common.formatNumber(
                            pointPackages[codes[index]].toString())),
                  ],
                ),
              ),
            ));
  }

  bottomSheetPoint() {
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
              decoration: getBoxBackgroud(),
              height: 200,
              child: Column(
                children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text('معلومات حول المسرعات',
                              style:
                                  TextStyle(color: FitnessAppTheme.lightText)),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: getPointPackages(),
                  )
                ],
              ),
            );
          });
        });
  }

  __getOldTransactions() async {
    var t = await GetData().getTransaction();

    if (t != null) {
      setState(() {
        transactions = jsonDecode(t);
      });
    }
  }

  _getData() async {
    __getOldMonths();
    var res = await AuthApi().filterDates({});

    var body = res.data;
    if (body['status']) {
      var dataa = AuthApi().getData(body);

      setState(() {
        data = dataa['months'];
        updateData(null, null, true);
      });

      await GetData().updateMonths(data);
    }
  }

  __getOldMonths() async {
    var t = await GetData().getMonths();

    if (t != null) {
      setState(() {
        data = jsonDecode(t);
        updateData(null, null, true);
      });
    }
  }

  updateData(startDate, endDate, bool force) {
    if ((startDate != null && endDate != null) || force) {
      var stokens = 0.0;
      var scost = 0.0;
      var smonths = initSMonths();
      var sPointPackages = initPointPackages();
      // send api to the server filtering data
      if ((startDate != null && endDate != null) || force) {
        var t = transactions;
        if (!force)
          t = transactions.where(
            (element) {
              var ldate = DateTime.parse(element['created_at']);
              return ldate.isBefore(endDate) && ldate.isAfter(startDate);
            },
          ).toList();

        t.forEach(
          (element) {
            bool isToken = element['type'] == 'token';
            var value = smonths[
                (DateTime.parse(element['created_at']).month + 1).toString()];

            if (isToken) {
              stokens = stokens + element['count'];
              value!['token_cash'] = value!['token_cash']! + element!['count'];
            } else {
              var packagePoints = element['point_packages'];

              packagePoints.forEach((p) {
                sPointPackages[p['package_name']] =
                    p['count'] + sPointPackages[p['package_name']];
              });

              scost = scost + element['cost'];

              value!['point_cash'] =
                  value!['point_cash']! + element!['cost'];
            }
            // set array
          },
        );

        setState(() {
          stransactions = t;
          final DateFormat formatter = DateFormat('yyyy-MM-dd', 'en');
          if (startDate != null && endDate != null) {
            sDate = formatter.format(startDate).toString();
            eDate = formatter.format(endDate).toString();
          }
          t_points = scost;
          t_tokens = stokens;
          data = smonths;
          pointPackages = sPointPackages;
        });
      } else
        setState(() {
          stransactions = transactions;
        });

      // setState(() {
      //   _loading = true;
      // });

      // var res = await AuthApi().filterDates(
      //     {'end': endDate.toString(), 'start': startDate.toString()});

      // var body = res.data;

      // if (body['status']) {
      //   var dataa = AuthApi().getData(body);

      //   setState(() {
      //     t_tokens = 0;
      //     t_points = 0;
      //     data = dataa['months'];
      //   });
      // }
      //
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) async {
    var startDate = args.value.startDate;
    var endDate = args.value.endDate;

    updateData(startDate, endDate, false);
  }

  getSalesDataToken() {
    if (data == null)
      return List<SalesData>.generate(
          months.length, (index) => SalesData(months[index], 0));
    else
      return List<SalesData>.generate(months.length, (index) {
        setState(() {
          // t_tokens = t_tokens + data[(index + 1).toString()]['token_cash'];
        });

        return SalesData(
            months[index],
            double.parse(
                data[(index + 1).toString()]['token_cash'].toString()));
      });
  }

  getSalesDataPOint() {
    if (data == null)
      return List<SalesData>.generate(
          months.length, (index) => SalesData(months[index], 0));
    else
      return List<SalesData>.generate(months.length, (index) {
        setState(() {
          // t_points = t_points + data[(index + 1).toString()]['point_cash'];
        });

        return SalesData(
            months[index],
            double.parse(
                data[(index + 1).toString()]['point_cash'].toString()));
      });
  }

  getChartSampleDataToken() {
    if (data == null)
      return List<ChartSampleData>.generate(
          months.length, (index) => ChartSampleData(x: months[index], y: 0));
    else
      return List<ChartSampleData>.generate(months.length, (index) {
        setState(() {
          // t_points = t_points + data[(index + 1).toString()]['token_cash'];
        });

        return ChartSampleData(
            x: months[index],
            y: double.parse(
                data[(index + 1).toString()]['token_cash'].toString()));
      });
  }

  getChartSampleDataPoint() {
    if (data == null)
      return List<ChartSampleData>.generate(
          months.length, (index) => ChartSampleData(x: months[index], y: 0));
    else
      return List<ChartSampleData>.generate(months.length, (index) {
        setState(() {
          // t_points = t_points + data[(index + 1).toString()]['point_cash'];
        });

        return ChartSampleData(
            x: months[index],
            y: double.parse(
                data[(index + 1).toString()]['point_cash'].toString()));
      });
  }

  /// Get default column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeriesPoint() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: getChartSampleDataPoint(),
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, textStyle: TextStyle(fontSize: 10)),
      )
    ];
  }

  /// Get default column series
  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeriesToken() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: getChartSampleDataToken(),
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, textStyle: TextStyle(fontSize: 10)),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: Text('بحث حسب التاريخ :',
                  style: TextStyle(color: FitnessAppTheme.lightText)),
              onTap: () {
                setState(() {
                  _showD = !_showD;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.date_range),
              tooltip: 'بحث حسب التاريخ',
              color: _showD ? Colors.green : FitnessAppTheme.lightText,
              onPressed: () {
                setState(() {
                  _showD = !_showD;
                });
              },
            ),
          ],
        ),
        _showD
            ? Center(
                child: SfDateRangePicker(
                  selectionMode: DateRangePickerSelectionMode.range,
                  navigationMode: DateRangePickerNavigationMode.snap,
                  onSelectionChanged: _onSelectionChanged,
                  initialSelectedRange: getSDates(),
                ),
              )
            : Container(),
        Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black87),
                  gradient: LinearGradient(colors: [
                    HexColor('00FFFFFF').withOpacity(0.5),
                    HexColor(FitnessAppTheme.nearlyBlack.value.toString()),
                    HexColor(FitnessAppTheme.gradiantFc),
                    HexColor(FitnessAppTheme.nearlyBlack.value.toString()),
                    HexColor(FitnessAppTheme.gradiantFc),
                    HexColor('00FFFFFF').withOpacity(0.5),
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  color: FitnessAppTheme.nearlyBlack,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: FitnessAppTheme.nearlyDarkREd.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                margin: EdgeInsets.only(right: 10,left: 10),
                // width: MediaQuery.of(context).size.width * 0.3,
                // height: MediaQuery.of(context).size.height * 0.33,
                // color:Colors.amber,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text.rich(TextSpan(
                            text: 'توكنز : ',
                            style: TextStyle(color: FitnessAppTheme.lightText),
                            children: [
                              TextSpan(
                                  text: Common.formatNumber(
                                      t_tokens.toInt().toString()),
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ])),
                      ),
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              10), // <= No more error here :)
                          color: FitnessAppTheme.nearlyBlue,
                        ),
                        margin: EdgeInsets.only(bottom: 5, top: 5),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Text('مجموع ما شحنت ',
                                style: TextStyle(
                                    color: FitnessAppTheme.lightText)),
                            Text('من توكنز',
                                style: TextStyle(
                                    color: FitnessAppTheme.lightText)),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            _buildDefaultColumnChartToken()
          ],
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                bottomSheetPoint();
              },
              child: Container(
                  // width: MediaQuery.of(context).size.width * 0.45,
                  // height: MediaQuery.of(context).size.height * 0.33,
                  // color:Colors.amber,

                margin: EdgeInsets.only(right: 10,left: 10),
                  decoration: BoxDecoration(
                    // color: FitnessAppTheme.nearlyBlack,
                    border: Border.all(color: Colors.black87),
                    gradient: LinearGradient(colors: [
                      HexColor('00FFFFFF').withOpacity(0.5),
                      HexColor(FitnessAppTheme.nearlyBlack.value.toString()),
                      HexColor(FitnessAppTheme.gradiantFc),
                      HexColor(FitnessAppTheme.nearlyBlack.value.toString()),
                      HexColor(FitnessAppTheme.gradiantFc),
                      HexColor('00FFFFFF').withOpacity(0.5),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: FitnessAppTheme.nearlyDarkREd.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text.rich(TextSpan(
                              text: 'مسرعات : ',
                              style:
                                  TextStyle(color: FitnessAppTheme.lightText),
                              children: [
                                TextSpan(
                                    text: Common.formatNumber(
                                        t_points.toInt().toString()),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ])),
                        ),
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                10), // <= No more error here :)
                            color: Colors.red,
                          ),
                          margin: EdgeInsets.only(bottom: 5, top: 5),
                        ),
                        Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Text('مجموع ما شحنت ',
                                    style: TextStyle(
                                        color: FitnessAppTheme.lightText)),
                                Text('من مسرعات',
                                    style: TextStyle(
                                        color: FitnessAppTheme.lightText)),
                              ],
                            ))
                      ],
                    ),
                  )),
            ),
            _buildDefaultColumnChartPoint(),
          ],
        )
      ],
    );
  }

  /// Get default column chart
  SfCartesianChart _buildDefaultColumnChartPoint() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: 'مسرعات نقاط معاملات ومصاريف',
          textStyle: TextStyle(color: FitnessAppTheme.lightText)),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}',
          labelStyle: TextStyle(color: FitnessAppTheme.lightText),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumnSeriesPoint(),
    );
  }

  SfCartesianChart _buildDefaultColumnChartToken() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: 'توكنز معاملات ومصاريف',
          textStyle: TextStyle(color: FitnessAppTheme.lightText)),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}',
          labelStyle: TextStyle(color: FitnessAppTheme.lightText),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumnSeriesToken(),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double? y;
}

///Chart sample data
class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}
