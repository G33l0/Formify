import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/document.dart';
import '../core/database/database_helper.dart';
import '../core/constants/app_constants.dart';

// Documents provider
final documentsProvider = StateNotifierProvider<DocumentsNotifier, List<Document>>((ref) {
  return DocumentsNotifier(ref);
});

class DocumentsNotifier extends StateNotifier<List<Document>> {
  DocumentsNotifier(this.ref) : super([]) {
    loadDocuments();
  }

  final Ref ref;
  final _db = DatabaseHelper.instance;

  Future<void> loadDocuments() async {
    final maps = await _db.queryAll('documents');
    state = maps.map((map) => Document.fromMap(map)).toList();
  }

  Future<void> addDocument(Document document) async {
    await _db.insert('documents', document.toMap());
    await loadDocuments();
  }

  Future<void> updateDocument(Document document) async {
    await _db.update('documents', document.toMap());
    await loadDocuments();
  }

  Future<void> deleteDocument(String id) async {
    await _db.delete('documents', id);
    await loadDocuments();
  }

  Future<Document> duplicateDocument(Document original) async {
    final newDocument = Document(
      type: original.type,
      documentNumber: await _generateDocumentNumber(original.type),
      title: '${original.title} (Copy)',
      data: Map.from(original.data),
      totalAmount: original.totalAmount,
      currency: original.currency,
    );

    await addDocument(newDocument);
    return newDocument;
  }

  List<Document> getDocumentsByType(DocumentType type) {
    return state.where((doc) => doc.type == type).toList();
  }

  List<Document> searchDocuments(String query) {
    if (query.isEmpty) return state;

    final lowerQuery = query.toLowerCase();
    return state.where((doc) {
      return doc.title.toLowerCase().contains(lowerQuery) ||
          doc.documentNumber.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<String> _generateDocumentNumber(DocumentType type) async {
    String prefix;
    switch (type) {
      case DocumentType.invoice:
        prefix = AppConstants.invoicePrefix;
        break;
      case DocumentType.receipt:
        prefix = AppConstants.receiptPrefix;
        break;
      case DocumentType.quotation:
        prefix = AppConstants.quotationPrefix;
        break;
      case DocumentType.contract:
      case DocumentType.rentalAgreement:
        prefix = AppConstants.contractPrefix;
        break;
      default:
        prefix = 'DOC';
    }

    final existingDocs = getDocumentsByType(type);
    final count = existingDocs.length;

    return '$prefix-${(count + 1).toString().padLeft(4, '0')}';
  }

  int get totalDocumentCount => state.length;
}
