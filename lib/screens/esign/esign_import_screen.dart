import 'package:flutter/material.dart';
import '../../models/signatory.dart';
import '../../theme/app_theme.dart';
import 'signatory_details_screen.dart';

/// "Import Document" - user selects the PDF/petition they want signed.
class EsignImportScreen extends StatelessWidget {
  const EsignImportScreen({super.key});

  Future<void> _pickDocument(BuildContext context) async {
    // TODO: hook up file_picker package here, e.g.:
    // final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    // For now we simulate picking a document.
    final doc = EsignDocument(title: 'Petition document');

    final updatedDoc = await Navigator.push<EsignDocument>(
      context,
      MaterialPageRoute(builder: (_) => SignatoryDetailsScreen(document: doc)),
    );

    if (updatedDoc != null && context.mounted) {
      Navigator.pop(context, updatedDoc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('eSign')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _pickDocument(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.upload_file, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    const Text('Import Document',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Import the document you want your client to sign',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('(Supported format: PDF)',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
