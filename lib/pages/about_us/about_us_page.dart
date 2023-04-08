import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/widgets/app_bar/appbar_title.dart';
import 'package:post_app/widgets/app_bar/custom_app_bar.dart';
import 'package:post_app/widgets/custom_image_view.dart';
import 'package:post_app/widgets/sidebar_drawer.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key,});
  @override
  State<AboutUsPage> createState() => _AboutUsPage();
}

class _AboutUsPage extends State<AboutUsPage> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstant.whiteA700,
        appBar: CustomAppBar(
            height: getVerticalSize(56.00),
            leadingWidth: 42,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
            ),
            title: AppbarTitle(text: "Home", margin: getMargin(left: 22)),
        ),
        drawer: const SidebarDrawer(
          currentIndex: AppRoutes.aboutUs,
        ),
        body: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: getPadding(
                      left: 9,
                      top: 20,
                      right: 9,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "About Us",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtInterRegular30,
                        ),
                        Padding(
                          padding: getPadding(
                            top: 13,
                          ),
                          child: SizedBox(
                            width: getHorizontalSize(
                              50,
                            ),
                            child: Divider(
                              color: ColorConstant.teal600,
                            ),
                          ),
                        ),
                        Container(
                          width: getHorizontalSize(
                            317,
                          ),
                          margin: getMargin(
                            left: 11,
                            top: 18,
                            right: 12,
                          ),
                          child: Text(
                            "Aperiam dolorum et et wuia molestias qui eveniet numquam nihil porro incidunt dolores placeat sunt id nobis omnis tiledo stran delop",
                            maxLines: null,
                            textAlign: TextAlign.center,
                            style: AppStyle.txtInterMedium16.copyWith(
                              color: ColorConstant.gray500,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: getHorizontalSize(
                              278,
                            ),
                            margin: getMargin(
                              left: 3,
                              top: 38,
                              right: 60,
                            ),
                            child: Text(
                              "Voluptatem dignissimos provident quasi corporis",
                              maxLines: null,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtInterMedium24,
                            ),
                          ),
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgAboutUsLogo,
                          height: getVerticalSize(
                            252,
                          ),
                          width: getHorizontalSize(
                            338,
                          ),
                          radius: BorderRadius.circular(
                            getHorizontalSize(
                              15,
                            ),
                          ),
                          margin: getMargin(
                            top: 15,
                          ),
                        ),
                        Container(
                          width: getHorizontalSize(
                            341,
                          ),
                          margin: getMargin(
                            top: 20,
                          ),
                          child: Text(
                            "Ut fugiat ut sunt quia veniam. Voluptate perferendis perspiciatis quod nisi et. Placeat debitis quia recusandae odit et consequatur voluptatem. Dignissimos pariatur consectetur fugiat voluptas ea.\nTemporibus nihil enim deserunt sed ea. Provident sit expedita aut cupiditate nihil vitae quo officia vel. Blanditiis eligendi possimus et in cum. Quidem eos ut sint rem veniam qui. Ut ut repellendus nobis tempore doloribus debitis explicabo similique sit. Accusantium sed ut omnis beatae neque deleniti repellendus.",
                            maxLines: null,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtInterMedium16Gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}