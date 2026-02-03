// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.
import 'package:flutter/material.dart';

class BlockPicker extends StatefulWidget {
  final dynamic pickerItem;
  final void Function(dynamic) onChanged;
  final List<dynamic> items;

  const BlockPicker({
    super.key,
    required this.pickerItem,
    required this.onChanged,
    required this.items,
  });

  @override
  State<BlockPicker> createState() => BlockPickerState();
}

class BlockPickerState extends State<BlockPicker> {
  dynamic _selectedItem;

  @override
  void initState() {
    super.initState();
    if (widget.pickerItem != null) {
      _selectedItem = widget.pickerItem;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.4,
      width: double.infinity,
      child: GridView.builder(
        itemCount: widget.items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedItem = widget.items[index];
              });
              widget.onChanged(widget.items[index]);
            },
            child: Stack(
              children: [
                widget.items[index],
                ?_selectedItem == widget.items[index]
                    ? Center(child: const Icon(Icons.check))
                    : null,
              ],
            ),
          );
        },
      ),
    );
  }
}
