import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';

class CustomSearchView extends StatelessWidget {
  const CustomSearchView(
      {super.key,
      this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.width,
      this.margin,
      this.controller,
      this.focusNode,
      this.hintText,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints});

  final SearchViewShape? shape;

  final SearchViewPadding? padding;

  final SearchViewVariant? variant;

  final SearchViewFontStyle? fontStyle;

  final Alignment? alignment;

  final double? width;

  final EdgeInsetsGeometry? margin;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final String? hintText;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildSearchViewWidget(),
          )
        : _buildSearchViewWidget();
  }

  _buildSearchViewWidget() {
    return Container(
      width: getHorizontalSize(width ?? 0),
      margin: margin,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        style: _setFontStyle(),
        decoration: _buildDecoration(),
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      hintText: hintText ?? "",
      hintStyle: _setFontStyle(),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      filled: _setFilled(),
      isDense: true,
      contentPadding: _setPadding(),
    );
  }

  _setFontStyle() {
    switch (fontStyle) {
      case SearchViewFontStyle.poppinsBold12:
        return TextStyle(
          // color: ColorConstant.indigo90087,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        );
      default:
        return TextStyle(
          // color: ColorConstant.blueGray300,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        );
    }
  }

  _setOutlineBorderRadius() {
    switch (shape) {
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            5.00,
          ),
        );
    }
  }

  _setBorderStyle() {
    switch (variant) {
      case SearchViewVariant.outlineLightblueA200:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: const BorderSide(
            // color: ColorConstant.lightBlueA200,
            width: 1,
          ),
        );
      case SearchViewVariant.none:
        return InputBorder.none;
      default:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: const BorderSide(
            //color: ColorConstant.blue50,
            width: 1,
          ),
        );
    }
  }

  _setFilled() {
    switch (variant) {
      case SearchViewVariant.outlineblue50:
        return false;
      case SearchViewVariant.none:
        return false;
      default:
        return false;
    }
  }

  _setPadding() {
    switch (padding) {
      case SearchViewPadding.paddingt12:
        return getPadding(
          top: 12,
          bottom: 12,
        );
      default:
        return getPadding(
          top: 13,
          right: 13,
          bottom: 13,
        );
    }
  }
}

enum SearchViewShape {
  roundedborder5,
}

enum SearchViewPadding {
  paddingt13,
  paddingt12,
}

enum SearchViewVariant {
  none,
  outlineblue50,
  outlineLightblueA200,
}

enum SearchViewFontStyle {
  poppinsRegular12,
  poppinsBold12,
}
