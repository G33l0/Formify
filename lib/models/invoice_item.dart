class InvoiceItem {
  final String description;
  final int quantity;
  final double rate;
  final double taxPercent;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.rate,
    this.taxPercent = 0.0,
  });

  double get subtotal => quantity * rate;
  double get taxAmount => subtotal * (taxPercent / 100);
  double get total => subtotal + taxAmount;

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'quantity': quantity,
      'rate': rate,
      'taxPercent': taxPercent,
    };
  }

  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      description: map['description'],
      quantity: map['quantity'],
      rate: map['rate'],
      taxPercent: map['taxPercent'] ?? 0.0,
    );
  }

  InvoiceItem copyWith({
    String? description,
    int? quantity,
    double? rate,
    double? taxPercent,
  }) {
    return InvoiceItem(
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      rate: rate ?? this.rate,
      taxPercent: taxPercent ?? this.taxPercent,
    );
  }
}
