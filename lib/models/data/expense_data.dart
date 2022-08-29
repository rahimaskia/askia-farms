import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils.dart';
import '../expense.dart';

class ExpenseData extends DataTableSource {
  final QuerySnapshot<Expense> expenses;
  final BuildContext context;

  ExpenseData(this.expenses, {required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(cells: [
      DataCell(Text(expenses.docs[index].data().type.toString())),
      DataCell(Text(expenses.docs[index].data().quantity.toString())),
      DataCell(Text(expenses.docs[index].data().unitCost.toString())),
      DataCell(Text(expenses.docs[index].data().totalCost.toString())),
      DataCell(Text(DateFormat.yMMMEd()
          .format(expenses.docs[index].data().date.toDate()))),
      DataCell(IconButton(
          onPressed: () => delete(expenses.docs[index].reference, context),
          icon: const Icon(Icons.delete))),
    ], index: index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => expenses.size;

  @override
  int get selectedRowCount => 0;
}
