import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/comment.dart';
import 'package:post_app/widgets/custom_image_view.dart';

class ReplyCommentItem extends StatefulWidget {
  final Comment comment;
  final Function onReplyButtonPress;
  final Function onEditButtonPress;
  final Function onDeleteButtonPress;


  const ReplyCommentItem({
    super.key,
    required this.comment,
    required this.onReplyButtonPress,
    required this.onEditButtonPress,
    required this.onDeleteButtonPress,
  });

  @override
  State<ReplyCommentItem> createState() => _ReplyCommentItem();


}

class _ReplyCommentItem extends State<ReplyCommentItem> {

  @override
  Widget build(BuildContext context){
    bool canEditDelete = true;
    return Container(
      margin: getMargin(
        bottom: 15,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      Padding(
                        padding: getPadding(
                          top: 4,
                        ),
                        child: Text(
                          "01 Jan,2022",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtInterMedium12,
                        ),
                      ),
                      Container(
                        width: getHorizontalSize(
                          212,
                        ),
                        margin: getMargin(
                          top: 3,
                        ),
                        child: RichText(
                          textAlign: TextAlign.left,
                          maxLines: null,
                          text: TextSpan(
                            text: (widget.comment.parent != null && widget.comment.parent!.user != null) ? '@${widget.comment.parent!.user!.name}' : null,
                            style: AppStyle.txtInterRegular30.copyWith(
                              fontSize: getFontSize(18),
                              color: ColorConstant.lightBlueA200,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: widget.comment.body,
                                style: AppStyle.txtInterRegular30.copyWith(
                                  fontSize: getFontSize(18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
          if(widget.comment.replies != null)
            Column(
              children: widget.comment.replies!.map((comment) => ReplyCommentItem(
                comment: comment,
                onReplyButtonPress: widget.onReplyButtonPress,
                onEditButtonPress: widget.onEditButtonPress,
                onDeleteButtonPress: widget.onDeleteButtonPress,
              )).toList(),
            ),
        ],
      ),

    );
  }
}