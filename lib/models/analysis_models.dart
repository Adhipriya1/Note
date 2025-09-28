class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

class AnalysisResult {
  final List<String> keywords;
  final String summary;
  final String mnemonics;
  final List<QuizQuestion> quiz;
  final Map<String, List<String>> conceptMap;

  AnalysisResult({
    required this.keywords,
    required this.summary,
    required this.mnemonics,
    required this.quiz,
    required this.conceptMap,
  });
}
