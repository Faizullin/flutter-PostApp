import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/filters.dart';
import 'package:post_app/models/post.dart';
import 'package:post_app/services/post_service.dart';
import 'package:post_app/widgets/Post/filters_sidebar_drawer.dart';
import 'package:post_app/widgets/Post/post_item.dart';
import 'package:post_app/widgets/sidebar_drawer.dart';
import 'package:post_app/widgets/breadcrumb.dart';

List list = [
  "Flutter",
  "React",
  "Ionic",
  "Xamarin",
];


//
// class PostIndexPage extends StatefulWidget {
//   const PostIndexPage({super.key});
//
//   @override
//   State<PostIndexPage> createState() => _PostIndexPage();
// }
//
// class _PostIndexPage extends State<PostIndexPage> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   final PostService postService = PostService();
//   late Future<List<Post>> futurePosts = postService.getAllPosts();
//   late Future<Filters> futureFilters = postService.getAllFilters();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//         title: const Text("Posts"),
//         // automaticallyImplyLeading: false,
//       ),
//       drawer: const SidebarDrawer(),
//       endDrawer: FiltersSidebarDrawer(
//         futureFilters: futureFilters,
//         service: postService,
//         onPressed: (Filters selectedFilters) {
//           setState(() {
//             futurePosts = postService.applyFilters(selectedFilters);
//           });
//           scaffoldKey.currentState!.closeEndDrawer();
//         },
//       ),
//     );
//   }
// }


class PostIndexPage extends StatefulWidget {
  const PostIndexPage({super.key});

  @override
  State<PostIndexPage> createState() => _PostIndexPage();
}

class _PostIndexPage extends State<PostIndexPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final PostService postService = PostService();
  late Future<List<Post>> futurePosts = postService.getAllPosts();
  late Future<Filters> futureFilters = postService.getAllFilters();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        key: scaffoldKey,
        drawer: const SidebarDrawer(),
        endDrawer: FiltersSidebarDrawer(
          futureFilters: futureFilters,
          service: postService,
          onPressed: (Filters selectedFilters) {
            setState(() {
              futurePosts = postService.applyFilters(selectedFilters);
            });
            scaffoldKey.currentState!.closeEndDrawer();
          },
        ),
        backgroundColor: ColorConstant.whiteA700,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: getVerticalSize(70.00,),
              decoration: BoxDecoration(
                color: ColorConstant.teal600,
              ),
            ),
            Breadcrumb(
              links: const [
                {"label":"Post","href":AppRoutes.postIndex,}
              ],
            ),
            Expanded(
              child: ListView(
                padding: getPadding(
                  left: 20,
                  right: 20,
                ),
                children: [
                  SizedBox(
                    height: getVerticalSize(25),
                  ),
                  FutureBuilder<List<Post>>(
                    future: futurePosts,
                    builder: (context, snapshot) {

                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return PostItem(
                              post: snapshot.data![index],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}


