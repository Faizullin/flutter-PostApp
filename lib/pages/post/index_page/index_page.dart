import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/filters.dart';
import 'package:post_app/models/post.dart';
import 'package:post_app/pages/post/index_page/models/search_result.dart';
import 'package:post_app/pages/post/index_page/widgets/sort_dropdown.dart';
import 'package:post_app/services/post_service.dart';
import 'package:post_app/pages/post/index_page/widgets/filters_sidebar_drawer/filters_sidebar_drawer.dart';
import 'package:post_app/pages/post/index_page/widgets/post_item.dart';
import 'package:post_app/widgets/app_bar/appbar_title.dart';
import 'package:post_app/widgets/app_bar/custom_app_bar.dart';
import 'package:post_app/widgets/sidebar_drawer.dart';
import 'package:post_app/widgets/breadcrumb.dart';



class PostIndexArguments {
  final SelectFilters? selectedFilters;

  PostIndexArguments({this.selectedFilters});
}


class PostIndexPage extends StatefulWidget {
  final SelectFilters? selectFilters;
  const PostIndexPage({super.key,this.selectFilters});

  @override
  State<PostIndexPage> createState() => _PostIndexPage();
}

class _PostIndexPage extends State<PostIndexPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final PostService postService = PostService();
  SelectFilters selectFilters = SelectFilters(categories: [], tags: []);
  SearchResult searchResults = const SearchResult(posts: [], tags: []);
  late Future<List<Post>> futurePosts = postService.getAllPosts();
  late Future<Filters> futureFilters = postService.getAllFilters();

  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }
  void _hideSearch() {
    setState(() {
      _isSearchVisible = false;
      _searchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    //final args = ModalRoute.of(context)!.settings.arguments as PostIndexArguments;
    // if(widget.selectFilters != null ){
    //   futurePosts = postService.applyFilters(widget.selectFilters!);
    // } else if(args.selectedFilters != null){
    //   futurePosts = postService.applyFilters(args.selectedFilters!);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments != null ? ModalRoute.of(context)!.settings.arguments as PostIndexArguments : PostIndexArguments();
    if(widget.selectFilters != null ){
      futurePosts = postService.applyFilters(widget.selectFilters!);
    } else if(args.selectedFilters != null){
      futurePosts = postService.applyFilters(args.selectedFilters!);
    }
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
            title: _isSearchVisible ? Container(
              color: Colors.white,
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onSubmitted: (String value) {
                  setState(() {
                    futurePosts = postService.applySearchSubmit(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _hideSearch,
                  ),
                ),
              ),
            ) : AppbarTitle(text: "Home", margin: getMargin(left: 22)),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _toggleSearch,
              ),
              IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: (){
                    scaffoldKey.currentState!.openEndDrawer();
                  },
                  //margin: getMargin(left: 20, top: 18, bottom: 17)
              ),
            ]),
        drawer: const SidebarDrawer(),
        endDrawer: FiltersSidebarDrawer(
          futureFilters: futureFilters,
          selectedFilters: selectFilters,
          service: postService,
          onPressed: (SelectFilters filters) {
            setState(() {
              selectFilters.categories = filters.categories;
              selectFilters.tags = filters.tags;
              selectFilters.searchQuery = filters.searchQuery ?? "";
              futurePosts = postService.applyFilters(selectFilters);
            });
            scaffoldKey.currentState!.closeEndDrawer();
          },
        ),

        body: GestureDetector(
          onTap: _hideSearch,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Breadcrumb(
                  links: const [
                    {
                      "label": "Post",
                      //"href": AppRoutes.postIndex,
                    }
                  ],
                ),
                SizedBox(
                  height: getVerticalSize(12),
                ),
                PostSortDropdown(onSortChange: (String value){
                  print("On sort change $value");
                  postService.addToFiltersAndApply({
                    'sort_field': 'value',
                  });
                }),
                SizedBox(
                  height: getVerticalSize(12),
                ),
                Container(
                  padding: getPadding(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(

                    children: [
                      FutureBuilder<List<Post>>(
                        future: futurePosts,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return PostItem(
                                      post: snapshot.data![index],
                                    );
                                  },
                                ),
                                // Pagination(
                                //   postService: postService
                                // ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text('Snapshot error: ${snapshot.error}');
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [CircularProgressIndicator()],
                          );
                        },
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
        )
      ),
    );
  }
}



