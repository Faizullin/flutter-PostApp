import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
        this.fontStyle,
        this.alignment,
        this.margin,
        this.onTap,
        this.width,
        this.height,
        this.text,
        this.prefixWidget,
        this.suffixWidget});


  final TextStyle? fontStyle;

  final Alignment? alignment;

  final EdgeInsetsGeometry? margin;

  final VoidCallback? onTap;

  final double? width;

  final double? height;

  final String? text;

  final Widget? prefixWidget;

  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment!,
      child: _buildButtonWidget(),
    )
        : _buildButtonWidget();
  }

  _buildButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: TextButton(
        onPressed: onTap,
        style: _buildTextButtonStyle(),
        child: _buildButtonWithOrWithoutIcon(),
      ),
    );
  }

  _buildButtonWithOrWithoutIcon() {
    if (prefixWidget != null || suffixWidget != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          prefixWidget ?? const SizedBox(),
          Text(
            text ?? "",
            textAlign: TextAlign.center,
            style: _setFontStyle(),
          ),
          suffixWidget ?? const SizedBox(),
        ],
      );
    } else {
      return Text(
        text ?? "",
        textAlign: TextAlign.center,
        style: _setFontStyle(),
      );
    }
  }

  _buildTextButtonStyle() {
    return TextButton.styleFrom(
      fixedSize: Size(
        width ?? double.maxFinite,
        height ?? getVerticalSize(40),
      ),
      padding: _setPadding(),
      backgroundColor: _setColor(),
      shape: RoundedRectangleBorder(
        borderRadius: _setBorderRadius(),
      ),
    );
  }

  _setPadding() {
    return getPadding(
      all: 14,
    );
  }

  _setColor() {
    return Colors.red[400];
  }

  _setBorderRadius() {
    return BorderRadius.circular(
      getHorizontalSize(
        25.00,
      ),
    );
  }

  _setFontStyle() {
    switch (fontStyle) {
      default:
        return TextStyle(
          color: ColorConstant.gray100,
          fontSize: getFontSize(
            15,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.27,
          ),
        );
    }
  }
}