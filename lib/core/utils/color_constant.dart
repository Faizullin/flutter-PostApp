import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color gray500 = fromHex('#a8a8a8');

  static Color lightBlue70001 = fromHex('#008bd7');

  static Color lightGreen500 = fromHex('#92de40');

  static Color lightBlue700 = fromHex('#0086c8');

  static Color whiteA700 = fromHex('#ffffff');

  static Color gray100 = fromHex('#f2f2f2');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
