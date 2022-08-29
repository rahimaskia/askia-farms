import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'loading_widget.dart';

class ItemCountCard extends StatelessWidget {
  final String item;
  final Color bgColor;
  final double width;
  final VoidCallback? onTap;
  const ItemCountCard(
      {Key? key,
      required this.item,
      required this.bgColor,
      required this.width,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance.collection(item).snapshots();
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text('TOTAL ${item.toUpperCase()}'),
                ),
                itemCard(snapshot, itemType: item),
              ],
            );
          }
          return Card(
            color: bgColor,
            child: SizedBox(
              width: width,
              child: const LoadingWidget(
                height: 100,
              ),
            ),
          );
        });
  }

  Card itemCard(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
      {required String itemType}) {
    const initial = 0;
    String text;
    switch (itemType) {
      case 'eggs':
        text = (snapshot.data?.docs.fold<int>(
            initial,
            (int previousValue, element) =>
                previousValue +
                ((element['numberOfEggs'] as int? ?? 0) -
                    (element['broken'] as int? ?? 0)))).toString();
        break;
      case 'products':
        text = (snapshot.data?.docs.fold<int>(
            initial,
            (int previousValue, element) =>
                previousValue + (element['stock'] as int? ?? 0))).toString();
        break;
      case 'mortality':
        text = (snapshot.data?.docs.fold<int>(
                initial,
                (previousValue, element) =>
                    previousValue + ((element['mortality'] as int?) ?? 0)))
            .toString();
        break;
      default:
        text = snapshot.data?.docs.length.toString() ?? '0';
    }
    return Card(
      color: bgColor,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
            height: 100,
            width: width,
            child: Center(
              child: Text(
                text,
                style: const TextStyle(fontSize: 45, color: Colors.white),
              ),
            )),
      ),
    );
  }
}
