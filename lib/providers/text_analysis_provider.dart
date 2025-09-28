import 'package:flutter_riverpod/legacy.dart';
import 'package:sahayak_ui/models/keyword_highlight.dart';
import 'package:sahayak_ui/services/text_analyzer_service.dart';

/// Provider for text analysis state
final textAnalysisProvider = StateNotifierProvider<TextAnalysisNotifier, TextAnalysisState>((ref) {
  return TextAnalysisNotifier();
});

/// State for text analysis
class TextAnalysisState {
  final bool isLoading;
  final AnalyzedText? analyzedText;
  final String? error;
  final bool isConfigured;

  const TextAnalysisState({
    this.isLoading = false,
    this.analyzedText,
    this.error,
    this.isConfigured = false,
  });

  TextAnalysisState copyWith({
    bool? isLoading,
    AnalyzedText? analyzedText,
    String? error,
    bool? isConfigured,
  }) {
    return TextAnalysisState(
      isLoading: isLoading ?? this.isLoading,
      analyzedText: analyzedText ?? this.analyzedText,
      error: error,
      isConfigured: isConfigured ?? this.isConfigured,
    );
  }
}

/// Notifier for managing text analysis state
class TextAnalysisNotifier extends StateNotifier<TextAnalysisState> {
  final TextAnalyzerService _textAnalyzer = TextAnalyzerService();

  TextAnalysisNotifier() : super(const TextAnalysisState()) {
    _checkConfiguration();
  }

  /// Checks if the service is properly configured
  void _checkConfiguration() {
    state = state.copyWith(isConfigured: _textAnalyzer.isConfigured());
  }

  /// Analyzes text and updates state
  Future<void> analyzeText(String text) async {
    if (text.trim().isEmpty) {
      state = state.copyWith(error: 'Text cannot be empty');
      return;
    }

    if (!state.isConfigured) {
      state = state.copyWith(error: 'Gemini API key not configured');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final analyzedText = await _textAnalyzer.analyzeText(text);
      state = state.copyWith(
        isLoading: false,
        analyzedText: analyzedText,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Gets definition for a specific keyword
  Future<String?> getKeywordDefinition(String keyword) async {
    if (!state.isConfigured) {
      return null;
    }

    try {
      return await _textAnalyzer.getKeywordDefinition(keyword);
    } catch (e) {
      return null;
    }
  }

  /// Clears the current analysis
  void clearAnalysis() {
    state = state.copyWith(
      analyzedText: null,
      error: null,
    );
  }

  /// Resets error state
  void clearError() {
    state = state.copyWith(error: null);
  }
}