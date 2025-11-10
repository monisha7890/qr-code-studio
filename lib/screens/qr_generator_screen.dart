import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() =>
      _QrGeneratorScreenState();
}

class _QrGeneratorScreenState
    extends State<QrGeneratorScreen> {
  final TextEditingController _textController =
      TextEditingController();
  String _qrData = '';
  bool _showQr = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _generateQr() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some text'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _qrData = _textController.text.trim();
      _showQr = true;
    });

    // Hide keyboard
    FocusScope.of(context).unfocus();
  }

  void _clearQr() {
    setState(() {
      _textController.clear();
      _qrData = '';
      _showQr = false;
    });
  }

  void _shareQr() {
    if (_qrData.isNotEmpty) {
      Share.share('QR Code Content: $_qrData');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate QR Code'),
        elevation: 0,
        backgroundColor: Theme.of(
          context,
        ).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                // Input Card
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.text_fields,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Enter Text',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _textController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText:
                                'Enter text, URL, or any data...',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            focusedBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                        12,
                                      ),
                                  borderSide: BorderSide(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _generateQr,
                                icon: const Icon(
                                  Icons.qr_code,
                                ),
                                label: const Text(
                                  'Generate',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  foregroundColor:
                                      Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                ),
                              ),
                            ),
                            if (_showQr) ...[
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: _clearQr,
                                icon: const Icon(
                                  Icons.clear,
                                ),
                                label: const Text('Clear'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.grey[300],
                                  foregroundColor:
                                      Colors.black87,
                                  padding:
                                      const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 20,
                                      ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // QR Code Display
                if (_showQr) ...[
                  const SizedBox(height: 24),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        16,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Text(
                            'Your QR Code',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(
                              20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(
                                    0,
                                    5,
                                  ),
                                ),
                              ],
                            ),
                            child: QrImageView(
                              data: _qrData,
                              version: QrVersions.auto,
                              size: 250,
                              backgroundColor: Colors.white,
                              errorCorrectionLevel:
                                  QrErrorCorrectLevel.H,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(
                              12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            child: Text(
                              _qrData,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow:
                                  TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _shareQr,
                            icon: const Icon(Icons.share),
                            label: const Text(
                              'Share QR Content',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
