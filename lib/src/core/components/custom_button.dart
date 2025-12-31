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
  final bool isEnabled;
  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    this.color,
    this.routeName,
    this.predicate = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (onPressed != null || routeName != null) && isEnabled
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

  static dotted({
    required String text,
    required Future<Null> Function() onPressed,
    Color? color,
    bool predicate = false,
  }) {
    return ElevatedButton(
      onPressed: () async {
        await onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color?.withValues(alpha: 0.7) ?? Colors.transparent,
        foregroundColor: Colors.black,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Colors.black,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        maximumSize: Size(double.infinity, 50),
      ),
      child: Center(child: Text(text)),
    );
  }
}
