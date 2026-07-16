import 'package:flutter/material.dart';
import '../../models/signatory.dart';
import '../../theme/app_theme.dart';
import 'payment_screen.dart';

/// "Consent for Aadhaar e-Sign" step, shown before the client is
/// redirected to Digio (or similar licensed eSign provider).
class AadhaarConsentScreen extends StatefulWidget {
  final EsignDocument document;
  const AadhaarConsentScreen({super.key, required this.document});

  @override
  State<AadhaarConsentScreen> createState() => _AadhaarConsentScreenState();
}

class _AadhaarConsentScreenState extends State<AadhaarConsentScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Consent for Aadhaar e-Sign',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'To sign this document digitally, we\'ll redirect you to Digio '
                '(a licensed eSign provider). A secure OTP will be sent to your '
                'Aadhaar-linked mobile number.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreed,
                    activeColor: AppColors.accent,
                    onChanged: (v) => setState(() => _agreed = v ?? false),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        'I understand and agree to use Aadhaar e-Sign for this document.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const _bullet('Your Aadhaar number is never stored'),
              const _bullet('Aadhaar e-Sign is legally valid under the IT Act, 2000.'),
              const _bullet('The process takes less than a minute.'),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _agreed
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PaymentScreen(document: widget.document),
                                ),
                              );
                            }
                          : null,
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _bullet extends StatelessWidget {
  final String text;
  const _bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(color: AppColors.textSecondary)),
          Expanded(
            child: Text(text,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
