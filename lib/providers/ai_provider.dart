import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sahayak_ui/models/analysis_models.dart';

// --- State Providers ---

// This will hold the final analysis result for the UI to display
final analysisResultProvider = StateProvider<AnalysisResult?>((ref) => null);

// Manages the loading state
final isLoadingProvider = StateProvider<bool>((ref) => false);

// --- AI Service ---

final aiServiceProvider = Provider((ref) => AIService());

class AIService {
  // This is the main method that orchestrates the analysis
  Future<AnalysisResult> analyzeText(String text) async {
    // Simulate network delay for a realistic feel
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, you would make an API call to a service like the Gemini API here.
    // For now, we simulate the AI's logic locally.

    // 1. Extract Keywords
    final keywords = _extractKeywords(text);
    if (keywords.isEmpty) {
      throw Exception("Could not find any keywords to analyze.");
    }

    // 2. Generate other content based on the extracted keywords
    final summary = _generateSummary(keywords);
    final mnemonics = _generateMnemonics(keywords);
    final quiz = _generateQuiz(keywords);
    final conceptMap = _generateConceptMap(keywords);

    return AnalysisResult(
      keywords: keywords,
      summary: summary,
      mnemonics: mnemonics,
      quiz: quiz,
      conceptMap: conceptMap,
    );
  }

  // --- Private Helper Methods for AI Simulation ---

  // A simple algorithm to find the most frequent words (our keywords)
  List<String> _extractKeywords(String text) {
    const stopWords = {
      'a',
      'an',
      'the',
      'is',
      'in',
      'it',
      'of',
      'for',
      'on',
      'with',
      'to',
      'and',
      'that',
      'i',
      'you',
      'he',
      'she',
      'we',
      'they',
      'what',
      'where',
      'when',
    };

    // Normalize text: lowercase, remove punctuation, and split into words
    final words = text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(' ')
        .where((word) => word.isNotEmpty && !stopWords.contains(word))
        .toList();

    // Count word frequencies
    final frequencyMap = <String, int>{};
    for (var word in words) {
      frequencyMap[word] = (frequencyMap[word] ?? 0) + 1;
    }

    // Sort words by frequency
    final sortedWords = frequencyMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Return the top 5 most frequent words
    return sortedWords.take(5).map((e) => e.key).toList();
  }

  String _generateSummary(List<String> keywords) {
    return "This document primarily discusses '${keywords[0]}'. Key related concepts include '${keywords.skip(1).join("', '")}'. The text appears to explain the relationships and importance of these topics in a broader context.";
  }

  String _generateMnemonics(List<String> keywords) {
    final firstLetters = keywords.map((k) => k[0].toUpperCase()).join();
    return "To remember the key topics (${keywords.join(', ')}), try recalling the acronym: $firstLetters.";
  }

  Map<String, List<String>> _generateConceptMap(List<String> keywords) {
    if (keywords.isEmpty) return {};
    // The first keyword is the central topic
    // The rest are connected to it
    return {keywords[0]: keywords.skip(1).toList()};
  }

  List<QuizQuestion> _generateQuiz(List<String> keywords) {
    if (keywords.length < 3)
      return []; // Need at least 3 keywords for a decent quiz

    final random = Random();
    final distractorWords = [
      'technology',
      'science',
      'art',
      'history',
      'finance',
      'education',
      'health',
    ];

    // Create a shuffled list of options for each question
    List<String> createOptions(String correctAnswer) {
      final options = {correctAnswer};
      while (options.length < 4) {
        options.add(distractorWords[random.nextInt(distractorWords.length)]);
      }
      return options.toList()..shuffle();
    }

    return [
      QuizQuestion(
        question: "What is the central theme of the text?",
        options: createOptions(keywords[0]),
        correctAnswer: keywords[0],
      ),
      QuizQuestion(
        question:
            "Which of the following concepts is also mentioned as a key point?",
        options: createOptions(keywords[1]),
        correctAnswer: keywords[1],
      ),
      QuizQuestion(
        question: "The document links '${keywords[0]}' with which other topic?",
        options: createOptions(keywords[2]),
        correctAnswer: keywords[2],
      ),
    ];
  }
}
