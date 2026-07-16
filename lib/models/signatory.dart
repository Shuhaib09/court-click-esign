enum Gender { male, female, other }

/// Represents one signatory added to a document (Robin D, Ajith, Jesbin, etc).
class Signatory {
  String name;
  Gender gender;
  String companyName;
  String phoneNumber;
  String email;
  bool signBoxPlaced;

  Signatory({
    required this.name,
    this.gender = Gender.male,
    this.companyName = '',
    required this.phoneNumber,
    required this.email,
    this.signBoxPlaced = false,
  });

  String get initial => name.isNotEmpty ? name[0].toUpperCase() : '?';
}

enum EsignStatus { pending, signed, failed }

/// Represents a document going through the eSign flow
/// (e.g. "Robin D/Petition/01_July_2025").
class EsignDocument {
  final String title;
  final String type;
  final String initiatedBy;
  String dateSigned;
  EsignStatus status;
  final List<Signatory> signatories;

  EsignDocument({
    required this.title,
    this.type = 'Petition',
    this.initiatedBy = 'Vinayak Ram',
    this.dateSigned = '--/--/----',
    this.status = EsignStatus.pending,
    List<Signatory>? signatories,
  }) : signatories = signatories ?? [];
}
