import 'package:intl/intl.dart';
import 'package:flutter/material.dart';




class Common {
  static String  formatNumber(var value) {
    
    var v = value.toString();

    int dg = 0;
    
    if(v.split('.').length>1)
      dg = v.split('.').last.length;


    if(value is Null){
      value = 0.0;
    }

    if(value is String){
      
      value = double.parse(value);

    }


    return NumberFormat.simpleCurrency(decimalDigits: dg, name: ''
            // locale: 'en_IN',
            // symbol: ''
            )
        .format(value);
  }
}
