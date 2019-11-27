
import 'package:flutter/material.dart';
import 'package:flutter_git/widget/gsy_title_bar.dart';
import 'package:flutter_git/widget/gsy_common_option_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_git/common/style/gsy_style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_git/common/utile/Common_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class PhotoViewPage extends StatelessWidget {
  final String url;

  PhotoViewPage(this.url);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    OptionControl optionControl = OptionControl() ;
    return Scaffold(

      floatingActionButton: FloatingActionButton(
          onPressed: (){
            CommonUtils.saveImage(url).then((res) {
                if(res != null) {
                  Fluttertoast.showToast(msg: res) ;
                  if(Platform.isAndroid) {
                    const updateAlbum = MethodChannel("com.shuyu.gsygithub.gsygithubflutter/UpdateAlbumPlugin");
                    updateAlbum.invokeMethod('updateAlbum',{'path': res, 'name': CommonUtils.splitFileNameByPath(res)}) ;
                  }
                }

            }
            ) ;
          },
          child: Icon(Icons.file_download),
      ),
      appBar: AppBar(
        
        title: GSYTitleBar(
            '',
          rightWidget: GSYCommonOptionWidget(optionControl),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: PhotoView(
            imageProvider: NetworkImage(
                url ?? GSYICons.DEFAULT_REMOTE_PIC),
            loadingChild: Container(
              child: Stack(
                children: <Widget>[
                  Center(child: Image.asset(GSYICons.DEFAULT_IMAGE,height: 180,width: 180,)),
                  Center(child: SpinKitFoldingCube(color: Colors.white30,size: 60.0,))
                ],
              ),
            ),
        ),
      ),
    );
  }

}