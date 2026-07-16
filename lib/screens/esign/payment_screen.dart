import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/signatory.dart';
import '../../theme/app_theme.dart';
import 'aadhaar_verify_screen.dart';

/// "Payment Required" -> processing -> success, before Aadhaar verification.
/// NOTE: wire up your real payment gateway SDK (Razorpay/Stripe/etc) where
/// `_payNow` currently just simulates a delay.
class PaymentScreen extends StatefulWidget {
  final EsignDocument document;
  const PaymentScreen({super.key, required this.document});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

enum _PayState { required, processing, success }

class _PaymentScreenState extends State<PaymentScreen> {
  _PayState _state = _PayState.required;
  final String _referenceNumber = '000085752257';

  Future<void> _payNow() async {
    setState(() => _state = _PayState.processing);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _state = _PayState.success);
  }

  void _proceedToVerification() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AadhaarVerifyScreen(document: widget.document),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM d, yyyy').format(DateTime.now());

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
          child: _state == _PayState.required
              ? _buildRequired()
              : _buildReceipt(dateStr),
        ),
      ),
    );
  }

  Widget _buildRequired() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Payment Required!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accent, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('eSign Petition', style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text('• Request certified true copy of 01 Judgement and 03 Interim orders',
                  style: TextStyle(fontSize: 12)),
              Text('• Get updates when your certified copy is ready', style: TextStyle(fontSize: 12)),
              Text('• Get updates on this case for 12 months', style: TextStyle(fontSize: 12)),
              SizedBox(height: 8),
              Text('₹1500', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _payNow,
                child: const Text('Make Payment'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReceipt(String dateStr) {
    final isProcessing = _state == _PayState.processing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isProcessing ? Icons.access_time : Icons.check_circle,
                  color: isProcessing ? AppColors.pending : AppColors.signed,
                ),
                const SizedBox(width: 8),
                Text(isProcessing ? 'Payment Processing!' : 'Payment Success',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        if (isProcessing) ...[
          const SizedBox(height: 8),
          const Text(
            "If the amount has been deducted but your plan isn't active yet, "
            "don't worry — sometimes it takes a few minutes to reflect.\n\n"
            "We'll notify you of the status within 1 hour.",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
        const SizedBox(height: 16),
        _receiptRow('References Number', _referenceNumber),
        _receiptRow('Date', dateStr),
        _receiptRow('Time', TimeOfDay.now().format(context)),
        _receiptRow('Payment Method', 'Credit Card'),
        const Divider(height: 24),
        _receiptRow('Amount', 'INR 1,000.00', bold: true),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _proceedToVerification,
                child: const Text('Sign Document'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _receiptRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Text(value,
              style: TextStyle(
                  fontSize: bold ? 16 : 13,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w600)),
        ],
      ),
    );
  }
}
