import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/empty_widget.dart';
import '../../widgets/loading_widget.dart';
import '../models/data/eggs_data.dart';
import '../models/egg_collection.dart';
import '../widgets/responsive_layout.dart';
import 'm_error_widget.dart';
import 'new_eggs_collection.dart';

class Eggs extends StatelessWidget {
  const Eggs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('eggs')
        .withConverter<EggCollection>(
            fromFirestore: (s, _) => EggCollection.fromMap(s.data()!),
            toFirestore: (e, _) => e.toMap())
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eggs'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'newEggs',
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (context) => const NewEggsCollection())),
      ),
      body: ResponsiveLayout(
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot<EggCollection>>(
              stream: query,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<EggCollection>> snapshot) {
                if (snapshot.hasData) {
                  final eggs = snapshot.requireData;
                  if (eggs.size == 0) {
                    return const EmptyWidget(
                        message: 'You don\'t have any eggs');
                  }
                  return PaginatedDataTable(
                      sortColumnIndex: 0,
                      columns: [
                        const DataColumn(label: Text('No. of eggs')),
                        const DataColumn(label: Text('Broken')),
                        const DataColumn(label: Text('Unbroken')),
                        const DataColumn(label: Text('Date Collected')),
                        const DataColumn(label: Text('Time')),
                        const DataColumn(label: Text('Delete')),
                      ],
                      source: EggsData(eggs, context: context));
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
