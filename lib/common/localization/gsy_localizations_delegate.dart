
import 'package:flutter/material.dart';

import 'package:flutter_git/common/localization/default_localization.dart';
import 'package:flutter/foundation.dart';

class GSYLocalizationsDelegate extends LocalizationsDelegate<GSYLocalizations> {

  GSYLocalizationsDelegate();


  @override
  bool isSupported(Locale locale) {
    // TODO: implement isSupported

    var su = ['en','zh'].contains(locale.languageCode);
    return su ;
  }

  @override
  Future<GSYLocalizations> load(Locale locale) {
    // TODO: implement load
    return SynchronousFuture<GSYLocalizations>(GSYLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<GSYLocalizations> old) {
    // TODO: implement shouldReload
    return false;
  }
  ///全局静态的代理
  static GSYLocalizationsDelegate delegate = new GSYLocalizationsDelegate();

}