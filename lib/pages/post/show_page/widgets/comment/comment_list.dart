import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/models/comment.dart';
import 'package:post_app/pages/post/show_page/widgets/comment/comment_create_form.dart';
import 'package:post_app/pages/post/show_page/widgets/comment/comment_item.dart';
import 'package:post_app/services/auth_provider.dart';
import 'package:post_app/services/comment_service.dart';
import 'package:provider/provider.dart';

class CommentList extends StatefulWidget{
  final CommentService service;
  final int commentsCount;
  final String postId;
  final Function showAuthAlertDialog;

  const CommentList({super.key, required this.service,required this.commentsCount,required this.postId,required this.showAuthAlertDialog});

  @override
  State<CommentList> createState() => _CommentList();
}

class _CommentList extends State<CommentList> {
  List<Comment> comments = [];
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Comment>>(
        future: widget.service.getAllPostComments(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            comments = snapshot.data!;
            final auth = Provider.of<AuthProvider>(context, listen: false);
            return  Padding(
              padding: getPadding(
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommentCreateForm(
                    service: widget.service,
                    showAuthAlertDialog: widget.showAuthAlertDialog,
                    updateComments: () {
                      setState(() {

                      });
                    },
                  ),
                  SizedBox(
                    height: getVerticalSize(63),
                  ),
                  Text(
                    "${widget.commentsCount} Comments",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtInterBold22,
                  ),
                  SizedBox(
                    height: getVerticalSize(15),
                  ),
                  ListView.builder(
                    itemCount: comments.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return CommentItem(
                        comment: comments[index],
                        onReplyButtonPress: (BuildContext context, Comment replyComment) async {
                          if(!auth.isAuthenticated){
                            widget.showAuthAlertDialog();
                            return;
                          }
                          _showReplyDialog(context, replyComment);
                        },
                        onEditButtonPress: (BuildContext context, Comment comment) async {
                          if(!auth.isAuthenticated){
                            widget.showAuthAlertDialog();
                            return;
                          }
                          _showEditDialog(context, comment);
                        },
                        onDeleteButtonPress: (BuildContext context, Comment comment) async {
                          if(!auth.isAuthenticated){
                            widget.showAuthAlertDialog();
                            return;
                          }
                          _showDeleteDialog(context, comment);
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }


  void _showReplyDialog(BuildContext context, Comment comment) {
    final TextEditingController controller = TextEditingController(
        text: '',
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reply to comment'),
          content: Form(
            key: formKey1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.trim().isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _storeReply(comment, controller.text).then((){
                  Navigator.pop(context);
                  setState(() {});
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Comment comment) {
    final TextEditingController controller = TextEditingController(
      text: comment.body,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit comment'),
          content: Form(
            key: formKey2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.trim().isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey2.currentState!.validate()) {
                  final auth = Provider.of<AuthProvider>(context,listen: false);
                  widget.service.update({
                    'id': comment.id,
                    'message': controller.text,
                  },auth.token).then((value) {
                    Navigator.pop(context);
                    setState(() {});
                  });
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Comment comment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete comment'),
          content: const Text("Are you sure to delete the comment"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final auth = Provider.of<AuthProvider>(context,listen: false);
                if(!auth.isAuthenticated){
                  return;
                }
                widget.service.delete({
                  'id': comment.id,
                },auth.token).then((value) {
                  Navigator.pop(context);
                  setState(() {});
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  _storeReply(Comment comment, String text) async {
    final auth = Provider.of<AuthProvider>(context,listen: false);
    if(!auth.isAuthenticated){
      return;
    }
    if (formKey1.currentState!.validate()) {
      Comment replyComment = await widget.service.storeReply({
        'message': text,
        'parent_id': comment.id,
        'post_id': widget.postId,
      }, auth.token);
      setState(() {
        if (comment.replies == null) {
          comment.replies = [replyComment];
        } else {
          comment.replies!.add(replyComment);
        }
      });
    }
  }
}