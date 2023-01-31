import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/getwidget.dart';
import 'package:post_app/models/post.dart';
import 'package:post_app/pages/post/post_show.dart';

// QuillController _controller = QuillController(
//   document: 's',
// );
class PostItem extends StatelessWidget {
  final Post post;
  const PostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GFCard(
      boxFit: BoxFit.cover,
      showImage: true,
      image: (post.imageUrl!=null) ? Image.network(
        post.imageUrl!,
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ) : Image.asset(
        'assets/images/unknown.jpg',
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      title: GFListTile(
        avatar: GFAvatar(
          backgroundImage: post.imageUrl!=null ? NetworkImage(post.imageUrl!) : const AssetImage('assets/images/unknown.jpg') as ImageProvider,
        ),
        title: Text(post.title,),
        subTitle: Text(post.category != null ? post.category!.title : 'Unknown'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostShowPage(postId: post.id.toString()),
            ),
          );
        },
      ),
      content: Text(post.description),

    );
  }
}

// child: ListTile(
// leading: post.imageUrl != null ? Image.network(post.imageUrl!) : Image.asset('assets/images/unknown.jpg'),
// contentPadding: EdgeInsets.all(10),
// title: Text(post.title),
// subtitle: Text( (post.description.length > 60) ? '${post.description.substring(0,60)}...' : post.description),
// onTap: () {
//
// },
// ),
// );
// return Container(
// //height: _parent_ * 1 // percentage of parent width. like 'MediaQuery.of(context).size.width * 0.2',
// padding: const EdgeInsets.all(30.0),
// decoration: const BoxDecoration(
// boxShadow: <BoxShadow>[
// BoxShadow (
// color: Color(0x00000000),
// offset: Offset(0, 4.0),
// blurRadius: 16.0,
// ),
// ],
// borderRadius: BorderRadius.all(Radius.circular(10.0)),
// ),
// child: Column(
// children: [
// Container(
// constraints: const BoxConstraints( maxHeight: 240.0),
// //margin: const EdgeInsets.only(top: -30.0, right: -30.0, bottom: 15.0, left: -30.0),
// child: (post.imageUrl != null) ? Image.network(post.imageUrl!) : Image.asset('assets/images/unknown.jpg'),
//
// ),
// Container(
// margin: const EdgeInsets.only(top: 0, right: 0, bottom: 10.0, left: 0),
// child: Text(
// post.title,
// style: const TextStyle(
// fontSize: 16.0,
// color: Color(0x55555500),
// ),
// ),
// ),
// Container(
// padding: const EdgeInsets.all(0.0),
// //margin: const EdgeInsets.only(top: -30.0, right: -30.0, bottom: 15.0, left: -30.0),
// child: Text(
// post.category != null ? post.category!.title : "Unkknown",
// style: const TextStyle(
// fontSize: 22.0,
// fontWeight: FontWeight.w700,
// //color: Color(var(--color-default)00),
// ),
// ),
// ),
// Container(
// padding: const EdgeInsets.all(0.0),
// //margin: const EdgeInsets.only(top: -30.0, right: -30.0, bottom: 15.0, left: -30.0),
// child: Text(
// post.description,
// style: const TextStyle(
// fontSize: 22.0,
// fontWeight: FontWeight.w700,
// //color: Color(var(--color-default)00),
// ),
// ),
// ),
// ],
// ),
// );