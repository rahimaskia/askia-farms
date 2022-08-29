import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';
import '../user.dart';

class UsersData extends DataTableSource {
  final QuerySnapshot<User> users;
  final BuildContext context;

  UsersData(this.users, {required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(cells: [
      DataCell(Text(users.docs[index].data().name)),
      DataCell(Text(users.docs[index].data().email)),
      DataCell(Text(users.docs[index].data().phone ?? 'N/A')),
      DataCell(IconButton(
          onPressed: () => delete(users.docs[index].reference, context),
          icon: const Icon(Icons.delete))),
    ], index: index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.size;

  @override
  int get selectedRowCount => 0;
}
