import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

class MyDocumentsScreen extends StatefulWidget {
  const MyDocumentsScreen({super.key});

  @override
  State<MyDocumentsScreen> createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<MyDocumentsScreen> {
  List<FileSystemEntity> _files = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    setState(() => _isLoading = true);
    final dir = await getApplicationDocumentsDirectory();
    final allEntities = dir.listSync();
    final pdfFiles = allEntities.where((e) => e.path.endsWith('.pdf')).toList();
    pdfFiles.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    setState(() {
      _files = pdfFiles;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _files.where((f) {
      final name = f.path.split('/').last.toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Documents'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search documents...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
              ),
              onChanged: (q) => setState(() => _searchQuery = q),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? const Center(child: Text('No saved documents found.'))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final file = File(filtered[index].path);
                          final name = file.path.split('/').last;
                          final size = (file.lengthSync() / 1024).toStringAsFixed(1);

                          return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2563EB).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.picture_as_pdf, color: Color(0xFF2563EB)),
                            ),
                            title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${size} KB • ${file.lastModifiedSync().toString().substring(0, 16)}'),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(value: 'open', child: Text('Open / Preview')),
                                const PopupMenuItem(value: 'share', child: Text('Share PDF')),
                                const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                              ],
                              onSelected: (val) async {
                                if (val == 'open') {
                                  OpenFilex.open(file.path);
                                } else if (val == 'share') {
                                  Share.shareXFiles([XFile(file.path)]);
                                } else if (val == 'delete') {
                                  await file.delete();
                                  _loadDocuments();
                                }
                              },
                            ),
                            onTap: () => OpenFilex.open(file.path),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
