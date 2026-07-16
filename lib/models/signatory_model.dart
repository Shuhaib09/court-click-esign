enum Gender { male, female, other }

class SignatoryModel {
  final String name;
  final Gender gender;
  final String companyName;
  final String phoneNumber;
  final String email;

  SignatoryModel({
    required this.name,
    required this.gender,
    this.companyName = '',
    required this.phoneNumber,
    required this.email,
  });
}