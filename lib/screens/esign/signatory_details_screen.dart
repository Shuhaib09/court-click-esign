import 'package:flutter/material.dart';
import '../../models/signatory.dart';
import '../../theme/app_theme.dart';
import 'signatory_list_screen.dart';

/// Form for entering one signatory's details:
/// name, gender, company name, phone number, email.
class SignatoryDetailsScreen extends StatefulWidget {
  final EsignDocument document;
  final Signatory? existingSignatory; // non-null when editing

  SignatoryDetailsScreen({
    super.key,
    EsignDocument? document,
    this.existingSignatory,
  }) : document = document ?? EsignDocument(title: 'Petition document');
  @override
  State<SignatoryDetailsScreen> createState() =>
      _SignatoryDetailsScreenState();
}

class _SignatoryDetailsScreenState extends State<SignatoryDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _companyController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  Gender _gender = Gender.male;

  @override
  void initState() {
    super.initState();
    final s = widget.existingSignatory;
    _nameController = TextEditingController(text: s?.name ?? '');
    _companyController = TextEditingController(text: s?.companyName ?? '');
    _phoneController = TextEditingController(text: s?.phoneNumber ?? '');
    _emailController = TextEditingController(text: s?.email ?? '');
    _gender = s?.gender ?? Gender.male;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _importFromContacts() {
    // TODO: hook up contacts_service / flutter_contacts package here.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contacts import not wired up yet')),
    );
  }

  void _saveAndContinue() {
    if (!_formKey.currentState!.validate()) return;

    final signatory = Signatory(
      name: _nameController.text.trim(),
      gender: _gender,
      companyName: _companyController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      email: _emailController.text.trim(),
    );

    if (widget.existingSignatory != null) {
      // Editing: replace in place.
      final idx = widget.document.signatories.indexOf(widget.existingSignatory!);
      if (idx != -1) widget.document.signatories[idx] = signatory;
    } else {
      widget.document.signatories.add(signatory);
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SignatoryListScreen(document: widget.document),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Back'), leading: const BackButton()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Signatory Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              _label('Signatory Name (Name of the litigant who will eSign) *'),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: "Enter/Choose Client's Name"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 18),
              _label('Gender'),
              Row(
                children: [
                  _genderRadio('Male', Gender.male),
                  _genderRadio('Female', Gender.female),
                  _genderRadio('Other', Gender.other),
                ],
              ),
              const SizedBox(height: 18),
              _label('Company Name (if applicable)'),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(hintText: 'Enter Company Name'),
              ),
              const SizedBox(height: 24),
              const Text('Contact details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _importFromContacts,
                icon: const Icon(Icons.contacts_outlined),
                label: const Text('Import from contacts'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Client mobile number, email can be imported from your device contacts',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 18),
              _label('Signatory Phone Number *'),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixText: '+91  ',
                  hintText: '9876543210',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 18),
              _label('Signatory Email Address'),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter Email'),
              ),
              const SizedBox(height: 32),
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
                      onPressed: _saveAndContinue,
                      child: const Text('Save & Continue'),
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

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      );

  Widget _genderRadio(String label, Gender value) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<Gender>(
            value: value,
            groupValue: _gender,
            activeColor: AppColors.accent,
            onChanged: (v) => setState(() => _gender = v!),
          ),
          Text(label),
        ],
      ),
    );
  }
}
