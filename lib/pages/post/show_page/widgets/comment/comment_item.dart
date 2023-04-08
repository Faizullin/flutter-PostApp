import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/comment.dart';
import 'package:post_app/pages/post/show_page/widgets/comment/reply_comment_item.dart';
import 'package:post_app/services/auth_provider.dart';
import 'package:post_app/widgets/custom_image_view.dart';
import 'package:provider/provider.dart';

class CommentItem extends StatefulWidget {
  final Comment comment;
  final Function onReplyButtonPress;
  final Function onEditButtonPress;
  final Function onDeleteButtonPress;


  const CommentItem({
    super.key,
    required this.comment,
    required this.onReplyButtonPress,
    required this.onEditButtonPress,
    required this.onDeleteButtonPress,
  });

  @override
  State<CommentItem> createState() => _CommentItem();
}


class _CommentItem extends State<CommentItem> {

  bool showReplies = false;

  @override
  Widget build(BuildContext context){
    bool canEditDelete = false;
    final auth = Provider.of<AuthProvider>(context,listen: false);
    if(auth.isAuthenticated && auth.user != null && widget.comment.user != null){
      canEditDelete = widget.comment.user!.id == auth.user!.id;
    }

    return Container(
      margin: getMargin(
        bottom: 15,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.comment.user != null ?  CustomImageView(
                imagePath: ImageConstant.imgUnknown,
                height: getVerticalSize(60.0,),
                width: getHorizontalSize(60.0,),
              ) : CustomImageView(
                radius: BorderRadius.circular(getHorizontalSize(70)),
                imagePath: ImageConstant.imgUnknown,
                height: getVerticalSize(60.0,),
                width: getVerticalSize(60.0,),
              ),

              Expanded(
                child: Padding(
                  padding: getPadding(
                    left: 13,
                    top: 6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.comment.user != null ? widget.comment.user!.name : "Unknown",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtInterBold16,
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              child: Text(
                                "Reply",
                                style: AppStyle.txtInterBold16.copyWith(
                                  color: ColorConstant.teal600,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              onPressed: () {
                                widget.onReplyButtonPress(context,widget.comment);
                              },
                            ),
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding: getPadding(
                      //     top: 4,
                      //   ),
                      //   child: Text(
                      //     "01 Jan,2022",
                      //     overflow: TextOverflow.ellipsis,
                      //     textAlign: TextAlign.left,
                      //     style: AppStyle.txtInterMedium12,
                      //   ),
                      // ),
                      Container(
                        width: getHorizontalSize(
                          242,
                        ),
                        margin: getMargin(
                          top: 3,
                        ),
                        child: Text(
                          widget.comment.body,
                          style: AppStyle.txtInterRegular30.copyWith(
                            fontSize: getFontSize(18),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if(widget.comment.replies != null && widget.comment.replies!.isNotEmpty)
                            IconButton(
                              icon: showReplies ? const Icon(Icons.arrow_upward_rounded) : const Icon(Icons.arrow_downward_rounded),
                              onPressed: (){
                                setState(() {
                                  showReplies = !showReplies;
                                });
                              },
                            ),
                          if(canEditDelete)
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: ColorConstant.lightBlueA200,
                              ),
                              onPressed: () {
                                widget.onEditButtonPress(context, widget.comment);
                              },
                            ),
                          if(canEditDelete)
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                widget.onDeleteButtonPress(context, widget.comment);
                              },
                            ),
                        ],
                      ),


                    ],
                  ),
                ),
              ),

            ],
          ),
          if(showReplies)
            Padding(
                padding: getPadding(
                  left: 25,
                ),
                child: Column(
                  children: widget.comment.replies!.map((comment) => ReplyCommentItem(
                    comment: comment,
                    onReplyButtonPress: widget.onReplyButtonPress,
                    onEditButtonPress: widget.onEditButtonPress,
                    onDeleteButtonPress: widget.onDeleteButtonPress,
                  )).toList(),
                )
            ),
        ],
      ),
    );
  }
}