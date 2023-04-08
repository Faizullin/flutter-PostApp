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
  List<dynamic> _displayedItems = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedItems = widget.selectedItems;
    _displayedItems = widget.items;
  }

  void filterItems(String query) {
    setState(() {
      _displayedItems = widget.items.where((item) => widget.getLabel(item).toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    });
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
          onChanged: filterItems,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: SizedBox(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                for (int i = 0; i < (_isExpanded ? _displayedItems.length : (_displayedItems.length > 4) ? 4 : _displayedItems.length); i++)
                  InputChip(
                    label: Text(widget.getLabel(_displayedItems[i])),
                    onPressed: () {
                      setState(() {
                        if(widget.singleSelect == true){
                          _selectedItems.clear();
                          _selectedItems.add(_displayedItems[i]);
                        } else if (_selectedItems.contains(_displayedItems[i])) {
                          _selectedItems.remove(_displayedItems[i]);
                        } else {
                          _selectedItems.add(_displayedItems[i]);
                        }
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
        if (_isExpanded && _displayedItems.length > 2)
          Padding(
            padding: getPadding(),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _isExpanded = false;
                });
              },
              icon: const Icon(Icons.keyboard_arrow_up),
            ),
          ),
        if (!_isExpanded && _displayedItems.length > 2)
          Padding(
            padding: getPadding(),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _isExpanded = true;
                });
              },
              icon: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
      ],
    );
  }
}