import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:flutter/material.dart';

class HistoryDatatable extends StatefulWidget {
  const HistoryDatatable(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation,this.parentScrollController})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final ScrollController? parentScrollController;

  @override
  _HistoryDatatable createState() => _HistoryDatatable();
}

class _HistoryDatatable extends State<HistoryDatatable> with TickerProviderStateMixin {
  AnimationController? animationController;

  var transactions = [];
    List<String> columns = [
      '#',
      S().count,
      S().cost_d,
      S().date
    ];

    var testT = [
      {
        'id' : '1',
        'count' : 'count' ,
        'cost' : 'cost',
        'date' : 'date'
      }
    ];

    

   __getTransactions() async {
    
    __getOldTransactions();
      var t = await AuthApi().getTransactions();
      var body = jsonDecode(t.body);
      if(body['status'])
      {
        if(this.mounted)
        setState(() {
          var data = AuthApi().getData(body);
          transactions = data['transactions'];
        });

        await GetData().updateTransactions(transactions);

      }

      
  }

  __getOldTransactions() async{
    var t = await GetData().getTransaction();
    if(t!=null){
      if(this.mounted)
      setState(() {
          transactions = jsonDecode(t);
      });
    }
  }

  
  @override
  void initState() {
     animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    
    __getTransactions();

    super.initState();

    widget.parentScrollController?.addListener(()  {
      if (widget.parentScrollController?.position.pixels == widget.parentScrollController?.position.minScrollExtent) {
           __getTransactions();
       }
      });
  }


  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {

       return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columns: List<DataColumn>.generate(columns.length,(counter) => DataColumn(
                label: Text(
                columns[counter],
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: FitnessAppTheme.nearlyDarkREd),
              ))), rows: List<DataRow>.generate(transactions.length,(counter) => 
                  DataRow(cells: [
                    DataCell(Text('#' + transactions[counter]['id'].toString(),style: TextStyle(color: FitnessAppTheme.nearlyDarkREd,fontWeight: FontWeight.bold),)),
                    DataCell(Text(transactions[counter]['count'].toString(),style: TextStyle(fontWeight: FontWeight.bold,color: FitnessAppTheme.lightText),)),
                    DataCell(Text(transactions[counter]['cost'].toString(),style: TextStyle(fontWeight: FontWeight.bold,color: FitnessAppTheme.lightText))),
                    DataCell(Text(transactions[counter]['tdate'].toString(),style: TextStyle(fontWeight: FontWeight.bold,color: FitnessAppTheme.nearlyDarkREd)))
                  ]),
              ))));

      });
  }
}
