import 'package:flutter/material.dart';

class SimonContainer {
  SimonContainer({@required this.colour, @required this.onPressed});
  final Color colour;
  final Function onPressed;

  final _radius = BorderRadius.all(Radius.circular(30.0));

  Container getDecoration() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: _radius,
        color: colour,
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: _radius),
        child: null,
        onPressed: onPressed,
      ),
      width: 150.0,
      height: 150.0,
    );
  }
}
