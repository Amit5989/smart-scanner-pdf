import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'pdf_generator_screen.dart';

class DocumentEditScreen extends StatefulWidget {
  final List<XFile> pages;
  const DocumentEditScreen({super.key, required this.pages});

  @override
  State<DocumentEditScreen> createState() => _DocumentEditScreenState();
}

class _DocumentEditScreenState extends State<DocumentEditScreen> {
  int _currentIndex = 0;
  int _rotation = 0;
  String _activeFilter = 'original'; // original, magic, grayscale, bw

  @override
  Widget build(BuildContext context) {
    final currentPage = widget.pages[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: Text('Page ${_currentIndex + 1} of ${widget.pages.length}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              if (widget.pages.length > 1) {
                setState(() {
                  widget.pages.removeAt(_currentIndex);
                  if (_currentIndex >= widget.pages.length) {
                    _currentIndex = widget.pages.length - 1;
                  }
                });
              }
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfGeneratorScreen(pages: widget.pages),
                ),
              );
            },
            child: const Text('Next', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: RotatedBox(
                quarterTurns: _rotation ~/ 90,
                child: ColorFiltered(
                  colorFilter: _getFilter(),
                  child: Image.file(
                    File(currentPage.path),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Filter Selection & Controls Bar
          Container(
            color: const Color(0xFF1E293B),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _filterBtn('Original', 'original'),
                    _filterBtn('Magic Color', 'magic'),
                    _filterBtn('Grayscale', 'grayscale'),
                    _filterBtn('B&W', 'bw'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.rotate_right, color: Colors.white),
                      onPressed: () => setState(() => _rotation = (_rotation + 90) % 360),
                    ),
                    IconButton(
                      icon: const Icon(Icons.crop, color: Colors.white),
                      onPressed: () {
                        // Open crop handles
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.draw, color: Colors.white),
                      onPressed: () {
                        // Add electronic signature
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterBtn(String label, String key) {
    final isSelected = _activeFilter == key;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.blue : Colors.white24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  ColorFilter _getFilter() {
    switch (_activeFilter) {
      case 'grayscale':
        return const ColorFilter.mode(Colors.grey, BlendMode.saturation);
      case 'bw':
        return const ColorFilter.matrix([
          1.5, 1.5, 1.5, 0, -250,
          1.5, 1.5, 1.5, 0, -250,
          1.5, 1.5, 1.5, 0, -250,
          0, 0, 0, 1, 0,
        ]);
      default:
        return const ColorFilter.mode(Colors.transparent, BlendMode.dst);
    }
  }
}
