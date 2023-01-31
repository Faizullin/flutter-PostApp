import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';

class AppStyle {
  static TextStyle txtInterMedium13 = TextStyle(
    color: ColorConstant.gray500,
    fontSize: getFontSize(
      13,
    ),
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
  );

  static TextStyle txtInterBold22 = TextStyle(
    color: ColorConstant.whiteA700,
    fontSize: getFontSize(
      22,
    ),
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
  );

  static TextStyle txtInterMedium48 = TextStyle(
    color: ColorConstant.whiteA700,
    fontSize: getFontSize(
      48,
    ),
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,//.w528
  );

  static TextStyle txtInterMedium15 = TextStyle(
    color: ColorConstant.lightBlue700,
    fontSize: getFontSize(
      15,
    ),
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
  );
}
