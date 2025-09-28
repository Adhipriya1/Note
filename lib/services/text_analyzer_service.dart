import 'package:sahayak_ui/models/keyword_highlight.dart';
import 'package:sahayak_ui/services/gemini_service.dart';

/// Service for analyzing text and creating highlights
class TextAnalyzerService {
  final GeminiService _geminiService = GeminiService();

  /// Analyzes text and returns AnalyzedText with highlights and definitions
  Future<AnalyzedText> analyzeText(String text) async {
    if (text.trim().isEmpty) {
      throw Exception('Text cannot be empty');
    }

    try {
      // Get keywords and definitions from Gemini
      final keywordDefinitions = await _geminiService.analyzeTextWithDefinitions(text);
      
      // Create highlights by finding keyword positions in text
      final highlights = _createHighlights(text, keywordDefinitions);
      
      return AnalyzedText(
        originalText: text,
        highlights: highlights,
        definitions: keywordDefinitions,
        analyzedAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to analyze text: $e');
    }
  }

  /// Creates KeywordHighlight objects by finding keyword positions in text
  List<KeywordHighlight> _createHighlights(String text, Map<String, String> keywordDefinitions) {
    final List<KeywordHighlight> highlights = [];
    final String lowerText = text.toLowerCase();
    
    for (final entry in keywordDefinitions.entries) {
      final keyword = entry.key;
      final definition = entry.value;
      final lowerKeyword = keyword.toLowerCase();
      
      // Find all occurrences of this keyword in the text
      int startIndex = 0;
      while (true) {
        final index = lowerText.indexOf(lowerKeyword, startIndex);
        if (index == -1) break;
        
        // Check if this is a whole word match (not part of another word)
        if (_isWholeWordMatch(text, index, keyword.length)) {
          highlights.add(KeywordHighlight(
            keyword: text.substring(index, index + keyword.length), // Preserve original case
            definition: definition,
            startIndex: index,
            endIndex: index + keyword.length,
          ));
        }
        
        startIndex = index + 1;
      }
    }
    
    // Sort highlights by start index
    highlights.sort((a, b) => a.startIndex.compareTo(b.startIndex));
    
    // Remove overlapping highlights (keep the first one)
    return _removeOverlappingHighlights(highlights);
  }

  /// Checks if the found keyword is a whole word (not part of another word)
  bool _isWholeWordMatch(String text, int startIndex, int length) {
    // Check character before
    if (startIndex > 0) {
      final charBefore = text[startIndex - 1];
      if (RegExp(r'[a-zA-Z0-9]').hasMatch(charBefore)) {
        return false;
      }
    }
    
    // Check character after
    final endIndex = startIndex + length;
    if (endIndex < text.length) {
      final charAfter = text[endIndex];
      if (RegExp(r'[a-zA-Z0-9]').hasMatch(charAfter)) {
        return false;
      }
    }
    
    return true;
  }

  /// Removes overlapping highlights, keeping the first occurrence
  List<KeywordHighlight> _removeOverlappingHighlights(List<KeywordHighlight> highlights) {
    if (highlights.isEmpty) return highlights;
    
    final List<KeywordHighlight> filtered = [];
    
    for (final highlight in highlights) {
      bool overlaps = false;
      
      for (final existing in filtered) {
        if (_highlightsOverlap(highlight, existing)) {
          overlaps = true;
          break;
        }
      }
      
      if (!overlaps) {
        filtered.add(highlight);
      }
    }
    
    return filtered;
  }

  /// Checks if two highlights overlap
  bool _highlightsOverlap(KeywordHighlight a, KeywordHighlight b) {
    return !(a.endIndex <= b.startIndex || b.endIndex <= a.startIndex);
  }

  /// Gets definition for a specific keyword using Gemini
  Future<String> getKeywordDefinition(String keyword) async {
    try {
      return await _geminiService.getDefinition(keyword);
    } catch (e) {
      throw Exception('Failed to get definition for "$keyword": $e');
    }
  }

  /// Checks if Gemini API is properly configured
  bool isConfigured() {
    return _geminiService.isApiKeyConfigured();
  }
}