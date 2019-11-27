import 'package:flutter/material.dart';


class GSYInputWidget extends StatefulWidget {

  final bool obscureText;

  final String hintText;

  final IconData iconData;

  final ValueChanged<String> onChanged;

  final TextStyle textStyle;

  final TextEditingController controller;

  GSYInputWidget({Key key, this.hintText, this.iconData, this.onChanged, this.textStyle, this.controller, this.obscureText = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GSYInputWidgetState();
  }
}

class _GSYInputWidgetState extends State<GSYInputWidget> {


  _GSYInputWidgetState() : super();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        icon:  Icon(widget.iconData),
      ),

    );
  }
}