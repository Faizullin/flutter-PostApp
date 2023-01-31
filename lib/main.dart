import 'package:flutter/material.dart';
import 'package:post_app/pages/home_page.dart';
import 'package:post_app/pages/post/create_page.dart';
import 'package:post_app/pages/post/index_page.dart';
import 'package:post_app/pages/post/post_show.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/post': (context) => const PostIndexPage(),
        '/post/create': (context) => const PostCreatePage(),
        //'/post/:id': (context) => const PostShowPage(),
      },
    );
  }
}