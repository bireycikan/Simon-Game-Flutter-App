import 'package:flutter/material.dart';
import 'components/simon.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(Simon());
}
