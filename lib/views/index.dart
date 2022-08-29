import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/items_count_cards.dart';
import '../widgets/sticky_tabbed_sliver_app_bar.dart';
import 'home_page.dart';
import 'mortality.dart';
import 'partials/expenses.dart';
import 'partials/orders.dart';
import 'partials/products.dart';
import 'partials/suppliers.dart';
import 'partials/users.dart';

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final _tabs = [
    'mortality',
    'suppliers',
    'expenses',
    'orders',
    'customers',
    'products'
  ];
  final _tabViews = const [
    MortalityWidget(),
    Suppliers(),
    Expenses(),
    Orders(),
    Customers(),
    Products(),
  ];
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StickyTabbedSliverAppBar(
        tabLength: 6,
        title: const Text('Dashboard'),
        actions: [
          IconButton(
              tooltip: 'Marketplace',
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (context) => MarketPlace(user: user))),
              icon: const Icon(Icons.shopping_bag)),
          IconButton(
              tooltip: 'Log out',
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
        flexibleSpaceBackground: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: const EdgeInsets.only(top: 85),
            child: Row(
              children: [
                ItemCountCard(
                    item: 'birds', bgColor: Colors.blue, width: width * 0.5),
                ItemCountCard(
                    item: 'drugs',
                    bgColor: Colors.orange,
                    width: width * 0.332),
                ItemCountCard(
                    item: 'feed', bgColor: Colors.red, width: width * 0.3),
                ItemCountCard(
                    item: 'mortality',
                    bgColor: Colors.green,
                    width: width * 0.45),
                ItemCountCard(
                    item: 'suppliers',
                    bgColor: Colors.purple,
                    width: width * 0.5),
                ItemCountCard(
                    item: 'eggs', bgColor: Colors.amber, width: width * 0.4),
                ItemCountCard(
                    item: 'expenses',
                    bgColor: Colors.pink,
                    width: width * 0.35),
                ItemCountCard(
                    item: 'orders', bgColor: Colors.cyan, width: width * 0.3),
                ItemCountCard(
                    item: 'users',
                    bgColor: Colors.purpleAccent,
                    width: width * 0.3),
                ItemCountCard(
                    item: 'products', bgColor: Colors.teal, width: width * 0.5),
              ],
            ),
          ),
        ),
        tabs: _tabs
            .map((e) => Tab(
                  text: e.toUpperCase(),
                ))
            .toList(),
        tabBarViews: _tabViews);
  }

  Padding buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 4, bottom: 8),
      child: Text(title,
          style: const TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  void navigateTo(Widget page) {
    Navigator.of(context)
        .push<dynamic>(MaterialPageRoute<dynamic>(builder: (context) => page));
  }
}
