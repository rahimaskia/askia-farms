import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/data/suppliers_data.dart';
import '../../models/supplier.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/responsive_layout.dart';
import '../m_error_widget.dart';
import '../new_supplier.dart';

class Suppliers extends StatelessWidget {
  const Suppliers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('suppliers')
        .withConverter<Supplier>(
            fromFirestore: (s, _) => Supplier.fromMap(s.data()!),
            toFirestore: (u, _) => u.toMap())
        .snapshots();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'newProduct',
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute<void>(builder: (context) => const NewSupplier())),
      ),
      body: ResponsiveLayout(
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot<Supplier>>(
              stream: query,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Supplier>> snapshot) {
                if (snapshot.hasData) {
                  final suppliers = snapshot.requireData;
                  if (suppliers.size == 0) {
                    return const EmptyWidget(
                        message: 'There are no suppliers yet');
                  }
                  return PaginatedDataTable(
                      sortColumnIndex: 0,
                      columns: [
                        const DataColumn(label: Text('Name')),
                        const DataColumn(label: Text('Address')),
                        const DataColumn(label: Text('Delete')),
                      ],
                      source: SuppliersData(suppliers, context: context));
                } else if (snapshot.hasError) {
                  return MErrorWidget(error: snapshot.error.toString());
                } else {
                  return const LoadingWidget();
                }
              }),
        ),
      ),
    );
  }
}
