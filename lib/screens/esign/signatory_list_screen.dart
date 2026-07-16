import 'package:flutter/material.dart';
import '../../models/signatory.dart';
import '../../theme/app_theme.dart';
import 'signatory_details_screen.dart';
import 'mark_sign_box_screen.dart';

/// Shows the list of signatories added so far for this document,
/// with the option to add more or continue to sign-box placement.
class SignatoryListScreen extends StatefulWidget {
  final EsignDocument document;
  const SignatoryListScreen({super.key, required this.document});

  @override
  State<SignatoryListScreen> createState() => _SignatoryListScreenState();
}

class _SignatoryListScreenState extends State<SignatoryListScreen> {
  void _addAnother() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignatoryDetailsScreen(document: widget.document),
      ),
    ).then((_) => setState(() {}));
  }

  void _editSignatory(Signatory s) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignatoryDetailsScreen(
          document: widget.document,
          existingSignatory: s,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void _removeSignatory(Signatory s) {
    setState(() => widget.document.signatories.remove(s));
  }

  void _continue() {
    if (widget.document.signatories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one signatory to continue')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MarkSignBoxScreen(document: widget.document),
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
            Card(
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: AppColors.accent),
                title: Text(widget.document.title),
                subtitle: const Text('PDF', style: TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.more_vert),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Signatory List',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                TextButton.icon(
                  onPressed: _addAnother,
                  icon: const Icon(Icons.add_circle, size: 18, color: AppColors.accent),
                  label: const Text('Add Another Signatory',
                      style: TextStyle(color: AppColors.accent)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: widget.document.signatories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final s = widget.document.signatories[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Text(s.initial),
                      ),
                      title: Text(s.name),
                      subtitle: Text('${s.phoneNumber}   ${s.email}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') _editSignatory(s);
                          if (value == 'remove') _removeSignatory(s);
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'remove', child: Text('Remove')),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _continue,
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
