import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final List<String> _routes = [
    '/post',
    '/post/create',
    '/',
    '/post',
    '/post',
  ];


  MyBottomNavigationBar({super.key,required this.selectedIndex,});

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      initialActiveIndex: selectedIndex,
      backgroundColor: const Color(0xFF008374),
      items: const [
        TabItem(icon: Icons.article, title: 'Posts'),
        TabItem(icon: Icons.add, title: 'Add'),
        TabItem(icon: Icons.home, title: 'Home'),
        TabItem(icon: Icons.message, title: 'Dashboard'),
        TabItem(icon: Icons.people, title: 'Profile'),
      ],
      onTap: (int i){
        Navigator.pushNamed(context,_routes[i]);
      },
    );
  }

}

