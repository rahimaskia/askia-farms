import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils.dart';
import '../mortality.dart';

class MortalityData extends DataTableSource {
  final QuerySnapshot<Mortality> mortality;
  final BuildContext context;

  MortalityData(this.mortality, {required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(cells: [
      DataCell(Text(mortality.docs[index].data().mortality.toString())),
      DataCell(Text(DateFormat.yMMMEd()
          .format(mortality.docs[index].data().date.toDate()))),
      DataCell(Text(mortality.docs[index].data().cause.capitalize())),
      DataCell(IconButton(
          onPressed: () => delete(mortality.docs[index].reference, context),
          icon: const Icon(Icons.delete))),
    ], index: index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => mortality.size;

  @override
  int get selectedRowCount => 0;
}
