import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'document_edit_screen.dart';

class CameraScannerScreen extends StatefulWidget {
  const CameraScannerScreen({super.key});

  @override
  State<CameraScannerScreen> createState() => _CameraScannerScreenState();
}

class _CameraScannerScreenState extends State<CameraScannerScreen> {
  CameraController? _controller;
  bool _isFlashOn = false;
  bool _isAutoCapture = false;
  final List<XFile> _capturedPages = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );
    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;
    final nextState = !_isFlashOn;
    await _controller!.setFlashMode(nextState ? FlashMode.torch : FlashMode.off);
    setState(() => _isFlashOn = nextState);
  }

  Future<void> _capturePage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final image = await _controller!.takePicture();
    setState(() {
      _capturedPages.add(image);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),

          // Document Edge Overlay Guide
          Positioned.fill(
            child: CustomPaint(
              painter: DocumentGuidePainter(),
            ),
          ),

          // Top Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  _capturedPages.isEmpty
                      ? 'Align Document'
                      : '${_capturedPages.length} Pages Captured',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
                  onPressed: _toggleFlash,
                ),
              ],
            ),
          ),

          // Bottom Bar & Controls
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Live page counter strip
                if (_capturedPages.isNotEmpty)
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _capturedPages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 45,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.file(
                              File(_capturedPages[index].path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Auto / Manual Toggle
                    IconButton(
                      icon: Icon(
                        _isAutoCapture ? Icons.motion_photos_auto : Icons.touch_app,
                        color: _isAutoCapture ? Colors.blue : Colors.white,
                      ),
                      onPressed: () => setState(() => _isAutoCapture = !_isAutoCapture),
                    ),

                    // Shutter Button
                    GestureDetector(
                      onTap: _capturePage,
                      child: Container(
                        width: 76,
                        height: 76,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),

                    // Done / Next to Edit
                    _capturedPages.isNotEmpty
                        ? FloatingActionButton(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue,
                            mini: true,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DocumentEditScreen(pages: _capturedPages),
                                ),
                              );
                            },
                            child: const Icon(Icons.check),
                          )
                        : const SizedBox(width: 48),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DocumentGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(
      size.width * 0.08,
      size.height * 0.15,
      size.width * 0.84,
      size.height * 0.65,
    );

    // Corner guides
    const cornerLength = 28.0;
    // Top-left
    canvas.drawLine(rect.topLeft, rect.topLeft + const Offset(cornerLength, 0), paint);
    canvas.drawLine(rect.topLeft, rect.topLeft + const Offset(0, cornerLength), paint);
    // Top-right
    canvas.drawLine(rect.topRight, rect.topRight - const Offset(cornerLength, 0), paint);
    canvas.drawLine(rect.topRight, rect.topRight + const Offset(0, cornerLength), paint);
    // Bottom-left
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft + const Offset(cornerLength, 0), paint);
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft - const Offset(0, cornerLength), paint);
    // Bottom-right
    canvas.drawLine(rect.bottomRight, rect.bottomRight - const Offset(cornerLength, 0), paint);
    canvas.drawLine(rect.bottomRight, rect.bottomRight - const Offset(0, cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
