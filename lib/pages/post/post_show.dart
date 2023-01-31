import 'package:flutter/material.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:post_app/models/post.dart';
import 'package:post_app/services/api_post.dart';
import 'package:post_app/widgets/SidebarDrawer.dart';
import 'package:quill_html_editor/quill_html_editor.dart';


class PostShowPage extends StatefulWidget {
  final String postId;

  const PostShowPage({super.key,required this.postId});

  @override
  State<PostShowPage> createState() => _PostShowPage();
}

class _PostShowPage extends State<PostShowPage> {
  late Future<Post> futurePost;
  final QuillEditorController controller = QuillEditorController();

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost(widget.postId);
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("TItle"),
      ),
      drawer: const SidebarDrawer(),
      body: Center(
        child: FutureBuilder<Post>(
          future: futurePost,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data!.body);
              controller.setText(snapshot.data!.body);
              return QuillHtmlEditor(controller: controller, height: 50);
              // return Container(
              //   child: Html(
              //     data: snapshot.data!.body,
              //   ),
              // );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const Text('Unknown result');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

