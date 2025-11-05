// All rights reserved
// Monikode Mobile Solutions and IncluSens
// Created by MoniK on 2025.
import 'package:flutter/material.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';

class QAndAWriter extends StatefulWidget {
  final String question;
  final double? height;
  final TextEditingController? controller;
  final Color? textColor;

  const QAndAWriter({
    super.key,
    required this.question,
    this.controller,
    this.height,
    this.textColor,
  });

  @override
  State<QAndAWriter> createState() => _QAndAWriterState();
}

class _QAndAWriterState extends State<QAndAWriter> {
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(focusNode);
      },
      child: RoundedContainer(
        padding: EdgeInsets.all(16),
        // width: MediaQuery.of(context).size.width - 16 * 2,
        borderWidth: 1,
        borderColor:
            widget.textColor ?? Theme.of(context).colorScheme.onPrimary,
        // height: widget.height ?? MediaQuery.of(context).size.height / 3 - 32,
        color: Theme.of(context).colorScheme.primary,
        borderRadius: 24,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.question,
                style: TextStyle(
                  fontSize: 16,
                  color:
                      widget.textColor ??
                      Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Divider(color: widget.textColor),
              TextField(
                focusNode: focusNode,
                style: TextStyle(
                  color:
                      widget.textColor ??
                      Theme.of(context).colorScheme.onPrimary,
                ),
                cursorColor:
                    widget.textColor ?? Theme.of(context).colorScheme.onPrimary,
                controller: widget.controller ?? TextEditingController(),
                decoration: InputDecoration(
                  filled: true,
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                ),
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
