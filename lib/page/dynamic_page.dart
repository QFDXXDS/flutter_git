
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';


import 'package:flutter_git/common/redux/gsy_state.dart';
import 'package:flutter_git/bloc/dynamic_bloc.dart';
import 'package:flutter_git/common/model/Event.dart';
import 'package:flutter_git/widget/event_item.dart';
import 'package:flutter_git/common/utile/event_utils.dart';
import 'package:flutter_git/common/dao/repos_dao.dart';
import 'package:flutter_git/widget/pull/gys_pull_new_load_widget.dart';



class DynamicPage extends StatefulWidget {

  @override
  _DynamicPageState createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage> with AutomaticKeepAliveClientMixin<DynamicPage>, WidgetsBindingObserver {

  final DynamicBloc dynamicBloc = new DynamicBloc();

  ///控制列表滚动和监听
  final ScrollController scrollController = new ScrollController();

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  /// 模拟IOS下拉显示刷新
  showRefreshLoading() {
    ///直接触发下拉
    new Future.delayed(const Duration(milliseconds: 500), () {
      scrollController.animateTo(-141,
          duration: Duration(milliseconds: 600), curve: Curves.linear);
      return true;
    });
  }

  ///下拉刷新数据
  Future<void> requestRefresh() async {
    //await Future.delayed(Duration(seconds: 1));
    return await dynamicBloc.requestRefresh(_getStore().state.userInfo?.login);
  }

  ///上拉更多请求数据
  Future<void> requestLoadMore() async {
    return await dynamicBloc.requestLoadMore(_getStore().state.userInfo?.login);
  }

  _renderEventItem(Event e) {

    EventViewModel eventViewModel = EventViewModel.fromEventMap(e);
    return new EventItem(
      eventViewModel,
      onPressed: () {
        EventUtils.ActionUtils(context, e, "");
      },
    );
  }

  Store<GSYState> _getStore() {
    return StoreProvider.of(context);
  }
    @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addObserver(this) ;
    ///获取网络端新版信息
    ReposDao.getNewsVersion(context, false);
  }

  @override
  void didChangeDependencies() {

    ///请求更新
    if (dynamicBloc.getDataLength() == 0) {
      dynamicBloc.changeNeedHeaderStatus(false);
      ///先读数据库
      dynamicBloc.requestRefresh(_getStore().state.userInfo?.login,
          doNextFlag: false).then((_) {
        showRefreshLoading();
      });
    }
    super.didChangeDependencies();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if(state == AppLifecycleState.resumed) {

      if (dynamicBloc.getDataLength() != 0) {
        showRefreshLoading();
      }
    }

  }
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    WidgetsBinding.instance.removeObserver(this) ;
    dynamicBloc.dispose();
  }



  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

  return GSYPullLoadWidget(
      dynamicBloc.pullLoadWidgetControl,
      (BuildContext context, int index){

        _renderEventItem(dynamicBloc.dataList[index]) ;
      },
      requestRefresh,
      requestLoadMore,
      refreshKey: refreshIndicatorKey,
      scrollController: scrollController,
      userIos: true,
  ) ;
  }
}