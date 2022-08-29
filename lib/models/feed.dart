import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'supplier.dart';

class Feed {
  final String type;
  final int quantity;
  final Supplier supplier;
  final Timestamp date;
  final String time;
  Feed({
    required this.type,
    required this.quantity,
    required this.supplier,
    required this.date,
    required this.time,
  });

  Feed copyWith({
    String? type,
    int? quantity,
    Supplier? supplier,
    Timestamp? date,
    String? time,
  }) {
    return Feed(
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      supplier: supplier ?? this.supplier,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'quantity': quantity,
      'supplier': supplier.toMap(),
      'date': date,
      'time': time,
    };
  }

  factory Feed.fromMap(Map<String, dynamic> map) {
    return Feed(
      type: map['type'] as String,
      quantity: map['quantity'] as int,
      supplier: Supplier.fromMap(map['supplier'] as Map<String, dynamic>),
      date: map['date'] as Timestamp,
      time: map['time'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Feed.fromJson(String source) =>
      Feed.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '''
      Feed(type: $type, quantity: $quantity, 
      supplier: $supplier, date: $date, time: $time)
      ''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Feed &&
        other.type == type &&
        other.quantity == quantity &&
        other.supplier == supplier &&
        other.date == date;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        quantity.hashCode ^
        supplier.hashCode ^
        date.hashCode;
  }
}
