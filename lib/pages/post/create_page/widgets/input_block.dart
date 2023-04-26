import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';

class ErrorText extends StatelessWidget {
  final String text;
  const ErrorText(
      this.text,
      { super.key, }
      );
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.red,
        fontSize: getFontSize(12),
      ),
    );
  }
}
class InputBlock extends StatelessWidget {
  final Widget? child;
  final String? labelText;
  final List<Widget>? children;
  final String? error;
  const InputBlock({
    super.key,
    this.child,
    this.labelText,
    this.error,
    this.children,
  });
  @override
  Widget build(BuildContext context) {
    if(child != null && error != null) {
      var childrenWidgets = [
        if(labelText != null)
          Text(labelText!),
        child!
      ];
      childrenWidgets.addAll([
        SizedBox(height: getVerticalSize(3),),
        if(error != null)
          ErrorText(error!),
      ]);
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: childrenWidgets,
        ),
      );
    } else if (children != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children!,
        ),
      );
    }
    throw Exception("No child or children");
  }
}
