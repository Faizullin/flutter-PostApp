import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';

class Breadcrumb extends StatelessWidget {
  final List<Map<String,dynamic>> links;
  final List<Widget> linksWidgets = [
    Text(
      "Home",
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
      style: AppStyle.txtInterBold14,
    ),
  ];

  Breadcrumb({super.key,required this.links});

  splitter(){
    return Padding(
      padding: getPadding(
        left: 16,
        right: 16,
      ),
      child: Text(
        "/",
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: AppStyle.txtInterBold14Deeporange400,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    for(var link in links){
      linksWidgets.add(splitter());
      linksWidgets.add(
        (link.containsKey('href')) ?

        InkWell(
          onTap: (){
            Navigator.pushNamed(context,link['href']);
          },
          child: Text(
            link['label'],
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppStyle.txtInterBold14Gray900,
          ),
        ) : Text(
          link['label'],
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: AppStyle.txtInterBold14Gray900,
        ),
      );
    }


    return Container(
      height: getVerticalSize(56),
      decoration: AppDecoration.fillGray100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: linksWidgets,
      ),
    );
  }
}
