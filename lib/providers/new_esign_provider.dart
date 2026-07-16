import 'package:flutter/material.dart';
import '../models/signatory_model.dart';

class NewEsignProvider extends ChangeNotifier {
  String? _documentName;
  String? _documentPath;
  final List<SignatoryModel> _signatories = [];

  String? get documentName => _documentName;
  String? get documentPath => _documentPath;
  List<SignatoryModel> get signatories => List.unmodifiable(_signatories);

  void setDocument(String name, String path) {
    _documentName = name;
    _documentPath = path;
    notifyListeners();
  }

  void addSignatory(SignatoryModel signatory) {
    _signatories.add(signatory);
    notifyListeners();
  }

  void removeSignatory(int index) {
    _signatories.removeAt(index);
    notifyListeners();
  }

  void reset() {
    _documentName = null;
    _documentPath = null;
    _signatories.clear();
    notifyListeners();
  }
}