import 'package:flutter/material.dart';

/// Interactive concept map widget with zoom and pan capabilities
class ConceptMapWidget extends StatefulWidget {
  final Map<String, List<String>> conceptMap;
  final Function(String concept)? onConceptTap;

  const ConceptMapWidget({
    super.key,
    required this.conceptMap,
    this.onConceptTap,
  });

  @override
  State<ConceptMapWidget> createState() => _ConceptMapWidgetState();
}

class _ConceptMapWidgetState extends State<ConceptMapWidget> {
  final TransformationController _transformationController = TransformationController();
  
  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.conceptMap.isEmpty) {
      return const Center(
        child: Text(
          'No concept map available',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Container(
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.5,
              maxScale: 3.0,
              constrained: false,
              child: Container(
                width: 800,
                height: 600,
                padding: const EdgeInsets.all(40),
                child: CustomPaint(
                  painter: ConceptMapPainter(
                    conceptMap: widget.conceptMap,
                    onConceptTap: widget.onConceptTap,
                  ),
                  child: _buildConceptNodes(),
                ),
              ),
            ),
            // Zoom controls
            Positioned(
              top: 10,
              right: 10,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: "zoom_in",
                    onPressed: _zoomIn,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.zoom_in, color: Color(0xFF7846EC)),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: "zoom_out",
                    onPressed: _zoomOut,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.zoom_out, color: Color(0xFF7846EC)),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: "reset_zoom",
                    onPressed: _resetZoom,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.center_focus_strong, color: Color(0xFF7846EC)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptNodes() {
    final concepts = widget.conceptMap.entries.toList();
    if (concepts.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: [
        // Central concept
        Positioned(
          left: 350,
          top: 250,
          child: _buildConceptNode(
            concepts.first.key,
            isCenter: true,
          ),
        ),
        // Connected concepts
        ...concepts.first.value.asMap().entries.map((entry) {
          final index = entry.key;
          final concept = entry.value;
          final angle = (index * 2 * 3.14159) / concepts.first.value.length;
          final radius = 150.0;
          final x = 350 + radius * cos(angle);
          final y = 250 + radius * sin(angle);
          
          return Positioned(
            left: x,
            top: y,
            child: _buildConceptNode(concept),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildConceptNode(String concept, {bool isCenter = false}) {
    return GestureDetector(
      onTap: () => widget.onConceptTap?.call(concept),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isCenter ? const Color(0xFF7846EC) : Colors.white,
          border: Border.all(
            color: const Color(0xFF7846EC),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          concept,
          style: TextStyle(
            color: isCenter ? Colors.white : const Color(0xFF7846EC),
            fontWeight: FontWeight.bold,
            fontSize: isCenter ? 16 : 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _zoomIn() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale < 3.0) {
      _transformationController.value = Matrix4.identity()..scale(currentScale * 1.2);
    }
  }

  void _zoomOut() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale > 0.5) {
      _transformationController.value = Matrix4.identity()..scale(currentScale * 0.8);
    }
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  double cos(double radians) => math.cos(radians);
  double sin(double radians) => math.sin(radians);
}

class ConceptMapPainter extends CustomPainter {
  final Map<String, List<String>> conceptMap;
  final Function(String)? onConceptTap;

  ConceptMapPainter({
    required this.conceptMap,
    this.onConceptTap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (conceptMap.isEmpty) return;

    final paint = Paint()
      ..color = const Color(0xFF7846EC).withOpacity(0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final concepts = conceptMap.entries.first;
    final centerX = 400.0;
    final centerY = 300.0;
    final radius = 150.0;

    // Draw lines from center to connected concepts
    for (int i = 0; i < concepts.value.length; i++) {
      final angle = (i * 2 * 3.14159) / concepts.value.length;
      final endX = centerX + radius * math.cos(angle);
      final endY = centerY + radius * math.sin(angle);

      canvas.drawLine(
        Offset(centerX, centerY),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Import math for trigonometric functions
import 'dart:math' as math;