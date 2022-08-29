import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/drug.dart';
import '../models/data/drugs_data.dart';
import '../widgets/empty_widget.dart';
import 'm_error_widget.dart';
import 'new_drug.dart';

class Drugs extends StatelessWidget {
  const Drugs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ref =
        FirebaseFirestore.instance.collection('drugs').withConverter<Drug>(
              fromFirestore: (snapshot, _) => Drug.fromMap(snapshot.data()!),
              toFirestore: (model, _) => model.toMap(),
            );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drugs'),
        leading: null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'newDrug',
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute<void>(builder: (context) => const NewDrug())),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot<Drug>>(
          stream: ref.snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Drug>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.requireData.size == 0) {
                return const EmptyWidget(
                  message: 'No drugs added yet',
                );
              }
              return PaginatedDataTable(
                  columns: [
                    'Type',
                    'Supplier',
                    'Quantity (G)',
                    'Date',
                    'Delete'
                  ].map((e) => DataColumn(label: Text(e))).toList(),
                  source: DrugsData(snapshot.requireData, context: context));
            }
            if (snapshot.hasError) {
              return MErrorWidget(error: snapshot.error.toString());
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
