import 'package:flutter/material.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key,});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            accountName: Text('Ahmer Iqbal'),
            accountEmail: Text('ahmer5253@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text('A'),
            ),
              // decoration: const BoxDecoration(
              //   color: Colors.blue,
              // ),
              // child: Column(
              //   children: const [
              //     CircleAvatar(
              //       backgroundColor: Colors.white,
              //       radius: 50,
              //     ),
              //     Text('User'),
              //   ],
              // )
          ),
          ListTile(
            title: const Text('Login'),
            leading: const Icon(Icons.login),
            onTap: () {
              Navigator.pushNamed(context, '/auth/login');
            },
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Post'),
            leading: const Icon(Icons.post_add),
            onTap: () {
              Navigator.pushNamed(context, '/post');
            },
          ),
          ListTile(
            title: const Text('Create Post'),
            leading: const Icon(Icons.post_add),
            onTap: () {
              Navigator.pushNamed(context, '/post/create');
            },
          ),
          const Divider(height: 10.0, color: Colors.black),
          ListTile(
            trailing: const Icon(Icons.close, color: Colors.red),
            title: const Text('Close'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}