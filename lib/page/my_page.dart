
import 'package:flutter/material.dart';
import 'package:flutter_git/widget/state/base_person_state.dart';
import 'package:flutter_git/common/style/gsy_style.dart';
import 'package:redux/redux.dart';
import 'package:flutter_git/common/redux/gsy_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_git/common/dao/user_dao.dart';
import 'package:flutter_git/common/dao/event_dao.dart';
import 'package:flutter_git/common/redux/user_redux.dart';

import 'package:flutter_git/widget/pull/nested/gsy_nested_pull_load_widget.dart';




class MyPage extends StatefulWidget {


  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends BasePersonState<MyPage> {


  String beStaredCount = '---';

  Color notifyColor = const Color(GSYColors.subTextColor);

  Store<GSYState> _getStore() {
    if (context == null) {
      return null;
    }
    return StoreProvider.of(context);
  }

  _getUserName() {

    var name = _getStore()?.state?.userInfo?.login ;
    return (name == null) ? null : name ;
  }

  ///更新通知图标颜色
  _refreshNotify() {

    UserDao.getNotifyDao(false, false, 0).then((res) {
      Color newColor;
      if (res != null && res.result && res.data.length > 0) {
        newColor = Color(GSYColors.actionBlue);
      } else {
        newColor = Color(GSYColors.subLightTextColor);
      }
      if (isShow) {
        setState(() {
          notifyColor = newColor;
        });
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    pullLoadWidgetControl.needHeader = true;
    super.initState();
  }

  _getDataLogic() async {
    if (_getUserName() == null) {
      return [];
    }
    if (getUserType() == "Organization") {
      return await UserDao.getMemberDao(_getUserName(), page);
    }
    return await EventDao.getEventDao(_getUserName(),
        page: page, needDb: page <= 1);
  }
  ///从全局状态中获取我的用户类型
  getUserType() {
    if (_getStore()?.state?.userInfo == null) {
      return null;
    }
    return _getStore()?.state?.userInfo?.type;
  }

  @override
  requestRefresh() async {
    if (_getUserName() != null) {
      /*UserDao.getUserInfo(null).then((res) {
        if (res != null && res.result) {
          _getStore()?.dispatch(UpdateUserAction(res.data));
          //todo getUserOrg(_getUserName());
        }
      });*/
      ///通过 redux 提交更新用户数据行为
      ///触发网络请求更新
      _getStore().dispatch(FetchUserAction());
      ///获取用户组织信息
      getUserOrg(_getUserName());
      ///获取用户仓库前100个star统计数据
      getHonor(_getUserName());
      _refreshNotify();
    }
    return await _getDataLogic();
  }


  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }
  @override
  bool get isRefreshFirst => false;

  @override
  bool get needHeader => false;

  @override
  void didChangeDependencies() {
    if (pullLoadWidgetControl.dataList.length == 0) {
      showRefreshLoading();
    }
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context) ;
    // TODO: implement build
    return StoreBuilder<GSYState>(
          builder: (context,store){
            return GSYNestedPullLoadWidget(
                pullLoadWidgetControl,
                (BuildContext context, int index){

                  return renderItem(
                      index,
                      store.state.userInfo,
                      beStaredCount,
                      notifyColor,
                      (){
                        _refreshNotify() ;
                      }, orgList) ;

                },
                handleRefresh,
                onLoadMore,
                refreshKey: refreshIKey,
                headerSliverBuilder: (context,_){

                  return sliverBuilder(
                      context,
                      _,
                      store.state.userInfo,
                      notifyColor,
                      beStaredCount,
                      (){
                        _refreshNotify() ;
                      }
                      ) ;
                },
            ) ;
          }
          );
  }
}