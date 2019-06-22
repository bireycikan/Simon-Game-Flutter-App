import 'package:flutter/material.dart';

class Button {
  Button({@required this.buttonLabel, @required this.onPressed});
  final String buttonLabel;
  final Function onPressed;

  Widget getButton() {
    return Container(
      child: RaisedButton(
        splashColor: Colors.black54,
        child: Text(buttonLabel),
        onPressed: onPressed,
        elevation: 2.0,
      ),
      width: 150.0,
      height: 50.0,
    );
  }
}
