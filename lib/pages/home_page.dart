import 'package:flutter/material.dart';
import 'package:post_app/widgets/BottomNavigation.dart';
import 'package:post_app/widgets/SidebarDrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key,});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  bool isAuth = false;

  buildAuthScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      // bottomNavigationBar: MyBottomNavigationBar(
      //   selectedIndex: 2,
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
          ],
        ),
      ),
      drawer: const SidebarDrawer(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.pushNamed(context, '/post/create'),
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  buildUnAuthScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Unauthenticated!' ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: 2,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/post/create'),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  @override
  Widget build(BuildContext context) {
    return buildAuthScreen();
    // return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}