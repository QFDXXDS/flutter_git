
import 'package:flutter/material.dart';
import 'package:flutter_git/widget/state/base_person_state.dart';

class PersonPage extends StatefulWidget {
  static final String sName = "person";

  final String userName;

  PersonPage(this.userName, {Key key}) : super(key: key);

  @override
  _PersonState createState() => _PersonState(userName);
}

class _PersonState extends BasePersonState<PersonPage> {

  final String userName;

  _PersonState(this.userName);


}