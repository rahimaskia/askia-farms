import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';
import '../bird.dart';

class BirdsData extends DataTableSource {
  final QuerySnapshot<Bird> birds;
  final BuildContext context;

  BirdsData(this.birds, {required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(cells: [
      DataCell(Text(birds.docs[index].data().type.capitalize())),
      DataCell(Text(birds.docs[index].data().tag.toString())),
      DataCell(IconButton(
          onPressed: () => delete(birds.docs[index].reference, context),
          icon: const Icon(Icons.delete))),
    ], index: index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => birds.size;

  @override
  int get selectedRowCount => 0;
}
