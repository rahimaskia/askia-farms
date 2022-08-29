import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils.dart';
import '../feed.dart';

class FeedData extends DataTableSource {
  final QuerySnapshot<Feed> feed;
  final BuildContext context;

  FeedData(this.feed, {required this.context});

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(cells: [
      DataCell(Text(feed.docs[index].data().type)),
      DataCell(Text(feed.docs[index].data().quantity.toString())),
      DataCell(Text(feed.docs[index].data().supplier.name.toString())),
      DataCell(Text(
          DateFormat.yMMMEd().format(feed.docs[index].data().date.toDate()))),
      DataCell(Text(feed.docs[index].data().time)),
      DataCell(IconButton(
          onPressed: () => delete(feed.docs[index].reference, context),
          icon: const Icon(Icons.delete))),
    ], index: index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => feed.size;

  @override
  int get selectedRowCount => 0;
}
