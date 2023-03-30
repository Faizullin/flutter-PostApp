import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/services/auth_provider.dart';
import 'package:post_app/widgets/app_bar/appbar_title.dart';
import 'package:post_app/widgets/app_bar/custom_app_bar.dart';
import 'package:post_app/widgets/sidebar_drawer.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key,});
  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String,String> profileData = {
    'Name': 'Michael',
    'Email': 'michael@example.com',
    'Address': 'Astana Street #37',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    if (!auth.isAuthenticated) {
      Navigator.pushNamed(context, AppRoutes.authLogin);
      Future.delayed(const Duration(seconds: 1));
    }

    profileData['Name'] = auth.user?.name ?? '';
    profileData['Email'] = auth.user?.email ?? '';

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          height: getVerticalSize(56.00),
          leadingWidth: 42,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          title: AppbarTitle(text: "ProfilePage", margin: getMargin(left: 22)),
          backgroundColor: ColorConstant.lightBlueA200,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: (){
                scaffoldKey.currentState!.openEndDrawer();
              },
              //margin: getMargin(left: 20, top: 18, bottom: 17)
            ),
          ],
        ),
        backgroundColor: ColorConstant.gray5001,
        resizeToAvoidBottomInset: false,
        drawer: SidebarDrawer(
          backgroundColor: ColorConstant.lightBlueA200,
        ),
        // endDrawer: FiltersSidebarDrawer(
        //   futureFilters: futureFilters,
        //   selectedFilters: selectFilters,
        //   service: postService,
        //   onPressed: (SelectFilters filters) {
        //     setState(() {
        //       selectFilters.categories = filters.categories;
        //       selectFilters.tags = filters.tags;
        //       selectFilters.searchQuery = filters.searchQuery ?? "";
        //       futurePosts = postService.applyFilters(selectFilters);
        //     });
        //     scaffoldKey.currentState!.closeEndDrawer();
        //   },
        // ),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: getPadding(
                      left: 12,
                      top: 88,
                      right: 12,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          child: Container(
                            padding: getPadding(
                              top: 5,
                              bottom: 5,
                              left: 8,
                              right: 8,
                            ),
                            decoration: AppDecoration.fillWhiteA700,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Divider(
                                  height: getVerticalSize(
                                    4,
                                  ),
                                  thickness: getVerticalSize(
                                    4,
                                  ),
                                  color: ColorConstant.green300,
                                ),
                                Padding(
                                  padding: getPadding(
                                    top: 11,
                                  ),
                                  child: Text(
                                    auth.user?.name ?? "Unknown",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtInterBold20Gray90002,
                                  ),
                                ),
                                Padding(
                                  padding: getPadding(
                                    top: 8,
                                  ),
                                  child: Text(
                                    "Owner at Hist Company Inc.",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style:
                                    AppStyle.txtInterRegular16Bluegray400,
                                  ),
                                ),
                                Padding(
                                  padding: getPadding(
                                    left: 3,
                                    top: 1,
                                  ),
                                  child: Text(
                                    "Lorem ipsum dolor sit amet consecutteur saocsc elit. Reokrehanderiut, so.",
                                    maxLines: null,
                                    textAlign: TextAlign.left,
                                    style:
                                    AppStyle.txtInterRegular14Bluegray200,
                                  ),
                                ),
                                Container(
                                  margin: getMargin(
                                    left: 9,
                                    right: 9,
                                    top: 27,
                                    bottom: 4,
                                  ),
                                  padding: getPadding(
                                    left: 12,
                                    top: 20,
                                    right: 12,
                                    bottom: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorConstant.gray5001,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Status",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtInterRegular12.copyWith(
                                              fontSize: getFontSize(16)
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: getPadding(
                                          top: 14,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Member since",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle.txtInterRegular12.copyWith(
                                                  fontSize: getFontSize(16)
                                              ),
                                            ),
                                            Text(
                                              "Nov 07, 2016",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle.txtInterRegular12.copyWith(
                                                  fontSize: getFontSize(16)
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: Container(
                            margin: getMargin(
                              top: 21,
                              right: 1,
                              bottom: 338,
                            ),
                            padding: getPadding(
                              left: 32,
                              top: 16,
                              right: 32,
                              bottom: 16,
                            ),
                            decoration: AppDecoration.fillWhiteA700,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: getPadding(
                                    left: 8,
                                  ),
                                  child: Text(
                                    "About",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtInterSemiBold12.copyWith(
                                      fontSize: getFontSize(16)
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: getPadding(
                                    top: 20,
                                  ),
                                  child: Table(
                                    border: null,
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    columnWidths: const <int, TableColumnWidth>{
                                      0: FlexColumnWidth(),
                                      1: FlexColumnWidth(),
                                    },
                                    children: profileData.entries.map(
                                      (i) => TableRow(
                                        children: [
                                          TableCell(
                                            verticalAlignment: TableCellVerticalAlignment.top,
                                            child: SizedBox(
                                              height: getVerticalSize(30),
                                              child: Text(
                                                i.key,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle.txtInterSemiBold12.copyWith(
                                                  fontSize: getFontSize(14),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            verticalAlignment: TableCellVerticalAlignment.top,
                                            child: SizedBox(
                                              height: getVerticalSize(30),
                                              child: Text(
                                                i.value,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle.txtInterRegular14Bluegray200.copyWith(
                                                  color: ColorConstant.blueGray700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ).toList(),
                                  ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //
                                  //     Padding(
                                  //       padding: getPadding(
                                  //         bottom: 4,
                                  //       ),
                                  //       child: Text(
                                  //         "Name",
                                  //         overflow: TextOverflow.ellipsis,
                                  //         textAlign: TextAlign.left,
                                  //         style: AppStyle.txtInterSemiBold12.copyWith(
                                  //           fontSize: getFontSize(14),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Padding(
                                  //       padding: getPadding(
                                  //         top: 4,
                                  //       ),
                                  //       child: Text(
                                  //         "tJane",
                                  //         overflow: TextOverflow.ellipsis,
                                  //         textAlign: TextAlign.left,
                                  //         style: AppStyle.txtInterRegular14Bluegray200.copyWith(
                                  //           color: ColorConstant.blueGray700,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ),
                              ],
                            ),
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
