import 'package:flutter/material.dart';
import 'package:post_app/pages/home_page.dart';
import 'package:post_app/pages/post/create_page.dart';
import 'package:post_app/pages/post/index_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String postIndex = '/post';
  static const String postCreate = '/post/create';
  static const String postShow = '/post/:id';

  static const String iphone14OneScreen = '/iphone_14_one_screen';
  static const String initialRoute = postIndex;

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    postIndex: (context) => const PostIndexPage(),
    postCreate: (context) => const PostCreatePage(),
  };
}
