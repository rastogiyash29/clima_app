import 'dart:developer';

import 'package:http/http.dart' as http;

class NetworkHelper{
  final String url;
  NetworkHelper({required this.url});

  Future getRequest() async{
    try{
      http.Response response=await http.get(Uri.parse(url));
      if(response.statusCode==200){
        return response.body;
      }
    }catch(e){
      log('error while making get Request : ',error: e);
    }
  }
}