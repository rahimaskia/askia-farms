import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/data/users_data.dart';
import '../../models/user.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/loading_widget.dart';
import '../m_error_widget.dart';

class Customers extends StatelessWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('users')
        .where('isAdmin', isEqualTo: false)
        .withConverter<User>(
            fromFirestore: (s, _) => User.fromMap(s.data()!),
            toFirestore: (u, _) => u.toMap())
        .snapshots();

    return StreamBuilder<QuerySnapshot<User>>(
        stream: query,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<User>> snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.requireData;
            if (users.size == 0) {
              return const EmptyWidget(message: 'There are no customers yet');
            }
            return PaginatedDataTable(
                sortColumnIndex: 0,
                rowsPerPage: 5,
                columns: [
                  const DataColumn(label: Text('Name')),
                  const DataColumn(label: Text('Email')),
                  const DataColumn(label: Text('Phone')),
                  const DataColumn(label: Text('Delete')),
                ],
                source: UsersData(users, context: context));
          } else if (snapshot.hasError) {
            return MErrorWidget(error: snapshot.error.toString());
          } else {
            return const LoadingWidget();
          }
        });
  }
}
