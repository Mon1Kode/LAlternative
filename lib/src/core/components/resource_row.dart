// All rights reserved
// Monikode Mobile Solutions and Draw Your Fight
// Created by MoniK on 2024.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:l_alternative/src/core/provider/app_providers.dart';

class ResourceRow extends ConsumerStatefulWidget {
  final String title;
  final String content;
  final bool isEditable;
  final void Function(String)? onTitleSubmitted;
  final void Function(String)? onContentSubmitted;

  const ResourceRow({
    super.key,
    required this.title,
    required this.content,
    this.isEditable = false,
    this.onTitleSubmitted,
    this.onContentSubmitted,
  });

  @override
  ConsumerState<ResourceRow> createState() => _ResourceRowState();
}

class _ResourceRowState extends ConsumerState<ResourceRow>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final _contentController = TextEditingController(text: widget.content);

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      borderColor: Theme.of(context).colorScheme.secondary,
      borderWidth: 1,
      padding: EdgeInsets.only(
        top: 12,
        left: 12,
        right: 12,
        bottom: _expanded ? 12 : 0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.isEditable
                  ? Expanded(
                      child: TextField(
                        controller: TextEditingController(text: widget.title),
                        showCursor: true,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(fontSize: 15),
                        onSubmitted: (value) {
                          widget.onTitleSubmitted?.call(value);
                        },
                      ),
                    )
                  : Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(fontSize: 15),
                        maxLines: 2,
                      ),
                    ),
              Material(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: RoundedContainer(
                    color: _expanded
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.tertiary,
                    borderRadius: 8,
                    borderWidth: 1,
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(_expanded ? 'Fermer' : 'Ouvrir'),
                  ),
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(2),
              curve: Curves.easeInOut,
              alignment: Alignment.topLeft,
              height: _expanded ? null : 40,
              child: widget.isEditable
                  ? TextField(
                      controller: _contentController,
                      showCursor: true,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: ref.watch(themeModeProvider) == ThemeMode.dark
                            ? Colors.grey
                            : Color(0xFF6D6D6D),
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: _expanded ? 20 : 2,
                      textAlign: TextAlign.start,
                      onChanged: (value) {
                        widget.onContentSubmitted?.call(value);
                      },
                    )
                  : Text(
                      widget.content,
                      style: TextStyle(
                        fontSize: 12,
                        color: ref.watch(themeModeProvider) == ThemeMode.dark
                            ? Colors.grey
                            : Color(0xFF6D6D6D),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: _expanded ? 20 : 2,
                      textAlign: TextAlign.start,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
