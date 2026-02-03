// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:l_alternative/src/core/components/image_button.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';

class CircleImageButton extends StatelessWidget {
  final String imagePath;
  final bool isSelected;
  final VoidCallback onPressed;
  final String? semanticLabel;

  const CircleImageButton({
    super.key,
    required this.imagePath,
    required this.isSelected,
    required this.onPressed,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Semantics(
      button: true,
      selected: isSelected,
      label: semanticLabel ?? 'Selection button',
      hint: isSelected ? 'Currently selected' : 'Tap to select',
      child: RoundedContainer(
        borderRadius: 999,
        borderWidth: 1,
        borderColor: Theme.of(context).colorScheme.tertiary,
        width: size.width * 0.15,
        height: size.width * 0.15,
        child: CircleAvatar(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.tertiary
              : Colors.transparent,
          radius: 999,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ImageButton(
              imagePath: imagePath,
              onPressed: onPressed,
              size: size.width * 0.1,
              isColored: false,
              semanticLabel: '',
              // borderRadius: 999,
            ),
          ),
        ),
      ),
    );
  }
}
