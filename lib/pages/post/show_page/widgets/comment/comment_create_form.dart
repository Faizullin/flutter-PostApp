import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/services/auth_provider.dart';
import 'package:post_app/services/comment_service.dart';
import 'package:post_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class CommentCreateForm extends StatefulWidget{
  final CommentService service;
  const CommentCreateForm({super.key, required this.service});

  @override
  State createState() => _CommentCreateForm();
}

class _CommentCreateForm extends State<CommentCreateForm> {
  final _commentController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Form(
        key: formKey,
        child: Container(
          width: getHorizontalSize(
            338,
          ),
          margin: getMargin(
            top: 66,
          ),
          padding: getPadding(
            left: 32,
            top: 33,
            right: 32,
            bottom: 33,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: 'Add a comment...',
                ),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              CustomButton(
                height: getVerticalSize(
                  55,
                ),
                width: getHorizontalSize(
                  100,
                ),
                text: "Post Comment",
                margin: getMargin(
                  top: 30,
                ),
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    final auth = Provider.of<AuthProvider>(
                        context, listen: false);
                    if (auth.isAuthenticated) {
                      Map<String, dynamic> body = {
                        'body': _commentController.text,
                      };
                      widget.service.store(body, auth.token);
                    } else {
                      Navigator.pushNamed(context, AppRoutes.authLogin);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}