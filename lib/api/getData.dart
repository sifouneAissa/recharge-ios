import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class GetData {
    
    getAuth() async {
        var storage = await getInstance();
        return jsonDecode(storage.getString('user'));
    }

  getToken() async {
        var storage = await getInstance();
        return storage.getString('token');
    }

    getFirebaseToken() async {
        var storage = await getInstance();
        return storage.getString('firebase_token');
    }

  getMonths() async {
        var storage = await getInstance();
        return storage.getString('months');
    }

  updateMonths(months) async {
        var storage = await getInstance();
        return storage.setString('months',jsonEncode(months));
  }

  getTransaction() async {
        var storage = await getInstance();
        return storage.getString('transactions');
    }

    updateTransactions(transactions) async {
        var storage = await getInstance();
        return storage.setString('transactions',jsonEncode(transactions));
    }


    getDiffs() async{
      
        var storage = await getInstance();
        return storage.getString('diffs');
    }

    getTokenPackages() async{
      
        var storage = await getInstance();
        return storage.getString('packages');
    }

    
    getPointPackages() async{
      
        var storage = await getInstance();
        return storage.getString('point_packages');
    }

    updateTokenPackages(data) async {
        var storage = await getInstance();
        return storage.setString('packages',jsonEncode(data));
    }

    updatePointPackages(data) async {
        var storage = await getInstance();
        return storage.setString('point_packages',jsonEncode(data));
    }





     
    updateDiffs(diffs) async {
        var storage = await getInstance();
        return storage.setString('diffs',jsonEncode(diffs));
    }

    
    updateNotifications(notifications) async {
        var storage = await getInstance();
        return storage.setString('notifications',jsonEncode(notifications));
    }



  getNotification() async {
        var storage = await getInstance();
        return storage.getString('notifications');
    }

  getOTransaction() async {
        var storage = await getInstance();
        return storage.getString('transactions');
    }

  getInstance() async{
    
      SharedPreferences localeStorage = await SharedPreferences.getInstance();
      // save the token
      
      return localeStorage;
  }

  logout() async{
    
        SharedPreferences storage = await getInstance();
        storage.remove('user');
        storage.remove('transactions');
        storage.remove('notifications');
        storage.remove('token');

        FirebaseMessaging.instance.getToken().then((value) async {
        var storage = await GetData().getInstance();
        storage.setString('firebase_token',value);
    },);
    
  }
}


