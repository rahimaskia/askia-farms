import 'dart:convert';
import 'address.dart';

class Supplier {
  final String name;
  final Address address;
  Supplier({
    required this.name,
    required this.address,
  });

  Supplier copyWith({
    String? name,
    Address? address,
  }) {
    return Supplier(
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'address': address.toMap(),
    };
  }

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      name: map['name'] as String,
      address: Address.fromMap(map['address'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Supplier.fromJson(String source) =>
      Supplier.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Supplier(name: $name, address: $address)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Supplier && other.name == name && other.address == address;
  }

  @override
  int get hashCode => name.hashCode ^ address.hashCode;
}
