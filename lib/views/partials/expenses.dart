import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/data/expense_data.dart';
import '../../models/expense.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/loading_widget.dart';
import '../m_error_widget.dart';
import '../new_expense.dart';

class Expenses extends StatelessWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('expenses')
        .withConverter<Expense>(
            fromFirestore: (s, _) => Expense.fromMap(s.data()!),
            toFirestore: (e, _) => e.toMap())
        .snapshots();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute<void>(builder: (context) => const NewExpense())),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot<Expense>>(
            stream: query,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Expense>> snapshot) {
              if (snapshot.hasData) {
                final expenses = snapshot.requireData;
                if (expenses.size == 0) {
                  return const EmptyWidget(
                      message: 'You don\'t have any expenses');
                }
                return PaginatedDataTable(
                    sortColumnIndex: 0,
                    columns: [
                      const DataColumn(label: Text('Type')),
                      const DataColumn(label: Text('Quantity')),
                      const DataColumn(label: Text('Unit cost')),
                      const DataColumn(label: Text('Total')),
                      const DataColumn(label: Text('Date')),
                      const DataColumn(label: Text('Delete')),
                    ],
                    source: ExpenseData(expenses, context: context));
              } else if (snapshot.hasError) {
                return MErrorWidget(error: snapshot.error.toString());
              } else {
                return const LoadingWidget();
              }
            }),
      ),
    );
  }
}
