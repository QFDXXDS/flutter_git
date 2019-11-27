
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_git/common/redux/gsy_state.dart';
import 'package:flutter_git/common/local/local_storage.dart';
import 'dart:async';
import 'package:flutter_git/common/config/config.dart';
import 'package:flutter_git/common/style/gsy_style.dart';
import 'package:flutter_git/widget/gsy_input_widget.dart';
import 'package:flutter_git/widget/gsy_flex_button.dart';

import 'package:flutter_git/common/utile/Common_utils.dart';
import 'package:flutter_git/common/utile/navigator_utils.dart';

import 'package:flutter_git/common/dao/user_dao.dart';

class LoginPage extends StatefulWidget {
  static final String sName = "login";

      @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  var _userName = "";

  var _password = "";

  final TextEditingController userController = new TextEditingController();
  final TextEditingController pwController = new TextEditingController();

  _LoginPageState() : super();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initParams() ;

  }
  initParams() async {

    _userName = await LocalStorage.get(Config.USER_NAME_KEY);
    _password = await LocalStorage.get(Config.PW_KEY);
    userController.value = new TextEditingValue(text: _userName ?? "");
    pwController.value = new TextEditingValue(text: _password ?? "");

    var colorCode = Theme.of(context).primaryColor ;
    print("123") ;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StoreBuilder<GSYState>(builder: (context,store){

      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){

            FocusScope.of(context).requestFocus(FocusNode()) ;
        },
        child: Scaffold(

          body: Container(
            color: Theme.of(context).primaryColor,
            child: Center(
              child: SafeArea(
                ///同时弹出键盘不遮挡
              child: SingleChildScrollView(
                      child: Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        color: Color(GSYColors.cardWhite),
                        margin: const EdgeInsets.only(left: 30.0,right: 30.0),
                        child: Padding(

                            padding: EdgeInsets.only(left: 30,top: 40,right: 30,bottom: 0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image(
                                    image: AssetImage(GSYICons.DEFAULT_USER_ICON),
                                    width: 90.0,
                                    height: 90.0,
                                  ),
                                  Padding(padding: EdgeInsets.all(10)),
                                  GSYInputWidget(
                                    hintText: CommonUtils.getLocale(context).login_username_hint_text,
                                    iconData: GSYICons.LOGIN_USER,
                                    onChanged: (String value){
                                      _userName = value ;
                                    },
                                    controller: userController,
                                  ),
                                  Padding(padding: EdgeInsets.all(10)),
                                  GSYInputWidget(
                                    hintText: CommonUtils.getLocale(context).login_password_hint_text,
                                    iconData: GSYICons.LOGIN_PW,
                                    obscureText: true,
                                    onChanged: (String value){

                                      _password = value ;
                                    },
                                    controller: pwController,
                                  ),
                                  Padding(padding: EdgeInsets.all(30)),
                                  GSYFlexButton(
                                    text: CommonUtils.getLocale(context).login_text,
                                    color: Theme.of(context).primaryColor,
                                    textColor: Color(GSYColors.textWhite),
                                    onPress: (){
                                      if (_userName == null || _userName.length == 0) {
                                        return;
                                      }
                                      if (_password == null || _password.length == 0) {
                                        return;
                                      }
                                      CommonUtils.showLoadingDialog(context) ;
                                      UserDao.login(_userName.trim(), _password.trim(), store).
                                      then((res){
                                        
                                        Navigator.pop(context) ;
                                        if(res != null && res.result) {

                                          Future.delayed(const Duration(seconds: 1),(){
                                            NavigatorUtils.goHome(context);
                                            return true ;
                                          }) ;
                                        }
                                      }) ;
                                    },
                                  ),
                                  Padding(padding: EdgeInsets.all(15)),
                                  InkWell(
                                    onTap: (){

                                      CommonUtils.showLanguageDialog(context, store);
                                    },
                                    child: Text(
                                      CommonUtils.getLocale(context).switch_language,
                                      style: TextStyle(
                                        color: Color(GSYColors.subTextColor),
                                      ),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(15)),

                                ],
                        )
                        ),
                      ),
                    )
              ),
            ),
          ),
        ),
      ) ;
    });
  }
}


