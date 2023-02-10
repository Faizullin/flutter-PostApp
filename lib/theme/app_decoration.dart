import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';

class AppDecoration {
  static BoxDecoration get fillTeal600 => BoxDecoration(
        color: ColorConstant.teal600,
      );
  static BoxDecoration get fillGray900 => BoxDecoration(
        color: ColorConstant.gray900,
      );
  static BoxDecoration get fillDeepOrange400 => BoxDecoration(
    color: ColorConstant.deepOrange400,
  );
  static BoxDecoration get fillWhiteA700 => BoxDecoration(
        color: ColorConstant.whiteA700,
      );

  static BoxDecoration get fillGray100 => BoxDecoration(
    color: ColorConstant.gray100,
  );
}

class BorderRadiusStyle {
  static BorderRadius circleBorder25 = BorderRadius.circular(
    getHorizontalSize(
      25.00,
    ),
  );
}
