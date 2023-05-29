import 'dart:convert';

import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:async/async.dart';
import 'package:dio/dio.dart';



class AuthApi{

  final String _url = 'https://recharge-web.afandena-cards.com/api/';
  // final String _url = 'http://192.168.1.6/api/';

  getUrl(eurl){
    return _url + eurl;
  }

  login(data) async {

//     try {
//   final result = await InternetAddress.lookup('google.com');
//   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//     print('connected');
//   }
// } on SocketException catch (_) {
//   print('not connected');
// }

      var token_firebase =  await GetData().getFirebaseToken();

      data['token_firebase'] = token_firebase;

      var fullUrl = _url + 'login';

      return await http.post(Uri.parse(fullUrl),body: jsonEncode(data),headers: _setHeaders());
  }

  register(data,_hasConnection) async {

      var token_firebase =  await GetData().getFirebaseToken();
      var fullUrl = _url + 'register';
      data['token_firebase'] = token_firebase;

      return await http.post(Uri.parse(fullUrl),body: jsonEncode(data),headers: _setHeaders()).timeout(_hasConnection ? Duration(seconds: 60) : Duration.zero);
  }

  getUser() async {
    
//     try {
//   final result = await InternetAddress.lookup('google.com');
//   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//     print('connected');
//   }
// } on SocketException catch (_) {
//   print('not connected');
// }
      var auth = await GetData().getAuth();
      var token = await GetData().getToken();
      // print(auth);
      // print(token);

      var fullUrl = _url + 'user/'+auth['id'].toString();

      return await http.get(Uri.parse(fullUrl),headers: _setHeadersAuthorization(token));
 
  }

  
  update(data) async {
      print(data);
      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      var fullUrl = _url + 'user/'+auth['id'].toString();

     return await http.post(Uri.parse(fullUrl),body: jsonEncode(data),headers: _setHeadersAuthorization(token));
 
  }



  addToken(data,_hasConnection) async {

      var auth = await GetData().getAuth();
      var token = await GetData().getToken();


      var fullUrl = _url + 'transactions/'+auth['id'].toString();

     return await http.post(Uri.parse(fullUrl),body: jsonEncode(data),headers: _setHeadersAuthorization(token)).timeout(
      _hasConnection ? Duration(seconds: 60) : Duration.zero
     );
 
  }

  getTokenPackages() async {

    
      var auth = await GetData().getAuth();
      var token = await GetData().getToken(); 

      
      var fullUrl = _url + 'package/token/'+auth['id'].toString();     

      return await http.get(Uri.parse(fullUrl),headers: _setHeadersAuthorization(token));
 

  }


  
  getPointPackages() async {

    
      var auth = await GetData().getAuth();
      var token = await GetData().getToken(); 

      
      var fullUrl = _url + 'package/point/'+auth['id'].toString();     

      return await http.get(Uri.parse(fullUrl),headers: _setHeadersAuthorization(token));
 

  }

  updatePointCashUser(var cash) async {
    
      var auth = await GetData().getAuth();

      var ocash = auth['cash_point'];

      var ncash = ocash;
      try{
          ncash = ncash - cash;
      }catch(error){
      }
      
      auth['cash_point'] = ncash;

      updateUser({
        'user' : auth 
      });

  }

  
  updateTokenCashUser(var cash) async {
    
      var auth = await GetData().getAuth();

      var ocash = auth['cash'];

      var ncash = ocash;
      try{
          ncash = ncash - cash;
      }catch(error){
      }
      
      auth['cash'] = ncash;

      updateUser({
        'user' : auth 
      });

  }

  

