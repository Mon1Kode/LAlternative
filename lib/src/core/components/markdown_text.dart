// All rights reserved
// Monikode Mobile Solutions
// Created by MoniK on 2024.
import 'package:flutter/material.dart';

/// A widget that displays a list of paragraphs with markdown-like formatting.
///
/// The [MarkdownText] widget takes a list of paragraphs and displays them
/// with support for:
/// - Bold text for any text enclosed in double asterisks (**)
/// - Headings using # syntax (# for h1, ## for h2, ### for h3, etc.)
/// - Bullet points using - syntax (lines starting with "- ")
class MarkdownText extends StatefulWidget {
  /// The list of paragraphs to display.
  final List<String> paragraphs;

  /// The font size of the text.
  final double fontSize;

  /// The font family to use when painting the text.
  final String fontFamily;

  /// The alignment of the text.
  final TextAlign textAlign;

  final Color? textColor;

  /// A widget that displays a list of paragraphs with markdown-like formatting.
  ///
  /// The [MarkdownText] widget takes a list of paragraphs and displays them
  /// with support for:
  /// - Bold text for any text enclosed in double asterisks (**)
  /// - Headings using # syntax (# for h1, ## for h2, ### for h3, etc.)
  /// - Bullet points using - syntax (lines starting with "- ")
  ///
  /// The [paragraphs] parameter [must not be null].
  /// The [fontSize] parameter defaults to [16.0] if not provided.
  /// The [fontFamily] parameter defaults to ["Roboto"] if not provided.
  /// The [textAlign] parameter defaults to [TextAlign.left] if not provided.
  const MarkdownText({
    super.key,
    required this.paragraphs,
    this.fontSize = 16.0,
    this.fontFamily = "Roboto",
    this.textAlign = TextAlign.left,
    this.textColor,
  });

  @override
  State<MarkdownText> createState() => _MarkdownTextState();
}

class _MarkdownTextState extends State<MarkdownText> {
  /// The list of text spans to display.
  List<TextSpan> spans = [];

  /// Builds the list of text spans from the paragraphs.
  ///
  /// This method processes markdown syntax including:
  /// - Headers (# for h1, ## for h2, etc.)
  /// - Bold text (text enclosed in **)
  /// - Bullet points (lines starting with "- ")
  Future<void> _buildSpans() async {
    spans = [];
    String fullText = widget.paragraphs.join("\n\n");
    List<String> lines = fullText.split('\n');

    for (int lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      String line = lines[lineIndex];

      // Check if line is a heading
      RegExp headingPattern = RegExp(r'^(#{1,6})\s+(.+)$');
      Match? headingMatch = headingPattern.firstMatch(line);

      // Check if line is a bullet point
      RegExp bulletPattern = RegExp(r'^-\s+(.+)$');
      Match? bulletMatch = bulletPattern.firstMatch(line);

      if (headingMatch != null) {
        // It's a heading
        int headingLevel = headingMatch.group(1)!.length;
        String headingText = headingMatch.group(2)!;

        // Calculate heading font size (h1 = 2x base, h2 = 1.75x, h3 = 1.5x, etc.)
        double headingFontSize =
            widget.fontSize * (1.5 - (headingLevel - 1) * 0.25).clamp(1.0, 2.0);

        // Process bold text within heading
        _processBoldText(headingText, headingFontSize, FontWeight.bold);
      } else if (bulletMatch != null) {
        // It's a bullet point
        String bulletText = bulletMatch.group(1)!;

        // Add bullet character
        spans.add(
          TextSpan(
            text: '• ',
            style: TextStyle(
              fontFamily: widget.fontFamily,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.normal,
            ),
          ),
        );

        // Process bold text within bullet point
        _processBoldText(bulletText, widget.fontSize, FontWeight.normal);
      } else {
        // Regular text - process bold
        _processBoldText(line, widget.fontSize, FontWeight.normal);
      }

      // Add newline after each line except the last one
      if (lineIndex < lines.length - 1) {
        spans.add(TextSpan(text: '\n'));
      }
    }
  }

  /// Processes text for bold markdown (**text**)
  void _processBoldText(String text, double fontSize, FontWeight baseWeight) {
    List<String> parts = text.split("**");
    for (var i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(
          TextSpan(
            text: parts[i],
            style: TextStyle(
              fontFamily: widget.fontFamily,
              fontSize: fontSize,
              fontWeight: i % 2 == 0 ? baseWeight : FontWeight.bold,
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _buildSpans();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: widget.textAlign,

      text: TextSpan(
        children: spans,
        style: TextStyle(
          fontSize: widget.fontSize,
          fontFamily: widget.fontFamily,
          textBaseline: TextBaseline.alphabetic,
          color: widget.textColor,
        ),
      ),
    );
  }
}
