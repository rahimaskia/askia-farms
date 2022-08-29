import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils.dart';
import '../order.dart';

class OrdersData extends DataTableSource {
  final QuerySnapshot<Order> orders;
  final BuildContext context;
  final bool isCustomer;

  OrdersData(this.orders, {required this.context, this.isCustomer = false});

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(cells: [
      if (!isCustomer) DataCell(Text(orders.docs[index].data().customer.name)),
      if (!isCustomer) DataCell(Text(orders.docs[index].data().phone)),
      if (!isCustomer) DataCell(Text(orders.docs[index].data().location)),
      DataCell(Text(orders.docs[index].data().product.name)),
      DataCell(Text(orders.docs[index].data().quantity.toString())),
      DataCell(Text(DateFormat.yMMMEd()
          .format(orders.docs[index].data().date!.toDate()))),
      if (!isCustomer)
        DataCell(IconButton(
            onPressed: () => delete(orders.docs[index].reference, context),
            icon: const Icon(Icons.delete))),
    ], index: index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orders.size;

  @override
  int get selectedRowCount => 0;
}
