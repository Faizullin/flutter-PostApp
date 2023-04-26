import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/filters.dart';
import 'package:post_app/models/post.dart';
import 'package:post_app/pages/post/index_page/widgets/sort_dropdown.dart';
import 'package:post_app/services/post_service.dart';
import 'package:post_app/widgets/filters_sidebar_drawer/filters_sidebar_drawer.dart';
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
  late SelectFilters selectFilters = SelectFilters(categories: [], tags: []);
  late Future<Filters> futureFilters = postService.getAllFilters();

  final int _pageSize = 6;
  final PagingController<int, Post > _pagingController = PagingController(firstPageKey: 1);
  Future<void> _fetchData({SelectFilters? selectedFilters,int page = 1}) async {
    selectedFilters = selectedFilters ?? selectFilters;
    try {
      List<Post> newItems = await postService.applyFilters(selectedFilters,page);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = page + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

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
    // final args = ModalRoute.of(context)!.settings.arguments != null ? ModalRoute.of(context)!.settings.arguments as PostIndexArguments : PostIndexArguments();
    // print("Args $args");
    _pagingController.addPageRequestListener((page) {
      print("Fetch $page");
      _fetchData(
        selectedFilters: selectFilters,
        page: page,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final auth = Provider.of<AuthProvider>(context,listen: false);
    final args = ModalRoute.of(context)!.settings.arguments != null ? ModalRoute.of(context)!.settings.arguments as PostIndexArguments : PostIndexArguments();
    if(widget.selectFilters != null ){
      selectFilters = selectFilters;
    } else if(args.selectedFilters != null){
      selectFilters = args.selectedFilters!;
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
                selectFilters.searchQuery = value;
                _pagingController.refresh();
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
            ),
          ],
        ),
        drawer: const SidebarDrawer(
          currentIndex: AppRoutes.postIndex,
        ),
        endDrawer: FiltersSidebarDrawer(
          futureFilters: futureFilters,
          selectedFilters: selectFilters,
          service: postService,
          onPressed: (SelectFilters filters) {
            setState(() {
              selectFilters.categories = filters.categories;
              selectFilters.tags = filters.tags;
              selectFilters.searchQuery = filters.searchQuery ?? "";
              _searchController.text = filters.searchQuery ?? "";
              _pagingController.refresh();
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
                PostSortDropdown(
                  onSortChange: (String value){
                    selectFilters.sortColumn = value;
                    _pagingController.refresh();
                  }
                ),
                SizedBox(
                  height: getVerticalSize(12),
                ),
                Container(
                  padding: getPadding(
                    left: 20,
                    right: 20,
                  ),
                  child: RefreshIndicator(
                    onRefresh: () => Future.sync(() => _pagingController.refresh()),
                    child: PagedListView<int, Post>(
                      shrinkWrap: true,
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<Post>(
                        itemBuilder: (context, item, index) => PostItem(
                          post: item,
                          canEdit: postService.sortColumn == 'my',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pagingController.dispose();
    super.dispose();
  }
}



