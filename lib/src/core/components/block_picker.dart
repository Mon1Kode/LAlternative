// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.
import 'package:flutter/material.dart';

class BlockPicker extends StatefulWidget {
  final Color pickerColor;
  final Function(Color) onColorChanged;

  const BlockPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  State<BlockPicker> createState() => BlockPickerState();
}

class BlockPickerState extends State<BlockPicker> {
  Color _selectedColor = Colors.white;

  get selectedColor => _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.pickerColor;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: GridView.builder(
        itemCount: 18,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = Colors.primaries[index].shade500;
              });
              widget.onColorChanged(Colors.primaries[index].shade500);
            },
            child: Container(
              color: Colors.primaries[index],
              child: _selectedColor == Colors.primaries[index].shade500
                  ? const Icon(Icons.check)
                  : null,
            ),
          );
        },
      ),
    );
  }
}
