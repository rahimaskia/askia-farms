import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/supplier.dart';
import '../views/m_error_widget.dart';
import 'empty_widget.dart';
import 'loading_widget.dart';

class SelectSupplier extends StatelessWidget {
  SelectSupplier({Key? key}) : super(key: key);
  final _supplier = ValueNotifier<Supplier?>(null);

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance
        .collection('suppliers')
        .withConverter<Supplier>(
            fromFirestore: (s, _) => Supplier.fromMap(s.data()!),
            toFirestore: (s, _) => s.toMap())
        .snapshots();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Supplier>>(
          stream: ref,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.requireData.size == 0) {
                return const EmptyWidget(
                  message: 'No suppliers',
                );
              }
              final suppliers =
                  snapshot.requireData.docs.map((e) => e.data()).toList();
              return ListView.separated(
                  itemBuilder: (ctx, i) {
                    return ValueListenableBuilder<Supplier?>(
                        valueListenable: _supplier,
                        builder: (ctx, listenable, child) {
                          return RadioListTile<Supplier>(
                              value: suppliers[i],
                              title: Text(suppliers[i].name),
                              groupValue: listenable,
                              onChanged: (v) => Navigator.of(context).pop(v));
                        });
                  },
                  separatorBuilder: (ctx, i) => const Divider(),
                  itemCount: suppliers.length);
            } else if (snapshot.hasError) {
              return MErrorWidget(error: snapshot.error.toString());
            } else {
              return const LoadingWidget();
            }
          }),
    );
  }
}
