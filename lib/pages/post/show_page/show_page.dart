import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:like_button/like_button.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/filters.dart';
import 'package:post_app/models/post.dart';
import 'package:post_app/models/tag.dart';
import 'package:post_app/pages/post/index_page/index_page.dart';
import 'package:post_app/pages/post/show_page/widgets/comment/comment_list.dart';
import 'package:post_app/pages/post/index_page/widgets/filters_sidebar_drawer/filters_sidebar_drawer.dart';
import 'package:post_app/services/comment_service.dart';
import 'package:post_app/services/post_service.dart';
import 'package:post_app/theme/quill_style.dart';
import 'package:post_app/widgets/app_bar/appbar_filterable.dart';
import 'package:post_app/widgets/breadcrumb.dart';
import 'package:post_app/widgets/custom_image_view.dart';
import 'package:post_app/widgets/sidebar_drawer.dart';


class PostShowPage extends StatefulWidget {
  final String id;
  final String title;

  const PostShowPage({super.key, required this.title, required this.id});
  @override
  State<PostShowPage> createState() => _PostShowPage();
}

class _PostShowPage extends State<PostShowPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final PostService postService = PostService();
  late CommentService commentService = CommentService(postId: widget.id);
  late Future<Post> futurePost = postService.getPostById(widget.id);
  SelectFilters selectFilters = SelectFilters(categories: [], tags: []);
  late Future<List<Post>> futurePosts = postService.getAllPosts();
  late Future<Filters> futureFilters = postService.getAllFilters();


  bool isSearchVisible = false;

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments != null ? ModalRoute.of(context)!.settings.arguments as PostIndexArguments : PostIndexArguments();
    // if(widget.selectFilters != null ){
    //   futurePosts = postService.applyFilters(widget.selectFilters!);
    //   print("Basic selected filters: ${widget.selectFilters}");
    // } else if(args.selectedFilters != null){
    //   futurePosts = postService.applyFilters(args.selectedFilters!);
    //   print("Basic selected filters: ${args.selectedFilters}");
    // }
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstant.whiteA700,
        appBar:  AppbarFilterable(
          title: widget.title,
          scaffoldKey: scaffoldKey,
          isSearchVisible: isSearchVisible,
          onSearchSubmit: (){

          },
        ),
        drawer: const SidebarDrawer(),
        endDrawer: FiltersSidebarDrawer(
          futureFilters: futureFilters,
          futurePost: futurePost,
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
            Navigator.pushNamed(context, AppRoutes.postIndex,arguments: PostIndexArguments(selectedFilters: selectFilters));
          },
        ),
        body: GestureDetector(
          onTap: () {
            //_hideSearch();
            if(isSearchVisible) {
              setState(() {
                isSearchVisible = false;
              });
            }
          },
          child: SingleChildScrollView(
            child:  Column(
              children: [
                Breadcrumb(
                  links: const [{
                    'label':'Post',
                    'href':AppRoutes.postIndex,
                  },{
                    'label':'Post Details',
                  }
                ]),
                SizedBox(
                  height: getVerticalSize(25),
                ),
                FutureBuilder<Post>(
                    future: futurePost,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {

                        return _buildPostDetail(snapshot.data!);
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildPostDetail(Post post) {
    return Column(
        children: [
          Container(
            padding: getPadding(
              left: 20,
              right: 20,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  getHorizontalSize(10.00,),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (post.imageUrl!=null || post.imageUrl!.isEmpty) ? CustomImageView(
                    url: post.imageUrl,
                    height: getVerticalSize(240.00,),
                    width: getHorizontalSize(336.00,),
                  ) : CustomImageView(
                    imagePath: ImageConstant.imgUnknown,
                    height: getVerticalSize(240.00,),
                    width: getHorizontalSize(336.00,),
                  ),
                  Padding(
                    padding: getPadding(
                      top: 15,
                      left: 15,
                      right: 15,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(post.title),
                            Container(
                              margin: getMargin(
                                left: 10,
                              ),
                              child: Text(
                                post.category != null ? post.category!.title : 'Unknown' ,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInterMedium16,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: getMargin(
                            top: 12,
                            bottom: 13,
                          ),
                          child: Html(
                            data: post.body,
                            style: QuillStyle.getStyles(),
                          ),
                        ),
                        Container(
                          margin: getMargin(
                            top:10,
                            bottom:10,
                          ),
                          child:  Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                LikeButton(
                                  size: 20,
                                  circleColor: const CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                                  bubblesColor: const BubblesColor(
                                    dotPrimaryColor: Color(0xff33b5e5),
                                    dotSecondaryColor: Color(0xff0099cc),
                                  ),
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      Icons.favorite,
                                      color: isLiked ? Colors.red : Colors.grey,
                                      size: 20,
                                    );
                                  },
                                  likeCount: post.likesCount,
                                  onTap: onLikeButtonTapped,
                                  // countBuilder: (int count, bool isLiked, String text) {
                                  //   var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
                                  //   if (count == 0) {
                                  //     return Text(
                                  //       "love",
                                  //       style: TextStyle(color: color),
                                  //     );
                                  //
                                  //   return Text(
                                  //     text,
                                  //     style: TextStyle(color: color),
                                  //   );
                                  // },
                                ),
                              ]
                          ),
                        ),
                        if(post.tags.isNotEmpty)
                          _buildTags(post.tags),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            height: getVerticalSize(15),
          ),
          _buildAuthor(post),
          _buildCommentList(
              commentsCount: post.commentsCount,
          ),
        ],
    );
  }
  Widget _buildTags(List<Tag> postTags){
    List<Widget> tagsList = [];
    if(postTags.length > 4){
      for (int i = 0; i < 4; i++){
        tagsList.add(Container(
          margin: getMargin(
            right: 10,
          ),
          child: InkWell(
            child: Text(postTags[i].title),
          ),
        ));
      }
      tagsList.add(Container(
        margin: getMargin(
          left: 5,
        ),
        child: const Text('...'),
      ));
    } else {
      for (int i = 0; i < postTags.length; i++) {
        tagsList.add(Container(
          margin: getMargin(
            right: 10,
          ),
          child: InkWell(
            child: Text(postTags[i].title),
          ),
        ));
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: tagsList,
    );
  }

  Widget _buildAuthor(Post post){
    if(post.author == null){
      return Container(
        padding: getPadding(
          left: 15,
          right: 15,
        ),
        child: const Text("Unknown"),
      );
    }
    return Padding(
      padding: getPadding(
        all: 10,
      ),
      child: Container(
        padding: getPadding(
          all: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            getHorizontalSize(10.00,),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 3,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomImageView(
              radius: BorderRadius.circular(getHorizontalSize(70)),
              imagePath: ImageConstant.imgUnknown,
              height: getVerticalSize(110.0,),
              width: getVerticalSize(110.0,),
            ),
            SizedBox(
              width: getHorizontalSize(13),
            ),
            Expanded(
                child: Column(
                  children: [
                    Text(
                      post.author!.name,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtInterMedium20,
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    Text(
                      "Lorem Ipsum is simply dummy tsum has been the industry's standard dummy text ever since the 1500s.",
                      // style: AppStyle.txtInterThin16,
                      maxLines: null,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtInterRegular30.copyWith(
                        fontSize: getFontSize(18),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentList({required int commentsCount}){
    return CommentList(
      service: commentService,
      commentsCount: commentsCount,
      postId: widget.id,
    );
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async{
    /// send your request here
    // final bool success= await sendRequest();

    /// if failed, you can do nothing
    // return success? !isLiked:isLiked;
    print("Like");
    return !isLiked;
  }
}
