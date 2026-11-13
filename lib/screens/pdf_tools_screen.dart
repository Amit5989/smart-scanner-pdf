import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PdfToolsScreen extends StatefulWidget {
  final int initialTab;
  const PdfToolsScreen({super.key, this.initialTab = 0});

  @override
  State<PdfToolsScreen> createState() => _PdfToolsScreenState();
}

class _PdfToolsScreenState extends State<PdfToolsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Utilities'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Merge PDF'),
            Tab(text: 'Compress PDF'),
            Tab(text: 'Extract Images'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMergeTab(),
          _buildCompressTab(),
          _buildExtractTab(),
        ],
      ),
    );
  }

  Widget _buildMergeTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.merge_type_rounded, size: 64, color: Color(0xFF2563EB)),
            const SizedBox(height: 16),
            const Text('Merge Multiple PDF Files', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Select 2 or more PDF documents to combine into a single PDF.', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Select PDF Documents'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompressTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.compress_rounded, size: 64, color: Color(0xFFE11D48)),
            const SizedBox(height: 16),
            const Text('Compress PDF File', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Reduce PDF file size by optimizing document streams and images.', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.folder_open),
              label: const Text('Choose File to Compress'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtractTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.photo_library_rounded, size: 64, color: Color(0xFF7C3AED)),
            const SizedBox(height: 16),
            const Text('Extract High-Resolution Images', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Render PDF pages into crystal-clear JPEG / PNG image files.', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.image),
              label: const Text('Select PDF File'),
            ),
          ],
        ),
      ),
    );
  }
}
