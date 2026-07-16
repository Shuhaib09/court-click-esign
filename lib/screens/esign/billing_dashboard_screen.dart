import 'package:flutter/material.dart';
import '../../models/signatory.dart';
import '../../theme/app_theme.dart';
import 'aadhaar_consent_screen.dart';

/// Client-facing dashboard: shows documents invited to sign,
/// plus an eSign History tab split into Pending / Signed / Failed.
class BillingDashboardScreen extends StatefulWidget {
  final List<EsignDocument> documents;
  const BillingDashboardScreen({super.key, required this.documents});

  @override
  State<BillingDashboardScreen> createState() => _BillingDashboardScreenState();
}

class _BillingDashboardScreenState extends State<BillingDashboardScreen> {
  EsignStatus? _filter; // null = show invitations view

  List<EsignDocument> get _filtered => _filter == null
      ? widget.documents
      : widget.documents.where((d) => d.status == _filter).toList();

  void _openSignFlow(EsignDocument doc) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AadhaarConsentScreen(document: doc)),
    );
    if (result == true) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(_filter == null ? "You've been invited to e-Sign" : 'eSign History'),
      ),
      body: Column(
        children: [
          if (_filter != null) _buildStatusTabs(),
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text('No documents yet',
                        style: TextStyle(color: AppColors.textSecondary)))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) => _documentCard(_filtered[index]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextButton(
            onPressed: () => setState(() => _filter = _filter == null ? EsignStatus.pending : null),
            child: Text(_filter == null ? 'View eSign History' : 'View Invitations'),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTabs() {
    final pending = widget.documents.where((d) => d.status == EsignStatus.pending).length;
    final signed = widget.documents.where((d) => d.status == EsignStatus.signed).length;
    final failed = widget.documents.where((d) => d.status == EsignStatus.failed).length;

    Widget tab(String label, int count, EsignStatus status) {
      final selected = _filter == status;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _filter = status),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text('$label $count',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          tab('Pending', pending, EsignStatus.pending),
          tab('Signed', signed, EsignStatus.signed),
          tab('Failed', failed, EsignStatus.failed),
        ],
      ),
    );
  }

  Widget _documentCard(EsignDocument doc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.picture_as_pdf, color: AppColors.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(doc.title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                const Icon(Icons.more_vert, size: 18),
              ],
            ),
            const Divider(height: 24),
            _row('Type', doc.type),
            _row('Initiated By', doc.initiatedBy),
            _row('Date Signed', doc.dateSigned),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Status', style: TextStyle(color: AppColors.textSecondary)),
                  StatusChip(
                    label: doc.status == EsignStatus.signed
                        ? 'Signed'
                        : doc.status == EsignStatus.failed
                            ? 'Failed'
                            : 'Pending',
                    color: doc.status == EsignStatus.signed
                        ? AppColors.signed
                        : doc.status == EsignStatus.failed
                            ? AppColors.failed
                            : AppColors.pending,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (doc.status == EsignStatus.signed)
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Download Copy'),
              )
            else ...[
              OutlinedButton(
                onPressed: () {},
                child: const Text('View Petition'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _openSignFlow(doc),
                icon: const Icon(Icons.edit_document, size: 18),
                label: const Text('Sign Document'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
