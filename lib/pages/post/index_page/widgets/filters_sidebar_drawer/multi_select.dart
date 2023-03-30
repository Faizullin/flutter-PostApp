import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';

class MultiSelectWithInput extends StatefulWidget {
  final String Function(dynamic) getLabel;
  final List<dynamic> items;
  final List<dynamic> selectedItems;
  final bool singleSelect;

  const MultiSelectWithInput({
    super.key,
    required this.getLabel,
    required this.items,
    required this.selectedItems,
    required this.singleSelect,
  });
  @override
  MultiSelectWithInputState createState() => MultiSelectWithInputState();
}

class MultiSelectWithInputState extends State<MultiSelectWithInput> {
  bool _isExpanded = false;
  List<dynamic> _selectedItems = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedItems = widget.selectedItems;
  }

  List<dynamic> get _displayedItems {
    if (_searchController.text.isEmpty) {
      return widget.items;
    } else {
      return widget.items
          .where((item) => widget.getLabel(item).toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    }
  }

  void _onSearchTextChanged(String value) {
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 8.0,
          children: _selectedItems
              .map((item) => Chip(
            label: Text(widget.getLabel(item)),
            onDeleted: () {
              setState(() {
                _selectedItems.remove(item);
              });
            },
          )).toList(),
        ),
        const Divider(),
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search',
          ),
          onChanged: _onSearchTextChanged,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          // child: Container(
          //   height: _isExpanded ? null : getVerticalSize(150),
          //   child: Wrap(
          //     children: [
          //       ListView.builder(
          //         shrinkWrap: true,
          //         itemCount: _displayedItems.length,
          //         itemBuilder: (context, index) {
          //           final item = _displayedItems[index];
          //           return InputChip(
          //             label: Text(widget.getLabel(item)),
          //             onPressed: () {
          //               setState(() {
          //                 if(widget.singleSelect == true){
          //                   _selectedItems.clear();
          //                   _selectedItems.add(item);
          //                 } else if (_selectedItems.contains(item)) {
          //                   _selectedItems.remove(item);
          //                 } else {
          //                   _selectedItems.add(item);
          //                 }
          //               });
          //             },
          //           );
          //         }
          //       ),
          //     ],
          //   ),
          // ),
          child: SizedBox(
            height: _isExpanded ? null : getVerticalSize(150),
            child: Wrap(
              spacing: 8.0,
              children: widget.items.map((item) => InputChip(
                label: Text(widget.getLabel(item)),
                onPressed: () {
                  setState(() {
                    if(widget.singleSelect == true){
                    _selectedItems.clear();
                    _selectedItems.add(item);
                    } else if (_selectedItems.contains(item)) {
                    _selectedItems.remove(item);
                    } else {
                    _selectedItems.add(item);
                    }
                  });
                },
              )).toList(),
            ),
          ),
        ),
        if (_isExpanded)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: const Icon(Icons.keyboard_arrow_up),
              ),
            ],
          ),
        if (!_isExpanded && _displayedItems.length > 2)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: const Text('Show all'),
            ),
          ),
      ],
    );
  }
}