import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';


class QuillStyle {
  static Map<String,Style> styles = {
  // tables will have the below background color
    "table": Style(
      backgroundColor: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
    ),
    // some other granular customizations are also possible
    "tr": Style(
      border: const Border(bottom: BorderSide(color: Colors.grey)),
    ),
    "th": Style(
    padding: const EdgeInsets.all(6),
    backgroundColor: Colors.grey,
    ),
    "td": Style(
    padding: const EdgeInsets.all(6),
    alignment: Alignment.topLeft,
    ),
    // text that renders h1 elements will be red
    "h1": Style(color: Colors.red),
  };

  static getStyles(){
    return styles;
  }
}
