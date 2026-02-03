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

  // Color names for accessibility
  static const List<String> colorNames = [
    'Red',
    'Pink',
    'Purple',
    'Deep Purple',
    'Indigo',
    'Blue',
    'Light Blue',
    'Cyan',
    'Teal',
    'Green',
    'Light Green',
    'Lime',
    'Yellow',
    'Amber',
    'Orange',
    'Deep Orange',
    'Brown',
    'Grey',
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.pickerColor;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Color picker',
      hint: 'Select a color for your profile',
      child: SizedBox(
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
            final color = Colors.primaries[index].shade200;
            final isSelected = _selectedColor == color;
            final colorName = index < colorNames.length ? colorNames[index] : 'Color ${index + 1}';
            
            return Semantics(
              button: true,
              selected: isSelected,
              label: colorName,
              hint: isSelected ? 'Currently selected' : 'Tap to select',
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                  widget.onColorChanged(color);
                },
                child: Container(
                  color: color,
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          semanticLabel: 'Selected',
                        )
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
