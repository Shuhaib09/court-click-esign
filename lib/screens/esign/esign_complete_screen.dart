import 'package:flutter/material.dart';
import '../../models/signatory.dart';
import '../../theme/app_theme.dart';

/// Shown once Aadhaar OTP verification succeeds — the document is now signed.
/// Pops back to the billing dashboard, marking the document as Signed.
class EsignCompleteScreen extends StatelessWidget {
  final EsignDocument document;
  const EsignCompleteScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    // Mark the document as signed now that the flow has completed.
    document.status = EsignStatus.signed;
    document.dateSigned = _todayFormatted();

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: AppColors.signed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 20),
              const Text(
                'eSign process completed successfully',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Download PDF'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context)
                    .popUntil((route) => route.isFirst),
                child: const Text('Back to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _todayFormatted() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }
}
