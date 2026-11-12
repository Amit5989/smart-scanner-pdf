import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'camera_scanner_screen.dart';
import 'my_documents_screen.dart';
import 'pdf_tools_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.document_scanner, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'Smart Scanner PDF',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Quick Scan Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Document Scan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Auto edge detection, ML Kit OCR & instant PDF synthesis',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CameraScannerScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2563EB),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.camera_alt_rounded),
                    label: const Text('Start Scanning', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Actions & Tools',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 16),
            // Grid of buttons
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.25,
              children: [
                _buildToolCard(
                  context,
                  title: 'Scan Document',
                  subtitle: 'Camera edge detect',
                  icon: Icons.camera_alt_rounded,
                  color: const Color(0xFF2563EB),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CameraScannerScreen()),
                  ),
                ),
                _buildToolCard(
                  context,
                  title: 'Import Image',
                  subtitle: 'From gallery',
                  icon: Icons.photo_library_rounded,
                  color: const Color(0xFF0284C7),
                  onTap: () async {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null && context.mounted) {
                      // Navigate to edit screen with image
                    }
                  },
                ),
                _buildToolCard(
                  context,
                  title: 'Import PDF',
                  subtitle: 'View or extract',
                  icon: Icons.picture_as_pdf_rounded,
                  color: const Color(0xFF7C3AED),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PdfToolsScreen(initialTab: 0)),
                  ),
                ),
                _buildToolCard(
                  context,
                  title: 'My Documents',
                  subtitle: 'Saved PDF files',
                  icon: Icons.folder_rounded,
                  color: const Color(0xFF059669),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyDocumentsScreen()),
                  ),
                ),
                _buildToolCard(
                  context,
                  title: 'Merge PDF',
                  subtitle: 'Combine documents',
                  icon: Icons.merge_type_rounded,
                  color: const Color(0xFFD97706),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PdfToolsScreen(initialTab: 1)),
                  ),
                ),
                _buildToolCard(
                  context,
                  title: 'Compress PDF',
                  subtitle: 'Reduce file size',
                  icon: Icons.compress_rounded,
                  color: const Color(0xFFE11D48),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PdfToolsScreen(initialTab: 2)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
