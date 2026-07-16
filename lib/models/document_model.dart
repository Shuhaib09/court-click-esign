enum DocumentStatus { pending, signed, failed }

class DocumentModel {
  final String id;
  final String title;       // e.g. "Robin D/Petition/01_July_2025"
  final String type;        // e.g. "Petition"
  final String initiatedBy;
  final DateTime? dateSigned;
  final DocumentStatus status;

  DocumentModel({
    required this.id,
    required this.title,
    required this.type,
    required this.initiatedBy,
    this.dateSigned,
    required this.status,
  });
}