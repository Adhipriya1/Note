/// Model for representing highlighted keywords in text
class KeywordHighlight {
  final String keyword;
  final String definition;
  final int startIndex;
  final int endIndex;
  final bool isHighlighted;

  const KeywordHighlight({
    required this.keyword,
    required this.definition,
    required this.startIndex,
    required this.endIndex,
    this.isHighlighted = true,
  });

  KeywordHighlight copyWith({
    String? keyword,
    String? definition,
    int? startIndex,
    int? endIndex,
    bool? isHighlighted,
  }) {
    return KeywordHighlight(
      keyword: keyword ?? this.keyword,
      definition: definition ?? this.definition,
      startIndex: startIndex ?? this.startIndex,
      endIndex: endIndex ?? this.endIndex,
      isHighlighted: isHighlighted ?? this.isHighlighted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KeywordHighlight &&
        other.keyword == keyword &&
        other.startIndex == startIndex &&
        other.endIndex == endIndex;
  }

  @override
  int get hashCode {
    return keyword.hashCode ^ startIndex.hashCode ^ endIndex.hashCode;
  }

  @override
  String toString() {
    return 'KeywordHighlight(keyword: $keyword, startIndex: $startIndex, endIndex: $endIndex)';
  }
}

/// Model for analyzed text with keywords and definitions
class AnalyzedText {
  final String originalText;
  final List<KeywordHighlight> highlights;
  final Map<String, String> definitions;
  final DateTime analyzedAt;

  const AnalyzedText({
    required this.originalText,
    required this.highlights,
    required this.definitions,
    required this.analyzedAt,
  });

  AnalyzedText copyWith({
    String? originalText,
    List<KeywordHighlight>? highlights,
    Map<String, String>? definitions,
    DateTime? analyzedAt,
  }) {
    return AnalyzedText(
      originalText: originalText ?? this.originalText,
      highlights: highlights ?? this.highlights,
      definitions: definitions ?? this.definitions,
      analyzedAt: analyzedAt ?? this.analyzedAt,
    );
  }

  /// Get definition for a specific keyword
  String? getDefinition(String keyword) {
    return definitions[keyword];
  }

  /// Check if a keyword has a definition
  bool hasDefinition(String keyword) {
    return definitions.containsKey(keyword);
  }

  /// Get all unique keywords
  List<String> get keywords {
    return highlights.map((h) => h.keyword).toSet().toList();
  }
}