import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';
import '../supplier.dart';

class SuppliersData extends DataTableSource {
  final QuerySnapshot<Supplier> suppliers;
  final BuildContext context;

  SuppliersData(this.suppliers, {required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(cells: [
      DataCell(Text(suppliers.docs[index].data().name)),
      DataCell(Text(suppliers.docs[index].data().address.state +
          ', ' +
          suppliers.docs[index].data().address.city +
          ', ' +
          suppliers.docs[index].data().address.line1)),
      DataCell(IconButton(
          onPressed: () => delete(suppliers.docs[index].reference, context),
          icon: const Icon(Icons.delete))),
    ], index: index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => suppliers.size;

  @override
  int get selectedRowCount => 0;
}
