import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/data/orders_data.dart';
import '../../models/order.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/loading_widget.dart';
import '../m_error_widget.dart';

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('orders')
        .withConverter<Order>(
            fromFirestore: (s, _) => Order.fromMap(s.data()!),
            toFirestore: (o, _) => o.toMap())
        .snapshots();

    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot<Order>>(
          stream: query,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Order>> snapshot) {
            if (snapshot.hasData) {
              final orders = snapshot.requireData;
              if (orders.size == 0) {
                return const EmptyWidget(
                    message: 'There are no orders available');
              }
              return PaginatedDataTable(
                  sortColumnIndex: 0,
                  columns: [
                    const DataColumn(label: Text('Customer')),
                    const DataColumn(label: Text('Phone')),
                    const DataColumn(label: Text('Address')),
                    const DataColumn(label: Text('Product')),
                    const DataColumn(label: Text('Quantity')),
                    const DataColumn(label: Text('Date')),
                    const DataColumn(label: Text('Delete')),
                  ],
                  source: OrdersData(orders, context: context));
            } else if (snapshot.hasError) {
              return MErrorWidget(error: snapshot.error.toString());
            } else {
              return const LoadingWidget();
            }
          }),
    );
  }
}
