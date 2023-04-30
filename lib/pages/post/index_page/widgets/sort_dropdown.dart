import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/pages/post/index_page/models/sort_option.dart';
import 'package:post_app/services/auth_provider.dart';
import 'package:provider/provider.dart';

class PostSortDropdown extends StatefulWidget {
  final Function(String) onSortChange;
  const PostSortDropdown({super.key,required this.onSortChange});

  @override
  State<PostSortDropdown> createState() => _PostSortDropdownState();
}

class _PostSortDropdownState extends State<PostSortDropdown> {
  String _currentSort = 'most_recent';

  final List<SortOption> _sortOptions = [
    const SortOption(label: 'Latest', slug: 'most_recent'),
    const SortOption(label: 'Oldest',slug: 'most_old'),
    const SortOption(label: 'Most Liked', slug: 'most_liked'),
  ];

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context,listen: false,);
    if(auth.isAuthenticated){
      _sortOptions.addAll([
        const SortOption(label: 'My posts', slug: 'my'),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getHorizontalSize(200),
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
        items: _sortOptions.map((SortOption sortOption) {
          return DropdownMenuItem(
            value: sortOption.slug,
            child: Text(sortOption.label),
          );
        }).toList(),
      ),
    );
  }
}