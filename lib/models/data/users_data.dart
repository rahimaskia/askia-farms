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
      DataCell(Row(
        children: [
          UpgradeButton(userId: users.docs[index].id),
          const SizedBox(
            width: 15,
          ),
          IconButton(
              onPressed: () => delete(users.docs[index].reference, context),
              icon: const Icon(Icons.delete)),
        ],
      )),
    ], index: index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.size;

  @override
  int get selectedRowCount => 0;
}

class UpgradeButton extends StatelessWidget {
  const UpgradeButton({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance.collection('admins').doc(userId);
    final stream = ref.snapshots();
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          );
        } else if (snapshot.hasError) {
          return const SizedBox();
        } else {
          if (snapshot.hasData && snapshot.data.data() != null) {
            return const SizedBox();
          }
          return TextButton(
              onPressed: () {
                ref.set(<String, dynamic>{'value': true});
              },
              child: const Text('Make Admin'));
        }
      },
    );
  }
}
