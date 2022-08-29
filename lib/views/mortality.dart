import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/data/mortality_data.dart';
import '../models/mortality.dart';
import '../widgets/empty_widget.dart';
import '../widgets/responsive_layout.dart';
import 'm_error_widget.dart';
import 'new_mortality.dart';

class MortalityWidget extends StatelessWidget {
  const MortalityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('mortality')
        .withConverter<Mortality>(
            fromFirestore: (s, _) => Mortality.fromMap(s.data()!),
            toFirestore: (m, _) => m.toMap())
        .snapshots();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
                builder: (context) => const NewMortality())),
      ),
      body: ResponsiveLayout(
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot<Mortality>>(
            stream: query,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Mortality>> snapshot) {
              if (snapshot.hasData) {
                final mortality = snapshot.requireData;
                if (mortality.size == 0) {
                  return const EmptyWidget(
                      message: 'You haven\'t recorded any mortality');
                }
                return PaginatedDataTable(
                    sortColumnIndex: 0,
                    columns: [
                      const DataColumn(label: Text('Mortality')),
                      const DataColumn(label: Text('Date')),
                      const DataColumn(label: Text('Cause')),
                      const DataColumn(label: Text('Delete')),
                    ],
                    source: MortalityData(mortality, context: context));
              } else if (snapshot.hasError) {
                return MErrorWidget(error: snapshot.error.toString());
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
