import 'package:flutter/material.dart';
import 'package:post_app/models/post.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/pages/post/post_show.dart';
import 'package:post_app/widgets/custom_image_view.dart';

// class PostItem extends StatelessWidget {
//   final Post post;
//   const PostItem({super.key, required this.post});
//
//   @override
//   Widget build(BuildContext context) {
//     return GFCard(
//       boxFit: BoxFit.cover,
//       showImage: true,
//       image: (post.imageUrl!=null) ? Image.network(
//         post.imageUrl!,
//         height: MediaQuery.of(context).size.height * 0.2,
//         width: MediaQuery.of(context).size.width,
//         fit: BoxFit.cover,
//       ) : Image.asset(
//         'assets/images/unknown.jpg',
//         height: MediaQuery.of(context).size.height * 0.2,
//         width: MediaQuery.of(context).size.width,
//         fit: BoxFit.cover,
//       ),
//       title: GFListTile(
//         avatar: GFAvatar(
//           backgroundImage: post.imageUrl!=null ? NetworkImage(post.imageUrl!) : const AssetImage('assets/images/unknown.jpg') as ImageProvider,
//         ),
//         title: Text(post.title,),
//         subTitle: Text(post.category != null ? post.category!.title : 'Unknown'),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PostShowPage(postId: post.id.toString()),
//             ),
//           );
//         },
//       ),
//       content: Text(post.description),
//
//     );
//   }
// }



// class PostItem extends StatelessWidget {
//   final Post post;
//   const PostItem({super.key, required this.post});
//
//   @override
//   Widget build(BuildContext context) {
//     return GFCard(
//       boxFit: BoxFit.cover,
//       showImage: true,
//       image: (post.imageUrl!=null) ? Image.network(
//         post.imageUrl!,
//         height: MediaQuery.of(context).size.height * 0.2,
//         width: MediaQuery.of(context).size.width,
//         fit: BoxFit.cover,
//       ) : Image.asset(
//         'assets/images/unknown.jpg',
//         height: MediaQuery.of(context).size.height * 0.2,
//         width: MediaQuery.of(context).size.width,
//         fit: BoxFit.cover,
//       ),
//       title: GFListTile(
//         avatar: GFAvatar(
//           backgroundImage: post.imageUrl!=null ? NetworkImage(post.imageUrl!) : const AssetImage('assets/images/unknown.jpg') as ImageProvider,
//         ),
//         title: Text(post.title,),
//         subTitle: Text(post.category != null ? post.category!.title : 'Unknown'),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PostShowPage(postId: post.id.toString()),
//             ),
//           );
//         },
//       ),
//       content: Text(post.description),
//
//     );
//   }
// }



class PostItem extends StatelessWidget {
  final Post post;
  const PostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context){
    return Container(
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
      margin: getMargin(
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (post.imageUrl!=null) ? CustomImageView(
            url: post.imageUrl,
            height: getVerticalSize(240.00,),
            width: getHorizontalSize(336.00,),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => PostShowPage(
                  postId: post.id.toString(),
                  title: "Post: ${post.title}",
                ),
              ));
            },
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
                Text(
                  post.category != null ? post.category!.title : 'Unknown' ,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtInterMedium16,
                ),
                Container(
                  margin: getMargin(
                    top: 12,
                    bottom: 13,
                  ),
                  child: Text(
                    post.description,
                    maxLines: null,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtInterBold22.copyWith(
                      letterSpacing: getHorizontalSize(1.10,),
                    ),
                  ),
                ),

                Row(
                  children: [
                    CustomImageView(
                      radius: BorderRadius.circular(getHorizontalSize(25)),
                      imagePath: ImageConstant.imgUnknown,
                      height: getVerticalSize(50.0,),
                      width: getVerticalSize(50.0,),
                    ),
                    Padding(
                      padding: getPadding(
                        left: 13,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Marina Doe",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtInterMedium20,
                          ),
                          SizedBox(
                            height: getVerticalSize(3),
                          ),
                          Text(
                            "Jan 1, 2022",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtInterMedium12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}