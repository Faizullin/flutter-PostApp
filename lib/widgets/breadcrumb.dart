import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';

class Breadcrumb extends StatelessWidget {
  final List<Map<String,dynamic>> links;
  final List<Widget> linksWidgets = [];

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
        style: AppStyle.txtInterBold14.copyWith(
          color: ColorConstant.deepOrange400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    linksWidgets.add(InkWell(
      onTap: (){
        Navigator.pushNamed(context,AppRoutes.aboutUs);
      },
      child: Text(
        'Home',
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: AppStyle.txtInterBold14Gray900.copyWith(
          color: ColorConstant.teal600,
        ),
      ),
    ),);
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
      padding: getPadding(
        left: 20,
        right: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: linksWidgets,
      ),
    );
  }
}
