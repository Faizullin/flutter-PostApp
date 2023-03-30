import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/widgets/custom_search_view.dart';

// ignore: must_be_immutable
class AppbarSearchview extends StatelessWidget {
  AppbarSearchview({super.key,this.hintText, this.controller, this.margin});

  String? hintText;

  TextEditingController? controller;

  EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: CustomSearchView(
        width: 263,
        focusNode: FocusNode(),
        controller: controller,
        hintText: hintText,
        prefix: Container(
          margin: getMargin(
            left: 16,
            top: 15,
            right: 8,
            bottom: 15,
          ),
          child: const Text("Search"),
          // child: CustomImageView(
          //   svgPath: ImageConstant.imgSearchLightBlueA200,
          // ),
        ),
        prefixConstraints: BoxConstraints(
          maxHeight: getVerticalSize(
            46.00,
          ),
        ),
      ),
    );
  }
}
