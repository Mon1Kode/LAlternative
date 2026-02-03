// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/provider/app_providers.dart';

class ImageButton extends ConsumerStatefulWidget {
  final String imagePath;
  final VoidCallback? onPressed;
  final String? text;
  final double? width;
  final double? height;
  final double? size;
  final double borderRadius;
  final double fontSize;
  final Alignment? alignment;
  final bool isColored;
  final Color? color;
  final String? semanticLabel;

  const ImageButton({
    super.key,
    required this.imagePath,
    this.onPressed,
    this.text,
    this.width,
    this.height,
    this.size,
    this.borderRadius = 0.0,
    this.fontSize = 16.0,
    this.alignment,
    this.isColored = true,
    this.color,
    this.semanticLabel,
  });

  @override
  ConsumerState<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends ConsumerState<ImageButton> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.read(themeModeProvider);
    return Semantics(
      button: true,
      enabled: widget.onPressed != null,
      label: widget.semanticLabel ?? widget.text ?? 'Image button',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          onTap: widget.onPressed,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Image.asset(
                  "assets/images/${widget.imagePath}",
                  color: widget.isColored
                      ? widget.color ??
                            (themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black)
                      : null,
                  width: widget.size ?? widget.width ?? 150,
                  height: widget.size ?? widget.height ?? 150,
                  semanticLabel: '',
                ),
              ),
              Container(
                width: widget.size ?? widget.width ?? 150,
                height: widget.size ?? widget.height ?? 150,
                alignment: widget.alignment ?? Alignment.center,
                padding: const EdgeInsets.only(bottom: 4.0),
                child: widget.text != null
                    ? Text(
                        widget.text!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: Colors.white54,
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
