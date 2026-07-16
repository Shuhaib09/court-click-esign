import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/new_esign_provider.dart';
import 'signatory_details_screen.dart';

class ImportDocumentScreen extends StatefulWidget {
  const ImportDocumentScreen({super.key});

  @override
  State<ImportDocumentScreen> createState() => _ImportDocumentScreenState();
}

class _ImportDocumentScreenState extends State<ImportDocumentScreen> {
  bool _isPicking = false;
  String? _errorMessage;

  Future<void> _pickDocument() async {
    setState(() {
      _isPicking = true;
      _errorMessage = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.isEmpty) {
        setState(() => _isPicking = false);
        return; // user cancelled
      }

      final file = result.files.first;
      if (!mounted) return;

      context.read<NewEsignProvider>().setDocument(file.name, file.path ?? '');

      setState(() => _isPicking = false);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SignatoryDetailsScreen()),
      );
    } catch (e) {
      setState(() {
        _isPicking = false;
        _errorMessage = 'Could not import document. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Document')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.upload_file, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 20),
            const Text(
              'Import the document you want\nyour client to sign',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 6),
            const Text(
              '(Supported format: PDF)',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_errorMessage!, style: const TextStyle(color: AppColors.failed)),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isPicking ? null : _pickDocument,
                icon: _isPicking
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.add, size: 18),
                label: Text(_isPicking ? 'Importing...' : 'Import Document'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}