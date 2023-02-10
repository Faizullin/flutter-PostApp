import 'package:flutter/material.dart';
import 'package:post_app/models/category.dart';
import 'package:post_app/models/filters.dart';
import 'package:post_app/models/tag.dart';
import 'package:post_app/services/post_service.dart';





class FiltersSidebarDrawer extends StatefulWidget {
  final Future<Filters> futureFilters;
  final PostService service;
  final Function onPressed;

  const FiltersSidebarDrawer({super.key, required this.futureFilters,required this.service,required this.onPressed});

  @override
  State createState() => _FiltersSidebarDrawer();
}
class _FiltersSidebarDrawer extends State<FiltersSidebarDrawer> {
  Filters selectedFilters = const Filters(categories: [], tags: []);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Filter'),
          ),
          Expanded(
            child: FutureBuilder<Filters>(
              future: widget.futureFilters,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      const ListTile(
                        title: Text('Categories'),
                      ),
                      Column(
                        children: snapshot.data!.categories.map((Category category) => CheckboxListTile(
                          title: Text(category.title),
                          value: selectedFilters.categories.contains(category),
                          onChanged: (value) {
                            setState(() {
                              if(value == true){
                                selectedFilters.categories.add(category);
                              } else if (value == false){
                                selectedFilters.categories.remove(category);
                              }
                            });
                          },
                        )).toList(),
                      ),
                      const ListTile(
                        title: Text('Tags'),
                      ),
                      Column(
                        children: snapshot.data!.tags.map((Tag tag) => CheckboxListTile(
                          title: Text(tag.title),
                          value: selectedFilters.tags.contains(tag),
                          onChanged: (value) {
                            setState(() {
                              if(value == true){
                                selectedFilters.tags.add(tag);
                              } else if (value == false){
                                selectedFilters.tags.remove(tag);
                              }
                            });
                          },
                        )).toList(),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () => widget.onPressed(selectedFilters),
              child: const Text("Apply"),
            ),
          ),
        ],
      ),
    );
  }
}