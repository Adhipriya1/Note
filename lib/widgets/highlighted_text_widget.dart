import 'package:flutter/material.dart';
import 'package:sahayak_ui/models/keyword_highlight.dart';

/// Widget that displays text with highlighted keywords
class HighlightedTextWidget extends StatelessWidget {
  final AnalyzedText analyzedText;
  final TextStyle? textStyle;
  final TextStyle? highlightStyle;
  final Color highlightColor;
  final Function(String keyword, String definition)? onKeywordTap;
  final Function(String keyword, String definition)? onKeywordLongPress;

  const HighlightedTextWidget({
    super.key,
    required this.analyzedText,
    this.textStyle,
    this.highlightStyle,
    this.highlightColor = Colors.yellow,
    this.onKeywordTap,
    this.onKeywordLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: _buildTextSpan(context),
    );
  }

  TextSpan _buildTextSpan(BuildContext context) {
    final List<TextSpan> spans = [];
    final String text = analyzedText.originalText;
    int currentIndex = 0;

    // Sort highlights by start index
    final sortedHighlights = List<KeywordHighlight>.from(analyzedText.highlights)
      ..sort((a, b) => a.startIndex.compareTo(b.startIndex));

    for (final highlight in sortedHighlights) {
      // Add text before highlight
      if (currentIndex < highlight.startIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, highlight.startIndex),
          style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
        ));
      }

      // Add highlighted text
      spans.add(TextSpan(
        text: highlight.keyword,
        style: highlightStyle ?? TextStyle(
          backgroundColor: highlightColor.withOpacity(0.3),
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
        recognizer: _createGestureRecognizer(highlight),
      ));

      currentIndex = highlight.endIndex;
    }

    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
      ));
    }

    return TextSpan(children: spans);
  }

  /// Creates gesture recognizer for keyword interactions
  dynamic _createGestureRecognizer(KeywordHighlight highlight) {
    return null; // Will be implemented with proper gesture recognizer
  }
}

/// Widget that shows keyword definition in a popup
class KeywordDefinitionPopup extends StatelessWidget {
  final String keyword;
  final String definition;
  final VoidCallback? onClose;

  const KeywordDefinitionPopup({
    super.key,
    required this.keyword,
    required this.definition,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    keyword,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7846EC),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClose ?? () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              definition,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onClose ?? () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7846EC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Got it',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows the definition popup
  static void show(BuildContext context, String keyword, String definition) {
    showDialog(
      context: context,
      builder: (context) => KeywordDefinitionPopup(
        keyword: keyword,
        definition: definition,
      ),
    );
  }
}