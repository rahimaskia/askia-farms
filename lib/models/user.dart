import 'dart:convert';

import 'address.dart';

class User {
  final String name;
  final String? phone;
  final String email;
  final Address? address;
  User({
    required this.name,
    this.phone,
    required this.email,
    this.address,
  });

  User copyWith({
    String? name,
    String? phone,
    String? email,
    Address? address,
  }) {
    return User(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'email': email,
      'address': address?.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      phone: map['phone'] as String?,
      email: map['email'] as String,
      address: map['address'] != null
          ? Address.fromMap(map['address'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '''
Customer(name: $name, phone: $phone, email: $email, address: $address)''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.name == name &&
        other.phone == phone &&
        other.email == email &&
        other.address == address;
  }

  @override
  int get hashCode {
    return name.hashCode ^ phone.hashCode ^ email.hashCode ^ address.hashCode;
  }
}
