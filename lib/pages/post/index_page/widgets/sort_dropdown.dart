import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/services/auth_provider.dart';
import 'package:provider/provider.dart';

class PostSortDropdown extends StatefulWidget {
  final Function(String) onSortChange;
  const PostSortDropdown({super.key,required this.onSortChange});

  @override
  State<PostSortDropdown> createState() => _PostSortDropdownState();
}

class _PostSortDropdownState extends State<PostSortDropdown> {
  String _currentSort = 'Latest';

  final List<String> _sortOptions = ['Latest', 'Oldest', ];

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context,listen: false,);
    if(auth.isAuthenticated){
      _sortOptions.addAll(['My posts', 'Most Liked']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getHorizontalSize(100),
      padding: getPadding(
        left: 20,
        right: 20,
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Sort By',
        ),
        value: _currentSort,
        onChanged: (newValue) {
          setState(() {
            _currentSort = newValue!;
          });
          widget.onSortChange(newValue!);
        },
        items: _sortOptions.map((sortOption) {
          return DropdownMenuItem(
            value: sortOption,
            child: Text(sortOption),
          );
        }).toList(),
      ),
    );
  }
}