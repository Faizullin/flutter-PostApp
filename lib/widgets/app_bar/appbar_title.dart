import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppbarTitle extends StatelessWidget {
  AppbarTitle({super.key,required this.text, this.margin, this.onTap});

  String text;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          // style: AppStyle.txtPoppinsBold16.copyWith(
          //   letterSpacing: getHorizontalSize(
          //     0.50,
          //   ),
          //   //color: ColorConstant.indigo900,
          // ),
        ),
      ),
    );
  }
}
