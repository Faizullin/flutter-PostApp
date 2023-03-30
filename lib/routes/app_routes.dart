import 'package:flutter/material.dart';
import 'package:post_app/pages/about_us/about_us_page.dart';
import 'package:post_app/pages/auth/login_page.dart';
import 'package:post_app/pages/auth/profile_page.dart';
import 'package:post_app/pages/post/create_page/create_page.dart';
import 'package:post_app/pages/post/edit_page/edit_page.dart';
import 'package:post_app/pages/post/index_page/index_page.dart';

class AppRoutes {
  static const String aboutUs = '/about';

  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authProfile = '/auth/profile';

  static const String postIndex = '/post';
  static const String postCreate = '/post/create';
  static const String postShow = '/post/:id';
  static const String postEdit = "/post/:id/edit";

  static String initialRoute = postIndex;//aboutUs

  static Map<String, WidgetBuilder> routes = {
    postIndex: (context) => const PostIndexPage(),
    postCreate: (context) => const PostCreatePage(),
    aboutUs: (context) => const AboutUsPage(),
    authLogin: (context) => const LoginPage(),
    postEdit: (context) => const PostEditPage(
      id: '1',
      title: "Edit Post #1",
    ),
    authProfile: (context) => const ProfilePage(),
  };
}