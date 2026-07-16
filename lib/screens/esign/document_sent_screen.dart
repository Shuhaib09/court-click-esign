import 'package:flutter/material.dart';
import '../../models/signatory.dart';
import '../../theme/app_theme.dart';
import 'esign_list_screen.dart';

/// Confirmation screen shown right after sending the document for eSign.
class DocumentSentScreen extends StatelessWidget {
  final EsignDocument document;
  const DocumentSentScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back'),
        leading: const BackButton(),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, size: 18),
            label: const Text('Need Help'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.signed,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 20),
            const Text('Document sent to client',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text(
              'Petition sent to client for payment and eSign, they’ll get a secure link',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            const Text('or', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            const Text('You can share it directly below.',
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share_outlined, size: 18),
              label: const Text('Share'),
              style: OutlinedButton.styleFrom(minimumSize: const Size(140, 44)),
            ),
            const SizedBox(height: 28),
            Card(
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: AppColors.accent),
                title: Text(document.title),
              ),
            ),
            const SizedBox(height: 12),
            _infoRow('Type', 'Document'),
            _infoRow('To Be Signed By',
                document.signatories.isNotEmpty ? document.signatories.first.name : '-'),
            _infoRow('Status', 'Pending', valueColor: AppColors.pending),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const EsignListScreen()),
                (route) => false,
              ),
              child: const Text('Back To Dashboard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value,
              style: TextStyle(
                  color: valueColor ?? Colors.white,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
