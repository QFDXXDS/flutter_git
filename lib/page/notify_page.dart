

import 'package:flutter/material.dart';
import 'package:flutter_git/common/utile/Common_utils.dart';
import 'package:flutter_git/common/utile/navigator_utils.dart';
import 'package:flutter_git/widget/state/gsy_list_state.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_git/common/model/Notification.dart' as Model;
import 'package:flutter_git/common/dao/user_dao.dart';
import 'package:flutter_git/widget/event_item.dart';
import 'package:flutter_git/common/style/gsy_style.dart';
import 'package:flutter_git/widget/gsy_title_bar.dart';
import 'package:flutter_git/widget/gsy_select_item_widget.dart';
import 'package:flutter_git/widget/pull/gsy_pull_load_widget.dart';


class NotifyPage extends StatefulWidget {
  NotifyPage();

  @override
  _NotifyPageState createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage>
    with AutomaticKeepAliveClientMixin<NotifyPage>, GSYListState<NotifyPage> {
  final SlidableController slidableController = new SlidableController();

  int selectIndex = 0;

  _NotifyPageState();

  ///绘制 Item
  _renderItem(index) {
    Model.Notification notification = pullLoadWidgetControl.dataList[index];
    if (selectIndex != 0) {
      return _renderEventItem(notification);
    }

    ///只有未读消息支持 Slidable 滑动效果
    return new Slidable(
      key: ValueKey<String>(index.toString() + "_" + selectIndex.toString()),
      controller: slidableController,
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      child: _renderEventItem(notification),
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {},
      ),
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: CommonUtils.getLocale(context).notify_readed,
          color: Colors.redAccent,
          icon: Icons.delete,
          onTap: () {
            UserDao.setNotificationAsReadDao(notification.id.toString())
                .then((res) {
              showRefreshLoading();
            });
          },
        ),
      ],
    );
  }

  ///绘制实际的内容数据item
  _renderEventItem(Model.Notification notification) {
    EventViewModel eventViewModel =
    EventViewModel.fromNotify(context, notification);
    return new EventItem(eventViewModel, onPressed: () {
      if (notification.unread) {
        UserDao.setNotificationAsReadDao(notification.id.toString());
      }
      if (notification.subject.type == 'Issue') {
        String url = notification.subject.url;
        List<String> tmp = url.split("/");
        String number = tmp[tmp.length - 1];
        String userName = notification.repository.owner.login;
        String reposName = notification.repository.name;
        NavigatorUtils.goIssueDetail(context, userName, reposName, number,
            needRightLocalIcon: true)
            .then((res) {
          showRefreshLoading();
        });
      }
    }, needImage: false);
  }

  ///切换tab
  _resolveSelectIndex() {
    clearData();
    showRefreshLoading();
  }

  _getDataLogic() async {
    return await UserDao.getNotifyDao(selectIndex == 2, selectIndex == 1, page);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get needHeader => false;

  @override
  bool get isRefreshFirst => true;

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  requestRefresh() async {
    return await _getDataLogic();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return new Scaffold(
      backgroundColor: Color(GSYColors.mainBackgroundColor),
      appBar: new AppBar(
        title: GSYTitleBar(
          CommonUtils.getLocale(context).notify_title,
          iconData: GSYICons.NOTIFY_ALL_READ,
          needRightLocalIcon: true,
          onPressed: () {
            CommonUtils.showLoadingDialog(context);
            UserDao.setAllNotificationAsReadDao().then((res) {
              Navigator.pop(context);
              _resolveSelectIndex();
            });
          },
        ),
        bottom: new GSYSelectItemWidget(
          [
            CommonUtils.getLocale(context).notify_tab_unread,
            CommonUtils.getLocale(context).notify_tab_part,
            CommonUtils.getLocale(context).notify_tab_all,
          ],
              (selectIndex) {
            this.selectIndex = selectIndex;
            _resolveSelectIndex();
          },
          height: 30.0,
          margin: const EdgeInsets.all(0.0),
          elevation: 0.0,
        ),
        elevation: 4.0,
      ),
      body: GSYPullLoadWidget(
           pullLoadWidgetControl ,
            (BuildContext context, int index) => _renderItem(index),
        handleRefresh,
        onLoadMore,
        refreshKey: refreshIndicatorKey,
      ),
    );
  }
}
