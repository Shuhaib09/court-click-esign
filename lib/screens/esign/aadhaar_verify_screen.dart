import 'package:flutter/material.dart';
import '../../models/signatory.dart';
import '../../theme/app_theme.dart';
import 'esign_complete_screen.dart';

/// Two-step Aadhaar verification: enter Aadhaar number, then enter OTP.
/// NOTE: hook up your real Aadhaar/Digio eSign SDK here — `_verify` and
/// `_confirmOtp` currently simulate network calls with a delay.
class AadhaarVerifyScreen extends StatefulWidget {
  final EsignDocument document;
  const AadhaarVerifyScreen({super.key, required this.document});

  @override
  State<AadhaarVerifyScreen> createState() => _AadhaarVerifyScreenState();
}

class _AadhaarVerifyScreenState extends State<AadhaarVerifyScreen> {
  bool _showOtp = false;
  bool _loading = false;
  final List<TextEditingController> _aadhaarParts =
      List.generate(3, (_) => TextEditingController());
  final List<TextEditingController> _otpDigits =
      List.generate(4, (_) => TextEditingController());

  Future<void> _verify() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _showOtp = true;
    });
  }

  Future<void> _confirmOtp() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => EsignCompleteScreen(document: widget.document),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _aadhaarParts) {
      c.dispose();
    }
    for (final c in _otpDigits) {
      c.dispose();
    }
    super.dispose();
  }

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
          child: _showOtp ? _buildOtpStep() : _buildAadhaarStep(),
        ),
      ),
    );
  }

  Widget _buildAadhaarStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Verify your Aadhaar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        const Text(
          'Please enter your Aadhaar — this is a mandatory process.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 16),
        const Text('Aadhaar Number *', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Row(
          children: List.generate(3, (i) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
                child: TextField(
                  controller: _aadhaarParts[i],
                  maxLength: 4,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  obscureText: i < 2, // mask first two groups like the design
                  decoration: const InputDecoration(counterText: ''),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _loading ? null : _verify,
          child: _loading
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Verify'),
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('OTP Verification',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        const Text(
          'OTP sent to your Aadhar linked mobile number',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 16),
        const Text('Enter OTP', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 6),
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
                child: TextField(
                  controller: _otpDigits[i],
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(counterText: ''),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text("Didn't receive a code? ",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text('Resend code',
                  style: TextStyle(color: AppColors.accent, fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _loading ? null : _confirmOtp,
          child: _loading
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Confirm'),
        ),
      ],
    );
  }
}
