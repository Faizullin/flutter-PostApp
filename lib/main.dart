import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/services/auth_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();

  // Create an instance of AuthProvider
  final authProvider = AuthProvider();
  await authProvider.checkAuth();
  runApp(
    ChangeNotifierProvider.value(
      value: authProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //debugShowMaterialGrid: true,
      theme: ThemeData(
        visualDensity: VisualDensity.standard,
      ),
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
