import 'package:flutter/material.dart';
import '../../models/signatory.dart';
import '../../theme/app_theme.dart';
import 'document_sent_screen.dart';

/// Final review before sending: lists each signatory with their
/// placed sign box status and an "Edit Sign Box" shortcut.
class SendForEsignScreen extends StatelessWidget {
  final EsignDocument document;
  const SendForEsignScreen({super.key, required this.document});

  void _send(BuildContext context) {
    document.status = EsignStatus.pending;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentSentScreen(document: document),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Back'), leading: const BackButton()),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a signatory and place their e-Sign fields on the document.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: document.signatories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final s = document.signatories[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        s.signBoxPlaced
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: s.signBoxPlaced
                            ? AppColors.signed
                            : AppColors.textSecondary,
                      ),
                      title: Text(s.name),
                      subtitle: Text('${s.phoneNumber}   ${s.email}'),
                      trailing: TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.edit_document, size: 16),
                        label: const Text('Edit Sign Box'),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _send(context),
              child: const Text('Send for eSign'),
            ),
          ],
        ),
      ),
    );
  }
}
