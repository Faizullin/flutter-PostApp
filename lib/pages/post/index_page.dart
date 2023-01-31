import 'package:flutter/material.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';
import 'package:post_app/models/post.dart';
import 'package:post_app/services/api_post.dart';
import 'package:post_app/widgets/Post/PostItem.dart';
import 'package:post_app/widgets/SidebarDrawer.dart';

List list = [
  "Flutter",
  "React",
  "Ionic",
  "Xamarin",
];

class PostIndexPage extends StatefulWidget {
  final String title = "Posts";
  const PostIndexPage({super.key});

  @override
  State<PostIndexPage> createState() => _PostIndexPage();
}

class _PostIndexPage extends State<PostIndexPage> {
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }
  


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [


          // GFSearchBar(
          //   searchList: list,
          //   searchQueryBuilder: (query, list) {
          //     return list.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
          //     },
          //   overlaySearchListItemBuilder: (item) {
          //     return Container(
          //       padding: const EdgeInsets.all(8),
          //       child: Text(
          //         item,
          //         style: const TextStyle(fontSize: 18),
          //       ),
          //     );
          //   },
          //   onItemSelected: (item) {
          //     // setState(() {
          //     //   print('$item');
          //     // });
          //   },
          // ),
          // IconButton(
          //   icon: const Icon(Icons.search),
          //   onPressed: () => print('search'),
          // ),
          // IconButton(
          //   icon: const Icon(Icons.add),
          //   onPressed: () => print('add'),
          // )
        ],
      ),
      drawer: const SidebarDrawer(),
      body: Center(
        child: FutureBuilder<List<Post>>(
          future: futurePosts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return PostItem(
                    post: snapshot.data![index],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const Text('Unknown result');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

