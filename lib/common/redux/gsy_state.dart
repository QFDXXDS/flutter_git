
import 'package:flutter_git/common/model/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_git/common/redux/user_redux.dart';
import 'package:flutter_git/common/redux/theme_redux.dart';
import 'package:flutter_git/common/redux/locale_redux.dart';

import 'package:redux/redux.dart';

class GSYState {
// 用户信息
  User userInfo ;
//  主题数据
  ThemeData themeData ;
//   语言
  Locale locale ;
//   当前手机平台
  Locale platformLocale ;
//  构造方法

  GSYState({this.userInfo,this.themeData,this.locale}) ;

}

GSYState appReducer(GSYState state, action) {

  return GSYState(

    userInfo: UserReducer(state.userInfo,action),
    themeData:ThemeDataReducer(state.themeData,action),
    locale: LocaleReducer(state.locale,action),
  ) ;

}

final List<Middleware<GSYState>> middleware = [



] ;

