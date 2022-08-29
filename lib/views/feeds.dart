import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/empty_widget.dart';
import '../../widgets/loading_widget.dart';
import '../models/data/feed_data.dart';
import '../models/feed.dart';
import '../widgets/responsive_layout.dart';
import 'm_error_widget.dart';
import 'new_feed.dart';

class Feeds extends StatelessWidget {
  const Feeds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('feed')
        .withConverter<Feed>(
            fromFirestore: (s, _) => Feed.fromMap(s.data()!),
            toFirestore: (f, _) => f.toMap())
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'newFeed',
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute<void>(builder: (context) => const NewFeed())),
      ),
      body: ResponsiveLayout(
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot<Feed>>(
              stream: query,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Feed>> snapshot) {
                if (snapshot.hasData) {
                  final feed = snapshot.requireData;
                  if (feed.size == 0) {
                    return const EmptyWidget(
                        message: 'You have no feed available');
                  }
                  return PaginatedDataTable(
                      sortColumnIndex: 0,
                      columns: [
                        const DataColumn(label: Text('Type')),
                        const DataColumn(label: Text('Quantity (Kg)')),
                        const DataColumn(label: Text('Supplier')),
                        const DataColumn(label: Text('Date')),
                        const DataColumn(label: Text('Time')),
                        const DataColumn(label: Text('Delete')),
                      ],
                      source: FeedData(feed, context: context));
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
