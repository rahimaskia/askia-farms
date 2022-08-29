import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String type;
  final double unitCost;
  final int quantity;
  final Timestamp date;
  Expense({
    required this.type,
    required this.unitCost,
    required this.quantity,
    required this.date,
  });

  Expense copyWith({
    String? type,
    double? unitCost,
    int? quantity,
    Timestamp? date,
  }) {
    return Expense(
      type: type ?? this.type,
      unitCost: unitCost ?? this.unitCost,
      quantity: quantity ?? this.quantity,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'unitCost': unitCost,
      'quantity': quantity,
      'date': date,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      type: map['type'] as String,
      unitCost: map['unitCost'] as double,
      quantity: map['quantity'] as int,
      date: map['date'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory Expense.fromJson(String source) =>
      Expense.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '''
Expense(type: $type, unitCost: $unitCost, quantity: $quantity, date: $date)''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Expense &&
        other.type == type &&
        other.unitCost == unitCost &&
        other.quantity == quantity &&
        other.date == date;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        unitCost.hashCode ^
        quantity.hashCode ^
        date.hashCode;
  }

  double get totalCost => unitCost * quantity;
}
