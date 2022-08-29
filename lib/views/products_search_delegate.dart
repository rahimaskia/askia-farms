import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import 'product_list_card.dart';

class ProductsSearchDelegate extends SearchDelegate<Product> {
  @override
  List<Widget> buildActions(BuildContext context) {
    if (query.isNotEmpty) {
      return [
        IconButton(
            onPressed: () {
              query = '';
              showSuggestions(context);
            },
            icon: const Icon(Icons.clear))
      ];
    }
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    final result = FirebaseFirestore.instance
        .collection('products')
        .withConverter<Product>(
            fromFirestore: (s, _) => Product.fromMap(s.data()!),
            toFirestore: (p, _) => p.toMap())
        .get();

    return FutureBuilder<QuerySnapshot<Product>>(
        future: result,
        builder: (context, AsyncSnapshot<QuerySnapshot<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            final products = snapshot.data!.docs.map((e) => e.data()).toList();
            products.retainWhere((element) =>
                element.name.contains(query) || element.type.contains(query));
            if (products.length == 0) {
              return const Center(
                child: Text('No data'),
              );
            }
            return ListView.separated(
                separatorBuilder: (c, i) => const Divider(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductListCard(
                    product: product,
                    onButtonPressed: () async {
                      final pref = await SharedPreferences.getInstance();
                      final suggestions =
                          pref.getStringList('product_searches') ?? [];
                      if (!suggestions.contains(query) &&
                          query.trim().length > 3) {
                        suggestions.add(query);
                        pref.setStringList('product_searches', suggestions);
                      }
                      close(context, product);
                    },
                  );
                });
          }
          return const Center(
            child: Text('No results'),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        final suggestions =
            snapshot.data?.getStringList('product_searches') ?? [];
        suggestions.removeWhere(
            (element) => element.isEmpty || element.trim().isEmpty);
        return ListView.separated(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  ListTile(
                      title: const Text('Recent Searches'),
                      trailing: const Icon(Icons.delete),
                      onTap: () {
                        suggestions.clear();
                        snapshot.data?.remove('product_searches');
                        query = '';
                      }),
                  ListTile(
                      title: Text(suggestions[index]),
                      onTap: () {
                        query = suggestions[index];
                        showResults(context);
                      }),
                ],
              );
            }
            return ListTile(
              title: Text(suggestions[index]),
              onTap: () {
                query = suggestions[index];
                showResults(context);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 0,
          ),
        );
      },
    );
  }
}
