import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahayak_ui/models/analysis_models.dart';
import 'package:sahayak_ui/models/keyword_highlight.dart';
import 'package:sahayak_ui/providers/ai_provider.dart';
import 'package:sahayak_ui/providers/text_analysis_provider.dart';
import 'package:sahayak_ui/widgets/highlighted_text_widget.dart';
import 'package:sahayak_ui/services/camera_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _noteController = TextEditingController();
  bool _useGeminiAnalysis = true;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // --- Logic to trigger analysis using Riverpod ---
  Future<void> _analyseNote() async {
    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter some text to analyze.")),
      );
      return;
    }

    if (_useGeminiAnalysis) {
      // Use Gemini API for analysis
      await ref.read(textAnalysisProvider.notifier).analyzeText(_noteController.text);
    } else {
      // Use original local analysis
      ref.read(analysisResultProvider.notifier).state = null;
      ref.read(isLoadingProvider.notifier).state = true;

      try {
        final result = await ref.read(aiServiceProvider).analyzeText(_noteController.text);
        ref.read(analysisResultProvider.notifier).state = result;
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An error occurred: $e")),
          );
        }
      } finally {
        ref.read(isLoadingProvider.notifier).state = false;
      }
    }
  }

  Future<void> _captureImage() async {
    try {
      if (!CameraService.isSupported) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera is not supported on this platform'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final hasPermission = await CameraService.requestPermissions();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final imagePath = await CameraService.captureImage();
      if (imagePath != null) {
        // Process the captured image for text extraction
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image captured! Text extraction feature coming soon.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera feature is not fully implemented yet'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- Watch providers reactively ---
    var watch = ref.watch(textAnalysisProvider);
    var watch2 = watch;
    final bool isLoading;
    if (_useGeminiAnalysis) {
      isLoading = watch2.isLoading;
    } else {
      isLoading = ref.watch(isLoadingProvider);
    } // <-- Corrected line
    final analysisResult = ref.watch(analysisResultProvider);
    final textAnalysisState = ref.watch(textAnalysisProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // --- Background Decorations ---
          Positioned(
            bottom: -100,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                color: Color(0xFFDBC9F5),
                borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(500, 200),
                ),
              ),
            ),
          ),
          Positioned(
            top: -50,
            left: -30,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFFE1D9FC),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // --- Main Scrollable Content ---
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- App Title ---
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Syn',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF7846EC),
                        ),
                      ),
                      Text(
                        'apNo',
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'te',
                        style: TextStyle(
                          color: Color(0xFF3CF8D5),
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // --- Analysis Mode Toggle ---
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Analysis Mode: '),
                        Switch(
                          value: _useGeminiAnalysis,
                          onChanged: (value) {
                            setState(() {
                              _useGeminiAnalysis = value;
                            });
                          },
                          activeColor: const Color(0xFF7846EC),
                        ),
                        Text(_useGeminiAnalysis ? 'Gemini AI' : 'Local'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // --- Input Card ---
                  Container(
                    padding: const EdgeInsets.all(22),
                    height: 300,
                    width: 500,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _noteController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Start typing or paste your notes here...',
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                  color: Color(0xFF9159DB),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(
                                  color: Color(0xFF9159DB),
                                  width: 2.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: isLoading ? null : _analyseNote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9159DB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3.0,
                                  ),
                                )
                              : const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Analyse',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 10),
                        // Camera button
                        ElevatedButton.icon(
                          onPressed: _captureImage,
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                          label: const Text(
                            'Capture Text',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3CF8D5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // --- Results Section ---
                  if (_useGeminiAnalysis && textAnalysisState.analyzedText != null)
                    GeminiResultsSection(analyzedText: textAnalysisState.analyzedText!),
                  if (!_useGeminiAnalysis && analysisResult != null)
                    ResultsSection(analysisResult: analysisResult),
                  if (textAnalysisState.error != null)
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(height: 8),
                          Text(
                            textAnalysisState.error!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          if (!textAnalysisState.isConfigured) ...[
                            const SizedBox(height: 8),
                            const Text(
                              'Please configure your Gemini API key in lib/services/gemini_service.dart',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Gemini Results Section ---
class GeminiResultsSection extends ConsumerStatefulWidget {
  final AnalyzedText analyzedText;
  const GeminiResultsSection({super.key, required this.analyzedText});

  @override
  ConsumerState<GeminiResultsSection> createState() => _GeminiResultsSectionState();
}

class _GeminiResultsSectionState extends ConsumerState<GeminiResultsSection> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Highlighted Text', 'Keywords', 'Definitions'];

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return HighlightedTextWidget(
          analyzedText: widget.analyzedText,
          onKeywordLongPress: (keyword, definition) {
            KeywordDefinitionPopup.show(context, keyword, definition);
          },
        );
      case 1:
        return Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: widget.analyzedText.keywords
              .map((keyword) => GestureDetector(
                    onTap: () {
                      final definition = widget.analyzedText.getDefinition(keyword);
                      if (definition != null) {
                        KeywordDefinitionPopup.show(context, keyword, definition);
                      }
                    },
                    child: Chip(
                      label: Text(keyword),
                      backgroundColor: const Color(0xFF7846EC).withOpacity(0.1),
                    ),
                  ))
              .toList(),
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.analyzedText.definitions.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7846EC),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(entry.value),
                ],
              ),
            );
          }).toList(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // --- Tabs ---
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: List.generate(_tabs.length, (index) {
                final bool isSelected = _selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF9159DB)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          _tabs[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const Divider(height: 30),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Align(
              key: ValueKey(_selectedIndex),
              alignment: Alignment.topLeft,
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Local Analysis Results Section ---
class ResultsSection extends StatefulWidget {
  final AnalysisResult analysisResult;
  const ResultsSection({super.key, required this.analysisResult});

  @override
  State<ResultsSection> createState() => _ResultsSectionState();
}

class _ResultsSectionState extends State<ResultsSection> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Summary', 'Keywords', 'Quiz'];

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return Text(widget.analysisResult.summary);
      case 1:
        return Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: widget.analysisResult.keywords
              .map((keyword) => Chip(label: Text(keyword)))
              .toList(),
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.analysisResult.quiz.asMap().entries.map((entry) {
            int idx = entry.key;
            var question = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text('${idx + 1}. ${question.question}'),
            );
          }).toList(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // --- Tabs ---
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: List.generate(_tabs.length, (index) {
                final bool isSelected = _selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF9159DB)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          _tabs[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const Divider(height: 30),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Align(
              key: ValueKey(_selectedIndex),
              alignment: Alignment.topLeft,
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }
}