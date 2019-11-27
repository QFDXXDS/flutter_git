
import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:collection';


import 'package:flutter_git/common/net/interceptors/token_interceptor.dart';
import 'package:flutter_git/common/net/interceptors/header_interceptor.dart';
import 'package:flutter_git/common/net/interceptors/log_interceptor.dart';
import 'package:flutter_git/common/net/interceptors/error_interceptor.dart';
import 'package:flutter_git/common/net/interceptors/response_interceptor.dart';

import 'package:flutter_git/common/net/code.dart';
import 'package:flutter_git/common/net/result_data.dart';

class HttpManager {

  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  Dio _dio = Dio();

  final TokenInterceptors _tokenInterceptors = TokenInterceptors() ;
  
  HttpManager() {
    _dio.interceptors.add(HeaderInterceptors()) ;
    _dio.interceptors.add(_tokenInterceptors) ;
    _dio.interceptors.add(LogsInterceptors()) ;
    _dio.interceptors.add(ErrorInterceptors(_dio)) ;
    _dio.interceptors.add(ResponseInterceptors()) ;

  }

  netFetch(url, params, Map<String, dynamic> header, Options option, {noTip = false}) async {

    Map<String, dynamic> headers = HashMap() ;
    if(header != null) {
      headers.addAll(header) ;
    }

    if (option != null) {
      option.headers = headers ;
    } else {

      option = Options(method: "get") ;
      option.headers = headers ;
    }
//    定义一个函数
    resultError(DioError e) {
        Response errResponse ;
        if(e.response != null) {

          errResponse = e.response ;
        } else {

          errResponse = Response(statusCode: 666) ;

        }
        if(e.type == DioErrorType.CONNECT_TIMEOUT || e.type == DioErrorType.RECEIVE_TIMEOUT) {

          errResponse.statusCode = Code.NETWORK_TIMEOUT ;
        }
        return ResultData(Code.errorHandleFunction(errResponse.statusCode, e.message, noTip), false, errResponse.statusCode);

    }
    Response response ;
    try {

      response = await _dio.request(url,data: params,options: option) ;
    } on DioError  catch (e) {

      return resultError(e) ;

    }
    if(response.data is DioError) {
      return resultError(response.data) ;
    }
    return response.data ;

    }

  ///清除授权
  clearAuthorization() {

    _tokenInterceptors.clearAuthorization() ;
  }

  ///获取授权token
  getAuthorization() async {

    return await _tokenInterceptors.getAuthorization() ;
  }

}

final HttpManager httpManager = new HttpManager();
