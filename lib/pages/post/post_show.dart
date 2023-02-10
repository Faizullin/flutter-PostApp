import 'package:flutter/material.dart';
import 'package:post_app/models/post.dart';
import 'package:post_app/services/post_service.dart';
import 'package:post_app/widgets/sidebar_drawer.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class PostShowArguements {
  final String id;
  final String title;

  PostShowArguements({required this.title, required this.id});
}

class PostShowPage extends StatefulWidget {
  final String postId;
  final String title;

  const PostShowPage({super.key,required this.postId, required this.title});

  @override
  State<PostShowPage> createState() => _PostShowPage();
}

class _PostShowPage extends State<PostShowPage> {
  final PostService postService = PostService();
  late Future<Post> futurePost = postService.getPostById(widget.postId);
  
  final QuillEditorController controller = QuillEditorController();

  @override
  void initState() {
    super.initState();
    // final PostShowArguements args = ModalRoute.of(context)!.settings.arguments as PostShowArguements;
    // futurePost = fetchPost(args.id);
  }



  @override
  Widget build(BuildContext context) {
    //final PostShowArguements args = ModalRoute.of(context)!.settings.arguments as PostShowArguements;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: const SidebarDrawer(),
      body: Center(
        child: FutureBuilder<Post>(
          future: futurePost,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              controller.setText(snapshot.data!.body);
              return QuillHtmlEditor(controller: controller, height: 50);
              // return Container(
              //   child: Html(
              //     data: snapshot.data!.body,
              //   ),
              // );
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

