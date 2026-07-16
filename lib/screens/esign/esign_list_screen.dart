import 'package:flutter/material.dart';
import '../../models/signatory.dart';
import '../../theme/app_theme.dart';
import 'esign_import_screen.dart';
import 'billing_dashboard_screen.dart';

/// First screen of the eSign module.
/// Shows "All / Drafts" tabs, Signed/Pending/Failed counters,
/// and an empty state with "Start New eSign".
class EsignListScreen extends StatefulWidget {
  const EsignListScreen({super.key});

  @override
  State<EsignListScreen> createState() => _EsignListScreenState();
}

class _EsignListScreenState extends State<EsignListScreen> {
  int _tabIndex = 0; // 0 = All, 1 = Drafts
  final List<EsignDocument> _documents = [];

  int get _signedCount =>
      _documents.where((d) => d.status == EsignStatus.signed).length;
  int get _pendingCount =>
      _documents.where((d) => d.status == EsignStatus.pending).length;
  int get _failedCount =>
      _documents.where((d) => d.status == EsignStatus.failed).length;

  void _startNewEsign() async {
    final result = await Navigator.push<EsignDocument>(
      context,
      MaterialPageRoute(builder: (_) => const EsignImportScreen()),
    );
    if (result != null) {
      setState(() => _documents.add(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eSign'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.tune), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Billing dashboard',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BillingDashboardScreen(documents: _documents),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTopTabs(),
          _buildStatusRow(),
          const Divider(height: 1),
          Expanded(
            child: _documents.isEmpty ? _buildEmptyState() : _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          _pillTab('All', 0),
          const SizedBox(width: 8),
          _pillTab('Drafts', 1),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('eSign Requests', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _pillTab(String label, int index) {
    final selected = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }

  Widget _buildStatusRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _statusPill('Signed', _signedCount, AppColors.signed),
          const SizedBox(width: 20),
          _statusPill('Pending', _pendingCount, AppColors.pending),
          const SizedBox(width: 20),
          _statusPill('Failed', _failedCount, AppColors.failed),
        ],
      ),
    );
  }

  Widget _statusPill(String label, int count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label ', style: const TextStyle(color: AppColors.textSecondary)),
        Text('$count',
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.description_outlined,
                  size: 40, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            const Text(
              "You haven't signed any documents yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start by uploading a petition or vakalat for eSign.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _startNewEsign,
              icon: const Icon(Icons.add),
              label: const Text('Start New eSign'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(220, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _documents.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final doc = _documents[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.picture_as_pdf, color: AppColors.accent),
            title: Text(doc.title),
            subtitle: Text('${doc.signatories.length} signatory(s)'),
            trailing: StatusChip(
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
          ),
        );
      },
    );
  }
}
