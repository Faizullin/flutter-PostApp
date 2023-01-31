import 'package:flutter/material.dart';
import 'package:post_app/models/post.dart';
import 'package:post_app/services/api_post.dart';

class PostShowPage extends StatefulWidget {
  final String? id;
  final String title;

  const PostShowPage({super.key, required this.title, this.id});
  @override
  State<PostShowPage> createState() => _PostShowPage();
}

class _PostShowPage extends State<PostShowPage> {
  late Future<Post> futurePost;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost(widget.id!);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/post/create'),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<Post>(
          future: futurePost,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.title);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              //return Text('Unknown result');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

