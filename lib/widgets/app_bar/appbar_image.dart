import 'package:flutter/material.dart';
import 'package:post_app/widgets/custom_image_view.dart';

// ignore: must_be_immutable
class AppbarImage extends StatelessWidget {
  AppbarImage(
      {super.key,
      required this.height,
      required this.width,
      this.imagePath,
      this.icon,
      this.svgPath,
      this.margin,
      this.onTap});

  double height;

  double width;

  String? imagePath;

  String? svgPath;

  Icon? icon;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: (icon != null)
            ? icon
            : CustomImageView(
                svgPath: svgPath,
                imagePath: imagePath,
                height: height,
                width: width,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
