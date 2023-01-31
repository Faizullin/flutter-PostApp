import 'package:flutter/material.dart';
import 'package:post_app/pages/home_page.dart';
import 'package:post_app/pages/post/create_page.dart';
import 'package:post_app/pages/post/index_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String post_index = '/post';
  static const String post_create = '/post/create';
  static const String post_show = '/post/:id';

  static const String iphone14OneScreen = '/iphone_14_one_screen';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    post_index: (context) => const PostIndexPage(),
    post_create: (context) => const PostCreatePage(),
  };
}
