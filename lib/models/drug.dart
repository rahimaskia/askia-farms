import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'supplier.dart';

class Drug {
  final String type;
  final Supplier supplier;
  final int quantity;
  final Timestamp date;
  Drug({
    required this.type,
    required this.supplier,
    required this.quantity,
    required this.date,
  });

  Drug copyWith({
    String? type,
    Supplier? supplier,
    int? quantity,
    Timestamp? date,
  }) {
    return Drug(
      type: type ?? this.type,
      supplier: supplier ?? this.supplier,
      quantity: quantity ?? this.quantity,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'supplier': supplier.toMap(),
      'quantity': quantity,
      'date': date,
    };
  }

  factory Drug.fromMap(Map<String, dynamic> map) {
    return Drug(
      type: map['type'] as String,
      supplier: Supplier.fromMap(map['supplier'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
      date: map['date'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory Drug.fromJson(String source) =>
      Drug.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '''
Drug(type: $type, supplier: $supplier, quantity: $quantity, date: $date)''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Drug &&
        other.type == type &&
        other.supplier == supplier &&
        other.quantity == quantity &&
        other.date == date;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        supplier.hashCode ^
        quantity.hashCode ^
        date.hashCode;
  }
}
