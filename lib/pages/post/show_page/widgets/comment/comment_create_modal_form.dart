import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/services/auth_provider.dart';
import 'package:post_app/services/comment_service.dart';
import 'package:provider/provider.dart';

class CommentCreateForm extends StatefulWidget{
  final CommentService service;

  const CommentCreateForm({super.key,required this.service});

  @override
  State<CommentCreateForm> createState() => _CommentCreateForm();
}

class _CommentCreateForm extends State<CommentCreateForm>{
  final _commentController = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Container(
      color: ColorConstant.teal600,
      child: Padding(
        padding: getPadding(
          all: 16
        ),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                  hintText: 'Add a comment...'
              ),
            ),
            TextButton(
              onPressed: () async {
                final auth = Provider.of<AuthProvider>(context,listen: false);
                if(auth.isAuthenticated){
                  Map<String,dynamic> body = {
                    'body':_commentController.text,
                  };
                  widget.service.store(body,auth.token);
                }
              },
              child: const Text("Add Comment"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
    _commentController.dispose();
  }
}