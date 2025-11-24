// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final Function(String)? onChanged;
  final bool obscureText;
  final double? height;
  final int maxLines;
  const CustomTextField({
    super.key,
    required this.textController,
    required this.hintText,
    this.obscureText = false,
    this.onChanged,
    this.height,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 56,
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(8),
        child: TextField(
          controller: widget.textController,
          showCursor: true,
          maxLines: widget.maxLines,
          cursorColor: Theme.of(context).colorScheme.onPrimary,
          obscureText: widget.obscureText ? _isObscured : false,
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          decoration: InputDecoration(
            fillColor: Theme.of(
              context,
            ).colorScheme.surface.withValues(alpha: 0.9),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.7),
              ),
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.7),
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                : null,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: 0.7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
