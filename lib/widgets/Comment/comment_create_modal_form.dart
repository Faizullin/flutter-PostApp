import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';

class CommentCreateForm extends StatefulWidget{
  const CommentCreateForm({super.key});

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
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                    hintText: 'Add a comment...'
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}