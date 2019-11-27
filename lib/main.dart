import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_git/common/redux/gsy_state.dart';
import 'package:flutter_git/common/model/User.dart';
import 'package:flutter_git/common/utile/Common_utils.dart';
import 'package:flutter_git/common/style/gsy_style.dart';
import 'package:flutter_git/page/welcome_page.dart';
import 'package:flutter_git/page/home_page.dart';
import 'package:flutter_git/page/login_page.dart';

import 'package:flutter_git/common/event/index.dart';
import 'package:flutter_git/common/event/htttp_error_event.dart';
import 'package:flutter_git/common/net/code.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_git/common/utile/navigator_utils.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_git/common/localization/gsy_localizations_delegate.dart';



void main() {

//  runApp(FlutterReduxApp()) ;

  runZoned((){
    runApp(FlutterReduxApp()) ;
    PaintingBinding.instance.imageCache.maximumSize = 100 ;
    Provider.debugCheckInvalidValueType = null ;
    
    }
    , onError: (Object obj, StackTrace stack) {

          print(obj) ;
          print(stack);
      }
  ) ;



}

class FlutterReduxApp extends StatelessWidget {
  // This widget is the root of your application.

final store = Store<GSYState>(
  appReducer,
  middleware: middleware,
  initialState: GSYState(
    userInfo: User.empty(),
    themeData: CommonUtils.getThemeData(GSYColors.primarySwatch),
    locale: Locale('zh','CH')
  )
);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: StoreBuilder<GSYState>(builder: (context, store) {
          return MaterialApp(

            localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GSYLocalizationsDelegate.delegate,
            ],
            locale: store.state.locale,
            supportedLocales: [store.state.locale],
            theme: store.state.themeData,

          routes: {
              WelcomePage.sName: (context) {
                store.state.platformLocale =
                    WidgetsBinding.instance.window.locale;
                return WelcomePage();
              },
            HomePage.sName: (context) {

                return  GSYLocalizations(
                  child: NavigatorUtils.pageContainer(HomePage()),
                ) ;
            },
            LoginPage.sName: (context) {

              return  GSYLocalizations(
                child: NavigatorUtils.pageContainer(LoginPage()),
              ) ;
            },
            },

          );
        }));
  }


}

class GSYLocalizations extends StatefulWidget {
  final Widget child;

  GSYLocalizations({Key key, this.child}) : super(key: key);

  @override
  State<GSYLocalizations> createState() {
    return new _GSYLocalizations();
  }
}

class _GSYLocalizations extends State<GSYLocalizations> {


  StreamSubscription stream;

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<GSYState>(builder: (context, store) {
      ///通过 StoreBuilder 和 Localizations 实现实时多语言切换
      return new Localizations.override(
        context: context,
        locale: store.state.locale,
        child: widget.child,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    ///Stream演示event bus
    stream = eventBus.on<HttpErrorEvent>().listen((event) {
      errorHandleFunction(event.code, event.message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream.cancel();
      stream = null;
    }
  }

  ///网络错误提醒
  errorHandleFunction(int code, message) {
    switch (code) {
      case Code.NETWORK_ERROR:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error);
        break;
      case 401:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_401);
        break;
      case 403:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_403);
        break;
      case 404:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_404);
        break;
      case Code.NETWORK_TIMEOUT:
      //超时
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_timeout);
        break;
      default:
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).network_error_unknown +
                " " +
                message);
        break;
    }
  }
}






