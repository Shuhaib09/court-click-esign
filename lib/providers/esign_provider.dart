import 'package:flutter/material.dart';
import '../models/document_model.dart';

enum ViewState { loading, loaded, error }

class EsignProvider extends ChangeNotifier {
  ViewState _state = ViewState.loading;
  List<DocumentModel> _documents = [];
  String _errorMessage = '';

  ViewState get state => _state;
  List<DocumentModel> get documents => _documents;
  String get errorMessage => _errorMessage;

  int get signedCount =>
      _documents.where((d) => d.status == DocumentStatus.signed).length;
  int get pendingCount =>
      _documents.where((d) => d.status == DocumentStatus.pending).length;
  int get failedCount =>
      _documents.where((d) => d.status == DocumentStatus.failed).length;

  // Simulates fetching documents (later you can swap this for a real API call)
  Future<void> fetchDocuments() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800)); // simulate network

      // Start empty, matching your Figma's empty state.
      // Change this to sample data later to test the "loaded" state.
      _documents = [];

      _state = ViewState.loaded;
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
      _state = ViewState.error;
    }
    notifyListeners();
  }
}