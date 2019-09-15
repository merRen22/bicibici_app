import 'package:flutter/material.dart';

class TextStyles {


  static TextStyle mediumBlackFatText() {
    return TextStyle(
        fontFamily: "Roboto",
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: Colors.black87);
  }

  static TextStyle mediumPurpleFatText() {
    return TextStyle(
        fontFamily: "Roboto",
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: Colors.purple);
  }


  static TextStyle extraSmallPurpleFatText() {
    return TextStyle(
        fontFamily: "Roboto",
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.purple);
  }


  static TextStyle mediumWhiteFatText() {
    return TextStyle(
        fontFamily: "Roboto",
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: Colors.white);
  }

  static TextStyle smallWhiteFatText() {
    return TextStyle(
        fontFamily: "Roboto",
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.white);
  }
}
