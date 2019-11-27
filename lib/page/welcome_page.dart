
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_git/common/redux/gsy_state.dart';
import 'package:redux/redux.dart';
import 'package:flutter_git/common/style/gsy_style.dart';

import 'package:flare_flutter/flare_actor.dart';

import 'package:flutter_git/common/dao/user_dao.dart';
import 'package:flutter_git/common/utile/navigator_utils.dart';

class WelcomePage extends  StatefulWidget {

  static final String sName = "/";

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  bool hadInit = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    ///防止多次进入

    if(hadInit) {
      return ;
    }
    hadInit = true ;

    Store<GSYState> store = StoreProvider.of(context) ;
    Future.delayed(Duration(seconds: 2, milliseconds: 500), (){

      UserDao.initUserInfo(store).then((res){

        if(res != null && res.result) {
          NavigatorUtils.goHome(context) ;

         } else {
          NavigatorUtils.goLogin(context ) ;
        }
        return true ;

      }) ;
    }) ;
  }

  @override
  Widget build(BuildContext context) {

    return  StoreBuilder<GSYState>(builder: (context,store) {

      double size = 200 ;
      return Container(

        color: Color(GSYColors.white),
        child: Stack(
          children: <Widget>[
            Center(
              child: Image(image: AssetImage("images/welcome.png")),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size,
                height: size,
                child: FlareActor("images/file/flare_flutter_logo_.flr",
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fill,
                  animation: "Placeholder",
                ),
              ) ,
            ),


          ],
        ),
      );

    } ) ;
  }
}