import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'home_screen.dart';

class PdfGeneratorScreen extends StatefulWidget {
  final List<XFile> pages;
  const PdfGeneratorScreen({super.key, required this.pages});

  @override
  State<PdfGeneratorScreen> createState() => _PdfGeneratorScreenState();
}

class _PdfGeneratorScreenState extends State<PdfGeneratorScreen> {
  final TextEditingController _titleController = TextEditingController();
  PdfPageFormat _pageFormat = PdfPageFormat.a4;
  String _quality = 'High (85%)';
  bool _includeWatermark = false;
  final TextEditingController _watermarkController = TextEditingController(text: 'CONFIDENTIAL');
  bool _isGenerating = false;
  String? _savedFilePath;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _titleController.text = 'Scan_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour}${now.minute}';
  }

  Future<File> _generatePdf() async {
    final pdf = pw.Document(
      title: _titleController.text,
      author: 'Smart Scanner PDF',
    );

    for (final page in widget.pages) {
      final imageBytes = await File(page.path).readAsBytes();
      final image = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: _pageFormat,
          build: (pw.Context context) {
            return pw.Stack(
              children: [
                pw.Center(
                  child: pw.Image(image, fit: pw.BoxFit.contain),
                ),
                if (_includeWatermark)
                  pw.Center(
                    child: pw.Transform.rotate(
                      angle: -0.5,
                      child: pw.Text(
                        _watermarkController.text,
                        style: pw.TextStyle(
                          color: PdfColors.grey400,
                          fontSize: 48,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      );
    }

    final outputDir = await getApplicationDocumentsDirectory();
    final filePath = '${outputDir.path}/${_titleController.text}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> _saveAndFinish() async {
    setState(() => _isGenerating = true);
    try {
      final file = await _generatePdf();
      setState(() {
        _savedFilePath = file.path;
        _isGenerating = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved to ${file.path}'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Share',
              textColor: Colors.white,
              onPressed: () => Share.shareXFiles([XFile(file.path)]),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isGenerating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate PDF: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveAndFinish,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Document Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixText: '.pdf',
              ),
            ),
            const SizedBox(height: 20),
            const Text('Page Format', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<PdfPageFormat>(
              segments: const [
                ButtonSegment(value: PdfPageFormat.a4, label: Text('A4')),
                ButtonSegment(value: PdfPageFormat.letter, label: Text('Letter')),
                ButtonSegment(value: PdfPageFormat.legal, label: Text('Legal')),
              ],
              selected: {_pageFormat},
              onSelectionChanged: (set) => setState(() => _pageFormat = set.first),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Add Watermark'),
              value: _includeWatermark,
              onChanged: (val) => setState(() => _includeWatermark = val),
            ),
            if (_includeWatermark)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(
                  controller: _watermarkController,
                  decoration: InputDecoration(
                    labelText: 'Watermark Text',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isGenerating ? null : _saveAndFinish,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: _isGenerating
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.picture_as_pdf),
              label: Text(_isGenerating ? 'Compiling PDF...' : 'Save PDF to Device'),
            ),
          ],
        ),
      ),
    );
  }
}
