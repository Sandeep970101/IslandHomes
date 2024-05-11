import 'package:flutter/material.dart';

class SizeConfig {
  //-----get screen height
  static double h(BuildContext context) => MediaQuery.of(context).size.height;

  //-----get screen width
  static double w(BuildContext context) => MediaQuery.of(context).size.width;
}
