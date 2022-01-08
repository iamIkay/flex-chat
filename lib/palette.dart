import 'package:flutter/material.dart';

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
var textColor = '#242424'.toColor();
var themeColor = '#42AFFE'.toColor();//"#1B2D45".toColor(); //
class Palette {
  static Color primaryColor =  themeColor; //Color(0xFF08C187);
  static Color primaryTextColor =  textColor;
}