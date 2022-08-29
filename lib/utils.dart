import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension Capitalizer on String {
  String capitalize() {
    final firstChar = this[0].toUpperCase();
    final reminder = substring(1);
    return firstChar + reminder;
  }
}

void delete(DocumentReference reference, BuildContext context) {
  showCupertinoDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sure To Delete?'),
          content: const Text(
              '''Are you sure you want to delete this item? You cannot undo this action!'''),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL')),
            TextButton(
                onPressed: () => reference
                    .delete()
                    .then((value) => Navigator.of(context).pop()),
                child: const Text('DELETE'))
          ],
        );
      });
}
