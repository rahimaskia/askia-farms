import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils.dart';
import '../egg_collection.dart';

class EggsData extends DataTableSource {
  final QuerySnapshot<EggCollection> eggs;
  final BuildContext context;

  EggsData(this.eggs, {required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(cells: [
      DataCell(Text(eggs.docs[index].data().numberOfEggs.toString())),
      DataCell(Text(eggs.docs[index].data().broken.toString())),
      DataCell(Text(eggs.docs[index].data().total.toString())),
      DataCell(Text(
          DateFormat.yMMMEd().format(eggs.docs[index].data().date.toDate()))),
      DataCell(Text(eggs.docs[index].data().time)),
      DataCell(IconButton(
          onPressed: () => delete(eggs.docs[index].reference, context),
          icon: const Icon(Icons.delete))),
    ], index: index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => eggs.size;

  @override
  int get selectedRowCount => 0;
}
