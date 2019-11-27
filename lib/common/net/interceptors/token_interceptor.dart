
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter_git/common/local/local_storage.dart';

import 'package:flutter_git/common/config/config.dart';

class TokenInterceptors extends InterceptorsWrapper {

  String _token ;

  @override
  onRequest(RequestOptions options) async {

      if(_token == null) {

      var authorizationCode = await getAuthorization() ;
      if (authorizationCode != null) {

        _token = authorizationCode ;
      }
    }
    options.headers["Authorization"] = _token ;
    return options ;

  }
  @override
  onResponse(Response response) async {

    try {

      var responseJson = response.data ;
      if(response.statusCode == 201 && responseJson["token"] != null) {
        _token = 'token ' + responseJson["token"] ;
        await LocalStorage.save(Config.TOKEN_KEY, _token) ;

      }
    } catch (e){

      print(e) ;
    }
    return response ;
  }

  ///清除授权
  clearAuthorization() {
    this._token = null;
    LocalStorage.remove(Config.TOKEN_KEY);
  }

  getAuthorization() async {

    String token = await LocalStorage.get(Config.TOKEN_KEY) ;
    if(token == null) {
      String basic = await LocalStorage.get(Config.USER_BASIC_CODE) ;
      if(basic == null) {

      } else {
        return "Basic $basic" ;
      }
    } else {

      this._token = token;
      return token;
    }

  }

  }


