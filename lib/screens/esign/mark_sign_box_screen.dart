import 'package:flutter/material.dart';
import '../../models/signatory.dart';
import '../../theme/app_theme.dart';
import 'send_esign_screen.dart';

/// PDF preview + drag-and-drop sign box placement for each signatory.
/// NOTE: the PDF page itself is a placeholder container here — swap in a
/// real PDF renderer (e.g. the `pdfx` or `syncfusion_flutter_pdfviewer`
/// package) and keep the same Stack/Positioned approach for the sign box.
class MarkSignBoxScreen extends StatefulWidget {
  final EsignDocument document;
  const MarkSignBoxScreen({super.key, required this.document});

  @override
  State<MarkSignBoxScreen> createState() => _MarkSignBoxScreenState();
}

class _MarkSignBoxScreenState extends State<MarkSignBoxScreen> {
  late Signatory _active;
  Offset _boxPosition = const Offset(20, 40);
  final double _boxWidth = 110;
  final double _boxHeight = 50;
  final GlobalKey _documentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _active = widget.document.signatories.first;
  }

  void _addSignBox() {
    setState(() => _active.signBoxPlaced = true);
  }

  int get _placedCount =>
      widget.document.signatories.where((s) => s.signBoxPlaced).length;

  void _save() {
    final unplaced =
        widget.document.signatories.where((s) => !s.signBoxPlaced).toList();

    if (unplaced.isNotEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Add Sign Box for Signatory'),
          content: Text(
            'You have not placed fields for:\n\n'
            '${unplaced.map((s) => '${s.name}\n${s.phoneNumber}  ${s.email}').join('\n\n')}\n\n'
            'Signature box placement is mandatory.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SendForEsignScreen(document: widget.document),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Mark Sign Box'),
        actions: [IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.document.signatories.length,
              itemBuilder: (context, index) {
                final s = widget.document.signatories[index];
                final selected = s == _active;
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () => setState(() => _active = s),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              selected ? AppColors.accent : AppColors.primary,
                          child: Text(s.initial),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.name.split(' ').first,
                          style: const TextStyle(fontSize: 11),
                        ),
                        if (s.signBoxPlaced)
                          const Icon(Icons.check_circle,
                              size: 12, color: AppColors.signed),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                key: _documentKey,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const SingleChildScrollView(
                      child: Text(
                        "PRESENTED ON...\n\nBEFORE THE HON'BLE HIGH COURT OF KERALA AT ERNAKULAM\n\n"
                        'PETITIONER(S)\nVERSUS\nRESPONDENT(S)\n\n'
                        'MEMORANDUM OF WRIT PETITION...',
                        style: TextStyle(color: Colors.black87, fontSize: 12),
                      ),
                    ),
                  ),
                  if (_active.signBoxPlaced)
                    Positioned(
                      left: _boxPosition.dx,
                      top: _boxPosition.dy,
                      child: Draggable(
                        feedback: _signBoxWidget(),
                        childWhenDragging: const SizedBox.shrink(),
                        onDragEnd: (details) {
                          final box = _documentKey.currentContext
                              ?.findRenderObject() as RenderBox?;
                          if (box == null) return;
                          setState(() {
                            _boxPosition = box.globalToLocal(details.offset);
                          });
                        },
                        child: _signBoxWidget(),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Total: $_placedCount signing position(s) added for ${_active.name}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _addSignBox,
                    icon: const Icon(Icons.border_color),
                    label: const Text('Add Sign Box'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _signBoxWidget() {
    return Container(
      width: _boxWidth,
      height: _boxHeight,
      decoration: BoxDecoration(
        color: AppColors.signed.withOpacity(0.15),
        border: Border.all(color: AppColors.signed),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        '${_active.name}\nSign Here',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10, color: AppColors.signed),
      ),
    );
  }
}
