import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/category.dart';
import 'package:post_app/models/filters.dart';
import 'package:post_app/models/post.dart';
import 'package:post_app/models/tag.dart';
import 'package:post_app/pages/post/index_page/widgets/filters_sidebar_drawer/multi_select.dart';
import 'package:post_app/services/post_service.dart';





class FiltersSidebarDrawer extends StatefulWidget {
  final Future<Filters> futureFilters;
  final PostService service;
  final Function onPressed;
  final SelectFilters selectedFilters;
  final Future<Post>? futurePost;

  const FiltersSidebarDrawer({
    super.key,
    required this.futureFilters,
    required this.selectedFilters,
    required this.service,
    required this.onPressed,
    this.futurePost,
  });

  @override
  State createState() => _FiltersSidebarDrawer();
}
class _FiltersSidebarDrawer extends State<FiltersSidebarDrawer> {
  SelectFilters selectedFilters = SelectFilters(categories: [], tags: []);
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    selectedFilters.categories = [...widget.selectedFilters.categories];
    selectedFilters.tags = [...widget.selectedFilters.tags];
    _searchController.text = widget.selectedFilters.searchQuery ?? "";
  }

  @override
  Widget build(BuildContext context) {
    List<Future> futureFiltersList = [ widget.futureFilters,];
    if(widget.futurePost != null){
      futureFiltersList.add(widget.futurePost!);
    }

    return Drawer(
      child: ListView(
        children: [
          
           DrawerHeader(
            decoration: BoxDecoration(
              color: ColorConstant.teal600,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filters',
                    style: TextStyle(
                      color: ColorConstant.whiteA700,
                      fontSize: getVerticalSize(24),
                    ),
                  ),
                  SizedBox(height: getVerticalSize(16)),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.whiteA700,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              selectedFilters.searchQuery = '';
                            },
                          ),
                          hintText: 'Search...',
                          border: InputBorder.none),
                    ),
                  )
                ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: Future.wait(futureFiltersList),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Filters filters = snapshot.data![0];
                  if(futureFiltersList.length > 1){
                    Post post = snapshot.data![1];
                    List<Category> tmpCats = [];
                    List<Tag> tmpTags = [];
                    if(post.category != null){
                      tmpCats.add(post.category!);
                    }
                    tmpTags = post.tags;
                    //print("Filter loaded ${tmpCats} ${tmpTags}");
                    selectedFilters.tags = tmpTags;//(categories: tmpCats, tags: tmpTags);
                    selectedFilters.categories = tmpCats;
                  }


                  return Padding(
                      padding: getPadding(left: 16, top: 20, right: 16, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const ListTile(
                            title: Text('Categories',),
                          ),
                          MultiSelectWithInput(
                            items: filters.categories,
                            selectedItems: selectedFilters.categories,
                            getLabel: (category){
                              return category.title;
                            },
                            singleSelect: true,
                          ),
                          const ListTile(
                            title: Text('Tags'),
                          ),
                          MultiSelectWithInput(
                            items: filters.tags,
                            selectedItems: selectedFilters.tags,
                            getLabel: (tag){
                              return tag.title;
                            },
                            singleSelect: false,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    selectedFilters.searchQuery = _searchController.text;
                                    widget.onPressed(selectedFilters);
                                  },
                                  style: TextButton.styleFrom(
                                    fixedSize: Size(
                                      getHorizontalSize(200),
                                      getVerticalSize(57),
                                    ),
                                    padding: getPadding(
                                      all: 17,
                                    ),
                                    backgroundColor: ColorConstant.teal600,
                                    shadowColor: ColorConstant.teal600,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        getHorizontalSize(
                                          5.00,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Apply',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: ColorConstant.whiteA700,
                                      fontSize: getFontSize(
                                        14,
                                      ),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ],
                      ),
                  );
                }
                // else if (snapshot.hasError) {
                //   return Center(child: Text("Error: ${snapshot.error}"));
                // }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}