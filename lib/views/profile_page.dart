import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/data/orders_data.dart';
import '../models/order.dart';
import '../widgets/empty_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/sticky_tabbed_sliver_app_bar.dart';
import 'm_error_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StickyTabbedSliverAppBar(
        tabLength: 2,
        title: user?.displayName == null
            ? null
            : Text(
                user!.displayName!,
                style: const TextStyle(fontSize: 18.0),
              ),
        flexibleSpaceBackground:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircleAvatar(
            radius: 32,
            foregroundImage:
                user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            child: user?.photoURL == null ? Text(user!.displayName!) : null,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            user!.email!,
          ),
        ]),
        tabs: [
          Tab(
              child: Row(children: [
            const Icon(Icons.shopping_basket),
            const SizedBox(
              width: 8,
            ),
            const Text('MY ORDERS'),
          ])),
          Tab(
            child: Row(
              children: [
                const Icon(Icons.favorite),
                const SizedBox(
                  width: 8,
                ),
                const Text('FAVORITES'),
              ],
            ),
          )
        ],
        tabBarViews: [
          buildOrders(),
          Container(),
        ]);
  }

  Widget buildOrders() {
    final query = FirebaseFirestore.instance
        .collection('orders')
        .where('customer.email', isEqualTo: user!.email)
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
                return const EmptyWidget(message: 'You have no orders yet');
              }
              return PaginatedDataTable(
                  sortColumnIndex: 0,
                  columns: [
                    const DataColumn(label: Text('Product')),
                    const DataColumn(label: Text('Quantity')),
                    const DataColumn(label: Text('Date')),
                  ],
                  source:
                      OrdersData(orders, context: context, isCustomer: true));
            } else if (snapshot.hasError) {
              return MErrorWidget(error: snapshot.error.toString());
            } else {
              return const LoadingWidget();
            }
          }),
    );
  }
}
