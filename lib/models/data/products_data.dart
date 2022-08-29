import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';
import '../product.dart';

class ProductsData extends DataTableSource {
  final QuerySnapshot<Product> products;
  final BuildContext context;

  ProductsData(this.products, {required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(cells: [
      DataCell(Image.network(
        products.docs[index].data().images.first.toString(),
        height: 40,
        width: 40,
      )),
      DataCell(Text(products.docs[index].data().name)),
      DataCell(Text(products.docs[index].data().type)),
      DataCell(Text(products.docs[index].data().stock.toString())),
      DataCell(Text(products.docs[index].data().unitCost.toString())),
      DataCell(IconButton(
          onPressed: () => delete(products.docs[index].reference, context),
          icon: const Icon(Icons.delete))),
    ], index: index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => products.size;

  @override
  int get selectedRowCount => 0;
}
