import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'product.dart';
import 'user.dart';

class Order {
  final String orderId;
  final Product product;
  final String location;
  final String phone;
  final int quantity;
  final User customer;
  Timestamp? date;
  Order({
    required this.orderId,
    required this.product,
    required this.location,
    required this.phone,
    required this.quantity,
    required this.customer,
    this.date,
  });

  Order copyWith({
    String? orderId,
    Product? product,
    String? location,
    String? phone,
    int? quantity,
    User? customer,
    Timestamp? date,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      product: product ?? this.product,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      quantity: quantity ?? this.quantity,
      customer: customer ?? this.customer,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'product': product.toMap(),
      'location': location,
      'phone': phone,
      'quantity': quantity,
      'customer': customer.toMap(),
      'date': date,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'] as String,
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      location: map['location'] as String,
      phone: map['phone'] as String,
      quantity: map['quantity'] as int,
      customer: User.fromMap(map['customer'] as Map<String, dynamic>),
      date: map['date'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '''Order(orderId: $orderId, product: $product, location: $location, 
    phone: $phone, quantity: $quantity, customer: $customer, date: $date)''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        other.orderId == orderId &&
        other.product == product &&
        other.location == location &&
        other.phone == phone &&
        other.quantity == quantity &&
        other.customer == customer &&
        other.date == date;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        product.hashCode ^
        location.hashCode ^
        phone.hashCode ^
        quantity.hashCode ^
        customer.hashCode ^
        date.hashCode;
  }
}
