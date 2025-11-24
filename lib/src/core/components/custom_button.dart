// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final String? routeName;
  final bool predicate;
  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    this.color,
    this.routeName,
    this.predicate = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed != null || routeName != null
          ? routeName != null
                ? () {
                    if (predicate) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        routeName!,
                        (route) => false,
                      );
                    } else {
                      Navigator.pushNamed(context, routeName!);
                    }
                  }
                : onPressed
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).colorScheme.tertiary,
        foregroundColor: Theme.of(context).colorScheme.onTertiary,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        maximumSize: Size(double.infinity, 50),
      ),
      child: Center(child: Text(text)),
    );
  }
}
