import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  static final String _apiKey = 'AIzaSyAYd6BN1yzeQAf_3cWPsWrFxsfEc3wxP5Q';
  
  /// Analyzes text and extracts important keywords
  Future<List<String>> extractKeywords(String text) async {
    if (text.trim().isEmpty) {
      throw Exception('Text cannot be empty');
    }

    final prompt = '''
    Analyze the following text and extract the most important keywords and key phrases that would be useful for a student to understand and remember. Focus on:
    - Technical terms
    - Important concepts
    - Subject-specific vocabulary
    - Key phrases that carry significant meaning
    
    Return only the keywords/phrases as a JSON array of strings, with no additional text or explanation.
    
    Text to analyze:
    "$text"
    
    Example response format: ["keyword1", "key phrase 2", "technical term"]
    ''';

    try {
      final response = await _makeGeminiRequest(prompt);
      
      // Parse the response to extract keywords
      final keywords = _parseKeywordsFromResponse(response);
      return keywords;
    } catch (e) {
      throw Exception('Failed to extract keywords: $e');
    }
  }

  /// Gets definition for a specific keyword or phrase
  Future<String> getDefinition(String keyword) async {
    if (keyword.trim().isEmpty) {
      throw Exception('Keyword cannot be empty');
    }

    final prompt = '''
    Provide a clear, concise definition for the term "$keyword". 
    The definition should be:
    - Easy to understand for students
    - Accurate and informative
    - 1-3 sentences long
    - Include context if it's a technical term
    
    Just return the definition without any additional formatting or labels.
    ''';

    try {
      final response = await _makeGeminiRequest(prompt);
      return response.trim();
    } catch (e) {
      throw Exception('Failed to get definition for "$keyword": $e');
    }
  }

  /// Analyzes text and returns both keywords and their definitions
  Future<Map<String, String>> analyzeTextWithDefinitions(String text) async {
    try {
      // First extract keywords
      final keywords = await extractKeywords(text);
      
      // Then get definitions for each keyword
      final Map<String, String> keywordDefinitions = {};
      
      for (String keyword in keywords) {
        try {
          final definition = await getDefinition(keyword);
          keywordDefinitions[keyword] = definition;
          
          // Add a small delay to avoid rate limiting
          await Future.delayed(const Duration(milliseconds: 500));
        } catch (e) {
          // If we can't get a definition for a keyword, skip it
          print('Warning: Could not get definition for "$keyword": $e');
        }
      }
      
      return keywordDefinitions;
    } catch (e) {
      throw Exception('Failed to analyze text: $e');
    }
  }

  /// Makes a request to the Gemini API
  Future<String> _makeGeminiRequest(String prompt) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.3,
        'topK': 40,
        'topP': 0.95,
        'maxOutputTokens': 1024,
      }
    });

    final url = '$_baseUrl?key=$_apiKey';
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['candidates'] != null && 
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          
          return data['candidates'][0]['content']['parts'][0]['text'];
        } else {
          throw Exception('Invalid response format from Gemini API');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Gemini API error: ${response.statusCode} - ${errorData['error']['message']}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Parses keywords from Gemini response
  List<String> _parseKeywordsFromResponse(String response) {
    try {
      // Try to find JSON array in the response
      final jsonMatch = RegExp(r'\[.*\]').firstMatch(response);
      if (jsonMatch != null) {
        final jsonString = jsonMatch.group(0)!;
        final List<dynamic> keywordsList = jsonDecode(jsonString);
        return keywordsList.map((e) => e.toString()).toList();
      }
      
      // Fallback: split by lines and clean up
      final lines = response.split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.replaceAll(RegExp(r'^[-*•]\s*'), '').trim())
          .where((line) => line.isNotEmpty)
          .toList();
      
      return lines.take(10).toList(); // Limit to 10 keywords
    } catch (e) {
      // If parsing fails, return empty list
      print('Warning: Could not parse keywords from response: $e');
      return [];
    }
  }

  /// Validates if API key is set
  bool isApiKeyConfigured() {
    return _apiKey != 'AIzaSyAYd6BN1yzeQAf_3cWPsWrFxsfEc3wxP5Q' && _apiKey.isNotEmpty;
  }
}

