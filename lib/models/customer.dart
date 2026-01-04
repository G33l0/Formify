import 'package:uuid/uuid.dart';

class Customer {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? country;
  final String? taxId;
  final DateTime createdAt;

  Customer({
    String? id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.country,
    this.taxId,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'country': country,
      'taxId': taxId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      city: map['city'],
      country: map['country'],
      taxId: map['taxId'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Customer copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? taxId,
  }) {
    return Customer(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      taxId: taxId ?? this.taxId,
      createdAt: createdAt,
    );
  }
}
