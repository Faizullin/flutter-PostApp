import 'package:flutter/material.dart';
import 'package:post_app/models/post.dart';
import 'package:post_app/services/comment_service.dart';
import 'package:post_app/services/post_service.dart';

class CommentList extends StatefulWidget {
  final CommentService service;

  const CommentList({super.key, required this.service});

  @override
  State<CommentList> createState() => _CommentList();
}

class _CommentList extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [],
    );
  }
}

class PostShowPage extends StatefulWidget {
  final String id;
  final String title;

  const PostShowPage({super.key, required this.title, required this.id});
  @override
  State<PostShowPage> createState() => _PostShowPage();
}

class _PostShowPage extends State<PostShowPage> {
  final PostService postService = PostService();
  late CommentService commentService = CommentService(postId: widget.id);
  late Future<Post> futurePost = postService.getPostById(widget.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<Post>(
          future: futurePost,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text(snapshot.data!.body),
                  const SizedBox(
                    height: 10,
                  ),
                  CommentList(
                    service: commentService,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
