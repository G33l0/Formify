import 'dart:convert';
import 'package:uuid/uuid.dart';

enum DocumentType {
  invoice,
  receipt,
  quotation,
  resume,
  coverLetter,
  contract,
  rentalAgreement,
  businessProposal,
  meetingMinutes,
  paymentReminder,
  letter,
}

extension DocumentTypeExtension on DocumentType {
  String get name {
    switch (this) {
      case DocumentType.invoice:
        return 'Invoice';
      case DocumentType.receipt:
        return 'Receipt';
      case DocumentType.quotation:
        return 'Quotation';
      case DocumentType.resume:
        return 'Resume';
      case DocumentType.coverLetter:
        return 'Cover Letter';
      case DocumentType.contract:
        return 'Contract';
      case DocumentType.rentalAgreement:
        return 'Rental Agreement';
      case DocumentType.businessProposal:
        return 'Business Proposal';
      case DocumentType.meetingMinutes:
        return 'Meeting Minutes';
      case DocumentType.paymentReminder:
        return 'Payment Reminder';
      case DocumentType.letter:
        return 'Letter';
    }
  }

  String get icon {
    switch (this) {
      case DocumentType.invoice:
        return '📄';
      case DocumentType.receipt:
        return '🧾';
      case DocumentType.quotation:
        return '💼';
      case DocumentType.resume:
        return '📋';
      case DocumentType.coverLetter:
        return '✉️';
      case DocumentType.contract:
        return '📝';
      case DocumentType.rentalAgreement:
        return '🏠';
      case DocumentType.businessProposal:
        return '📊';
      case DocumentType.meetingMinutes:
        return '⏰';
      case DocumentType.paymentReminder:
        return '💰';
      case DocumentType.letter:
        return '📨';
    }
  }
}

class Document {
  final String id;
  final DocumentType type;
  final String documentNumber;
  final String title;
  final Map<String, dynamic> data;
  final double totalAmount;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  Document({
    String? id,
    required this.type,
    required this.documentNumber,
    required this.title,
    required this.data,
    this.totalAmount = 0.0,
    this.currency = 'USD',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString(),
      'documentNumber': documentNumber,
      'title': title,
      'data': jsonEncode(data),
      'totalAmount': totalAmount,
      'currency': currency,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'],
      type: DocumentType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => DocumentType.invoice,
      ),
      documentNumber: map['documentNumber'],
      title: map['title'],
      data: jsonDecode(map['data']),
      totalAmount: map['totalAmount'],
      currency: map['currency'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Document copyWith({
    DocumentType? type,
    String? documentNumber,
    String? title,
    Map<String, dynamic>? data,
    double? totalAmount,
    String? currency,
  }) {
    return Document(
      id: id,
      type: type ?? this.type,
      documentNumber: documentNumber ?? this.documentNumber,
      title: title ?? this.title,
      data: data ?? this.data,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