  addPointWithoutP(data,hasConnection) async{
      
      var auth = await GetData().getAuth();
      var token = await GetData().getToken();


      var fullUrl = _url + 'transactions/'+auth['id'].toString();

     return await http.post(Uri.parse(fullUrl),body: jsonEncode(data),headers: _setHeadersAuthorization(token)).timeout(hasConnection ? Duration(seconds: 60) : Duration.zero);
 
      // var auth = await GetData().getAuth();
      // var token = await GetData().getToken();
      
      
      // FormData formData =  FormData.fromMap({
      //   'count': data['count'],
      //   'cost': data['cost'],
      //   'type': data['type'],
      //   'name_of_player' : data['name_of_player'],
      //   'point_packages' : jsonEncode(data['point_packages'])
      // });

      
      // var fullUrl = _url + 'transactions/'+auth['id'].toString();
      
      
      
      //  Dio dio = Dio();

      //  return await dio.post(fullUrl,
      //  data: formData,
      //  options: Options(headers: _setHeadersAuthorization(token))
      //  );

       
       
  }

  addPoint(data,PickedFile? file) async{
      
      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      FormData formData =  FormData.fromMap({
        'count': data['count'],
        'cost': data['cost'],
        'type': data['type'],
        'file': await MultipartFile.fromFile(file!.path)
      });
      
      var fullUrl = _url + 'transactions/'+auth['id'].toString();
      
      
      
       Dio dio = Dio();

       return await dio.post(fullUrl,
       data: formData,
       options: Options(headers: _setHeadersAuthorization(token))
       );

  }

  updatePhoto(PickedFile? file) async{
      
      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      FormData formData =  FormData.fromMap({
        'file': await MultipartFile.fromFile(file!.path)
      });
      
      var fullUrl = _url + 'user/'+auth['id'].toString();
      
      
      
       Dio dio = Dio();

       return await dio.post(fullUrl,
       data: formData,
       options: Options(headers: _setHeadersAuthorization(token))
       );

  }

  getTransactions() async{

      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      var fullUrl = _url + 'transactions/'+auth['id'].toString();

     return await http.get(Uri.parse(fullUrl),headers: _setHeadersAuthorization(token));
 
  }
  
   getPaginatedTransactions(page) async{

      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      var fullUrl = _url + 'transactions/'+auth['id'].toString();

      Dio dio = Dio();
      
      return await dio.get(fullUrl,
          queryParameters: {
            'page' : page
          },
          options: Options(headers: _setHeadersAuthorization(token))
       );
  }

  getRecentTransactions(data) async{

      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      var fullUrl = _url + 'transactions/'+auth['id'].toString();

      Dio dio = Dio();
      
      return await dio.get(fullUrl,
          queryParameters: data,
          options: Options(headers: _setHeadersAuthorization(token))
       );
  }

   getNotifications() async{

      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      var fullUrl = _url + 'notifications/'+auth['id'].toString();

      print('_url');
      print(_url);

     return await http.get(Uri.parse(fullUrl),headers: _setHeadersAuthorization(token));
 
  }

  getPNotifications(page) async{

      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      var fullUrl = _url + 'notifications/'+auth['id'].toString() + '?page='+page.toString();

     return await http.get(Uri.parse(fullUrl),headers: _setHeadersAuthorization(token));
 
  }

  filterDates(data) async{

      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      var fullUrl = _url + 'transactions/date/'+auth['id'].toString();
        print(fullUrl);
        
       Dio dio = Dio();

      return await dio.get(fullUrl,
          data: data,
          options: Options(headers: _setHeadersAuthorization(token))
       );
 
  }



  getData(data){
    return data['data'];
  }

  updateUser(data) async{
    
      SharedPreferences storage = await GetData().getInstance();
      storage.setString('user', jsonEncode(data['user']));
  }

  _setHeaders() => {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': "*/*",
      'connection': 'keep-alive',
      'Accept-Encoding' : 'gzip, deflate, br',
  };

  _setHeadersAuthorization(var token) => {
      'Content-Type': 'application/json',
      'Accept': "*/*",
      'connection': 'keep-alive',
      'Accept-Encoding' : 'gzip, deflate, br',
      'Authorization': 'Bearer $token',
  };

}