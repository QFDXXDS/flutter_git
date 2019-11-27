
import 'package:flutter/material.dart';
import 'package:flutter_git/page/home_page.dart';

import 'package:flutter_git/page/login_page.dart';
import 'package:flutter_git/page/search_page.dart';
import 'package:flutter_git/common/router/anima_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_git/page/person_page.dart';
import 'package:flutter_git/page/photoview_page.dart';
import 'package:flutter_git/page/common_list_page.dart';
import 'package:flutter_git/page/release_page.dart';
import 'package:flutter_git/page/repository_detail_page.dart';
import 'package:flutter_git/page/push_detail_page.dart';
import 'package:flutter_git/page/user_profile_page.dart';
import 'package:flutter_git/page/code_detail_page_web.dart';
import 'package:flutter_git/page/gsy_webview.dart';
import 'package:flutter_git/page/honor_list_page.dart';
import 'package:flutter_git/page/issue_detail_page.dart';
import 'package:flutter_git/page/notify_page.dart';




class NavigatorUtils {
  ///替换
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  ///切换无参数页面
  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  ///主页
  static goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomePage.sName);
  }

  ///登录页
  static goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, LoginPage.sName);
  }

  ///个人中心
  static goPerson(BuildContext context, String userName) {
    NavigatorRouter(context, new PersonPage(userName));
  }

//  ///仓库详情
  static Future goReposDetail(
      BuildContext context, String userName, String reposName) {
    ///利用 SizeRoute 动画大小打开
    return Navigator.push(
        context,
        new SizeRoute(
            widget: pageContainer(RepositoryDetailPage(userName, reposName))));
  }

  ///荣耀列表
  static Future goHonorListPage(BuildContext context, List list) {
    return Navigator.push(
        context, new SizeRoute(widget: pageContainer(HonorListPage(list))));
  }

  ///仓库版本列表
  static Future goReleasePage(BuildContext context, String userName,
      String reposName, String releaseUrl, String tagUrl) {
    return NavigatorRouter(
        context,
        new ReleasePage(
          userName,
          reposName,
          releaseUrl,
          tagUrl,
        ));
  }

  ///issue详情
  static Future goIssueDetail(
      BuildContext context, String userName, String reposName, String num,
      {bool needRightLocalIcon = false}) {
    return NavigatorRouter(
        context,
        new IssueDetailPage(
          userName,
          reposName,
          num,
          needHomeIcon: needRightLocalIcon,
        )
    );
  }

  ///通用列表
  static gotoCommonList(
      BuildContext context, String title, String showType, String dataType,
      {String userName, String reposName}) {

    NavigatorRouter(
        context,
        new CommonListPage(
          title,
          showType,
          dataType,
          userName: userName,
          reposName: reposName,
        )
    );
  }

  //仓库详情通知
  static Future goNotifyPage(BuildContext context) {
    return NavigatorRouter(context, new NotifyPage());
  }

  //搜索
  static Future goSearchPage(BuildContext context) {

    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {

        return Builder(builder: (BuildContext context) {
          return pageContainer(SearchPage());
        });
      },
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Color(0x01000000),
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
    );
  }

  ///提交详情
  static Future goPushDetailPage(BuildContext context, String userName,
      String reposName, String sha, bool needHomeIcon) {
    return NavigatorRouter(
        context,
        new PushDetailPage(
          sha,
          userName,
          reposName,
          needHomeIcon: needHomeIcon,
        ));
  }

  ///全屏Web页面
  static Future goGSYWebView(BuildContext context, String url, String title) {
    return NavigatorRouter(context, new GSYWebView(url, title));
  }

  ///文件代码详情Web
  static gotoCodeDetailPageWeb(BuildContext context,
      {String title,
        String userName,
        String reposName,
        String path,
        String data,
        String branch,
        String htmlUrl}) {
    NavigatorRouter(
        context,
        new CodeDetailPageWeb(
          title: title,
          userName: userName,
          reposName: reposName,
          path: path,
          data: data,
          branch: branch,
          htmlUrl: htmlUrl,
        ));
  }

  ///根据平台跳转文件代码详情Web
  static gotoCodeDetailPlatform(BuildContext context,
      {String title,
        String userName,
        String reposName,
        String path,
        String data,
        String branch,
        String htmlUrl}) {
    NavigatorUtils.gotoCodeDetailPageWeb(
      context,
      title: title,
      reposName: reposName,
      userName: userName,
      data: data,
      path: path,
      branch: branch,
    );
  }

  ///图片预览
  static gotoPhotoViewPage(BuildContext context, String url) {
    NavigatorRouter(context, new PhotoViewPage(url));
  }

  ///用户配置
  static gotoUserProfileInfo(BuildContext context) {
    NavigatorRouter(context, new UserProfileInfo());
  }

  //公共打开方式
  static NavigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(context,
        new CupertinoPageRoute(builder: (context) => pageContainer(widget)));
  }

  ///Page页面的容器，做一次通用自定义
  static Widget pageContainer(widget) {
    return MediaQuery(

      ///不受系统字体缩放影响
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .copyWith(textScaleFactor: 1),
        child: widget);
  }

  ///弹出 dialog
  static Future<T> showGSYDialog<T>({
    @required BuildContext context,
    bool barrierDismissible = true,
    WidgetBuilder builder,
  }) {

//    showDialog是一个控件
    return showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return MediaQuery(

            ///不受系统字体缩放影响
              data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                  .copyWith(textScaleFactor: 1),
              child: new SafeArea(child: builder(context)));
        });
  }
}