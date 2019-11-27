
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:flutter_git/common/style/gsy_style.dart';
import 'package:flutter_git/common/utile/Common_utils.dart';
import 'package:flutter_git/widget/gsy_tabbar_widget.dart';

import 'package:flutter_git/page/dynamic_page.dart';
import 'package:flutter_git/page/trend_page.dart';
import 'package:flutter_git/page/my_page.dart';
import 'package:flutter_git/widget/gsy_title_bar.dart';
import 'package:flutter_git/common/localization/default_localization.dart';
import 'package:flutter_git/common/utile/navigator_utils.dart';
import 'package:flutter_git/widget/home_drawer.dart';


class HomePage extends StatelessWidget {
  static final String sName = "home";

 Future<bool> _dialogExitApp(BuildContext context ) async {
    ///如果是 android 回到桌面
    if (Platform.isAndroid) {

      AndroidIntent intent = AndroidIntent(
          action: 'android.intent.action.MAIN',
          category: 'android.intent.category.HOME'
      );
      await intent.launch() ;
    }
    return Future.value(false) ;
  }

  _renderTab(icon,text) {

   return Tab(

     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: <Widget>[
         Icon(icon,size: 16.0),
         Text(text),
       ],
     ),
   );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    List<Widget> tabs = [
      _renderTab(GSYICons.MAIN_DT, CommonUtils.getLocale(context).home_dynamic ),
      _renderTab(GSYICons.MAIN_QS, CommonUtils.getLocale(context).home_trend ),
      _renderTab(GSYICons.MAIN_MY, CommonUtils.getLocale(context).home_my ),
    ];

    return WillPopScope(
      onWillPop: () {
        return _dialogExitApp(context) ;
         },
      child: GSYTabBarWidget(
        drawer: HomeDrawer(),
        type: GSYTabBarWidget.BOTTOM_TAB,
        tabItems: tabs,
        tabViews: <Widget>[
          DynamicPage(),
          TrendPage(),
          MyPage(),
        ],
        backgroundColor: GSYColors.primarySwatch,
        indicatorColor: Color(GSYColors.white),
        title: GSYTitleBar(
          GSYLocalizations.of(context).currentLocalized.app_name,
          iconData: GSYICons.MAIN_SEARCH,
          needRightLocalIcon: true,
          onPressed: (){
            NavigatorUtils.goSearchPage(context);
          },
        ),

      ),
    );
  }
}


