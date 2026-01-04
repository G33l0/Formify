import 'package:uuid/uuid.dart';

class BusinessProfile {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? country;
  final String? taxId;
  final String? logo; // Base64 encoded image or path
  final bool isDefault;
  final DateTime createdAt;

  BusinessProfile({
    String? id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.country,
    this.taxId,
    this.logo,
    this.isDefault = false,
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
      'logo': logo,
      'isDefault': isDefault ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BusinessProfile.fromMap(Map<String, dynamic> map) {
    return BusinessProfile(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      city: map['city'],
      country: map['country'],
      taxId: map['taxId'],
      logo: map['logo'],
      isDefault: map['isDefault'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  BusinessProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? taxId,
    String? logo,
    bool? isDefault,
  }) {
    return BusinessProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      taxId: taxId ?? this.taxId,
      logo: logo ?? this.logo,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt,
    );
  }
}
