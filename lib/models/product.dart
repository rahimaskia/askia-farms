import 'dart:convert';

class Product {
  final String name;
  final String type;
  final int stock;
  final double unitCost;
  final List<dynamic> images;
  Product({
    required this.name,
    required this.type,
    required this.stock,
    required this.unitCost,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'type': type,
      'stock': stock,
      'unitCost': unitCost,
      'images': images,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] as String,
      type: map['type'] as String,
      stock: map['stock'] as int,
      unitCost: map['unitCost'] as double,
      images: map['images'] as List<dynamic>,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
