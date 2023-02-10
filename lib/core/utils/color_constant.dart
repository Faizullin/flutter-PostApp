import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {

  static Color whiteA700 = fromHex('#ffffff');
  static Color gray100 = fromHex('#f6f6f6');
  static Color gray700 = fromHex('#555555');
  static Color teal600 = fromHex('#008374');
  static Color gray900 = fromHex('#222222');//defaylt
  static Color deepOrange400 = fromHex('#f96f59');


  // static Color gray100 = fromHex('#f2f2f2');{
  // --font-default: "Open Sans", system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", "Liberation Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
  // --font-primary: "Montserrat", sans-serif;
  // --font-secondary: "Poppins", sans-serif;
  // }

  static Color orangeSecondary = fromHex('#f85a40');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
