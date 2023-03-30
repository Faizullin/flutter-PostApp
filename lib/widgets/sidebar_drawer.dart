import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/services/auth_provider.dart';
import 'package:provider/provider.dart';

class SidebarDrawer extends StatelessWidget {
  final Color? backgroundColor;
  const SidebarDrawer({super.key,this.backgroundColor,});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Drawer(
      child: ListView(
        children: [
          if(auth.isAuthenticated && auth.user != null)
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: backgroundColor ?? ColorConstant.teal600,
              ),
              accountName: Text(auth.user!.name),
              accountEmail: Text(auth.user!.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: ColorConstant.whiteA700,
                child: Text(
                  auth.user!.name.substring(0,1),
                  style: TextStyle(
                    color: ColorConstant.deepOrange400,
                  ),
                ),
              ),
          ),
          if(!auth.isAuthenticated)
            DrawerHeader(
              decoration: BoxDecoration(
                color: backgroundColor ?? ColorConstant.teal600
              ),
              child: Text(
                'Please Authenticate',
                style: TextStyle(
                  color: ColorConstant.whiteA700,
                ),
              ),
            ),
          if(!auth.isAuthenticated)
            ListTile(
              title: const Text('Login'),
              leading: const Icon(Icons.login),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.authLogin);
              },
            ),
          if(auth.isAuthenticated)
            ListTile(
              title: const Text('Profile'),
              leading: const Icon(Icons.account_box),
              onTap: ()  {
                Navigator.pushNamed(context, AppRoutes.authProfile);
              },
            ),
          if(auth.isAuthenticated)
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: ()  {
                auth.logout();
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.authLogin,(Route<dynamic> route) => false);
              },
            ),
          ListTile(
            title: const Text('About'),
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.aboutUs);
            },
          ),
          ListTile(
            title: const Text('Post'),
            leading: const Icon(Icons.post_add),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.postIndex);
            },
          ),
          ListTile(
            title: const Text('Create Post'),
            leading: const Icon(Icons.post_add),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.postCreate);
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