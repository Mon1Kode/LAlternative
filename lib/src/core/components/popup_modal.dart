// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:l_alternative/src/core/components/custom_button.dart';

class PopupModal extends StatefulWidget {
  final String title;
  final String content;
  final String ctaText;
  final String? secondaryCtaText;
  final Function(BuildContext context)? onPressed;
  const PopupModal({
    super.key,
    required this.title,
    required this.content,
    required this.ctaText,
    this.secondaryCtaText,
    this.onPressed,
  });

  @override
  State<PopupModal> createState() => _PopupModalState();
}

class _PopupModalState extends State<PopupModal> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titleTextStyle: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      title: Text(widget.title, textAlign: TextAlign.center),
      content: Text(
        widget.content,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        CustomButton(
          text: widget.ctaText,
          onPressed: () {
            Navigator.of(context).pop();
            if (widget.onPressed != null) {
              widget.onPressed!(context);
            }
          },
        ),
        if (widget.secondaryCtaText != null)
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                widget.secondaryCtaText!,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
