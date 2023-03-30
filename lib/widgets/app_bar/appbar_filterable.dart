import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/widgets/app_bar/appbar_title.dart';
import 'package:post_app/widgets/app_bar/custom_app_bar.dart';

class AppbarFilterable extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function onSearchSubmit;
  final bool isSearchVisible;

  const AppbarFilterable({super.key, required this.title, required this.scaffoldKey,required this.onSearchSubmit,required this.isSearchVisible});

  @override
  State createState() => _AppbarFilterable();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppbarFilterable extends State<AppbarFilterable> {
  // final PostService postService = PostService();
  // late CommentService commentService = CommentService(postId: widget.id);
  // late Future<Post> futurePost = postService.getPostById(widget.id);
  // SelectFilters selectFilters = SelectFilters(categories: [], tags: []);
  // late Future<List<Post>> futurePosts = postService.getAllPosts();
  // late Future<Filters> futureFilters = postService.getAllFilters();

  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }

  @override
  void initState(){
    super.initState();
    _isSearchVisible = widget.isSearchVisible;
  }

  void _hideSearch() {
    setState(() {
      _isSearchVisible = false;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context){
    return CustomAppBar(
        height: getVerticalSize(56.00),
        leadingWidth: 42,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
            //scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: _isSearchVisible ? Container(
          color: Colors.white,
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onSubmitted: (String value) {
              widget.onSearchSubmit();
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
        ) : AppbarTitle(text: widget.title, margin: getMargin(left: 22)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: (){
              widget.scaffoldKey.currentState!.openEndDrawer();
            },
            //margin: getMargin(left: 20, top: 18, bottom: 17)
          ),
        ]
    );
  }
}