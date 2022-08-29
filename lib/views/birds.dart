import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/empty_widget.dart';
import '../../widgets/loading_widget.dart';
import '../models/bird.dart';
import '../models/data/birds_data.dart';
import '../widgets/responsive_layout.dart';
import 'm_error_widget.dart';
import 'new_bird.dart';

class Birds extends StatelessWidget {
  const Birds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('birds')
        .withConverter<Bird>(
            fromFirestore: (s, _) => Bird.fromMap(s.data()!),
            toFirestore: (b, _) => b.toMap())
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Birds'),
        leading: null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'newBird',
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute<void>(builder: (context) => const NewBird())),
      ),
      body: ResponsiveLayout(
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot<Bird>>(
              stream: query,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Bird>> snapshot) {
                if (snapshot.hasData) {
                  final birds = snapshot.requireData;
                  if (birds.size == 0) {
                    return const EmptyWidget(
                        message: 'You have no birds available');
                  }
                  return PaginatedDataTable(
                      sortColumnIndex: 0,
                      columns: [
                        const DataColumn(label: Text('Type')),
                        const DataColumn(label: Text('Tag')),
                        const DataColumn(label: Text('Delete')),
                      ],
                      source: BirdsData(birds, context: context));
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
