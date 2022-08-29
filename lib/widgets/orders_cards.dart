import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/order.dart';

class OrdersCards extends StatelessWidget {
  const OrdersCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('orders')
        .withConverter<Order>(
          fromFirestore: (snapshot, _) => Order.fromMap(snapshot.data()!),
          toFirestore: (model, _) => model.toMap(),
        )
        .snapshots();
    return StreamBuilder<QuerySnapshot<Order>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orders = snapshot.data!.docs;

            final _mWidth = MediaQuery.of(context).size.width;
            return Column(
              children: [
                Row(
                  children: [
                    Card(
                        color: Colors.orange,
                        child: SizedBox(
                            height: 100,
                            width: _mWidth * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'ORDERS',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${orders.length}',
                                  style: const TextStyle(
                                      fontSize: 45, color: Colors.white),
                                ),
                              ],
                            ))),
                    Card(
                      color: Colors.green,
                      child: SizedBox(
                        height: 100,
                        width: _mWidth * 0.28,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'TOTAL',
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${orders.length}',
                                style: const TextStyle(
                                    fontSize: 45, color: Colors.white),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text('ORDER ANALYTICS'),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
