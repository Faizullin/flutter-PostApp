import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  CustomAppBar(
      {super.key,
        required this.height,
        this.leadingWidth,
        this.leading,
        this.title,
        this.centerTitle,
        this.actions,
        this.backgroundColor,});

  double height;

  double? leadingWidth;

  Widget? leading;

  Widget? title;

  bool? centerTitle;

  List<Widget>? actions;

  Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: height,
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? ColorConstant.teal600,
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
    size.width,
    height,
  );
}
