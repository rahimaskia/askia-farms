import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/loading_widget.dart';
import '../widgets/menu_popup.dart';
import 'dashboard.dart';
import 'partials/products_view.dart';
import 'products_search_delegate.dart';

class Homepage extends StatelessWidget {
  Homepage({Key? key, this.index}) : super(key: key);
  final int? index;

  final _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }

  Widget _buildWidget() {
    final stream = FirebaseFirestore.instance
        .collection('admins')
        .doc(_user?.uid)
        .snapshots();
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: LoadingWidget());
          }
          if (snapshot.hasError) {
            return const Scaffold(
                body: Center(
              child: Text('Failed to fetch products'),
            ));
          }
          if (!snapshot.hasData || !(snapshot.data?.exists ?? true)) {
            return MarketPlace(user: _user);
          }
          return Dashboard(index: index);
        });
  }
}

class MarketPlace extends StatelessWidget {
  MarketPlace({
    Key? key,
    required this.user,
    this.isAdmin = false,
  }) : super(key: key);
  final User? user;
  final bool isAdmin;

  final bool _isGrid = true;

  // Menus for a normal user
  final List<Map<String, dynamic>> _menus = [
    <String, dynamic>{'title': 'My Account', 'icon': Icons.person},
    <String, dynamic>{'title': 'Logout', 'icon': Icons.logout},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(isAdmin ? 'Marketplace' : 'Askia Farms'),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                    onPressed: () async {
                      final product = await showSearch<Product>(
                          context: context, delegate: ProductsSearchDelegate());
                      if (product != null) {
                        ProductsView.showSheet(context, product);
                      }
                    },
                    icon: const Icon(
                      Icons.search,
                    )),
              ),
              if (!isAdmin) MenuPopup(menus: _menus, user: user)
            ]),
        body: SingleChildScrollView(
          child: ProductsView(isList: !_isGrid),
        ));
  }
}
