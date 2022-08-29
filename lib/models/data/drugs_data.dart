import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils.dart';
import '../drug.dart';

class DrugsData extends DataTableSource {
  final QuerySnapshot<Drug> drugs;
  final BuildContext context;

  DrugsData(this.drugs, {required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(cells: [
      DataCell(
        Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(drugs.docs[index].data().type),
        ),
      ),
      DataCell(Text(drugs.docs[index].data().supplier.name)),
      DataCell(Text(drugs.docs[index].data().quantity.toString())),
      DataCell(Text(
          DateFormat.yMMMEd().format(drugs.docs[index].data().date.toDate()))),
      DataCell(TextButton(
          onPressed: () => delete(drugs.docs[index].reference, context),
          child: const Text(
            'DELETE',
            style: TextStyle(color: Colors.red),
          )))
    ], index: index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => drugs.size;

  @override
  int get selectedRowCount => 0;
}
