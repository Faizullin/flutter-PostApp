import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color green300 = fromHex('#68d391');
  static Color whiteA700 = fromHex('#ffffff');
  static Color lightBlueA200 = fromHex('#40bfff');
  static Color whiteA7006c = fromHex('#6cffffff');
  static Color black9006c = fromHex('#6c000000');
  static Color black900 = fromHex('#000000');
  static Color gray100 = fromHex('#f6f6f6');
  static Color gray500 = fromHex('#909090');
  static Color gray700 = fromHex('#555555');
  static Color teal600 = fromHex('#008374');
  static Color gray900 = fromHex('#222222');//defaylt7
  static Color gray5001 = fromHex('#f7fafc');
  static Color deepOrange400 = fromHex('#f96f59');

  static Color blueGray40001 = fromHex('#718096');
  static Color blueGray200 = fromHex('#a0aec0');
  static Color blueGray400 = fromHex('#718a96');
  static Color blueGray700 = fromHex('#4a5568');
  static Color gray50001 = fromHex('#90979d');
  static Color gray90002 = fromHex('#1a202c');
  // static Color gray100 = fromHex('#f2f2f2');{
  // --font-default: "Open Sans", system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", "Liberation Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
  // --font-primary: "Montserrat", sans-serif;
  // --font-secondary: "Poppins", sans-serif;
  // }


  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
