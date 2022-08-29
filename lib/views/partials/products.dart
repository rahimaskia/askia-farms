import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/data/products_data.dart';
import '../../models/product.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/responsive_layout.dart';
import '../m_error_widget.dart';
import '../new_product.dart';

class Products extends StatelessWidget {
  const Products({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('products')
        .withConverter<Product>(
            fromFirestore: (s, _) => Product.fromMap(s.data()!),
            toFirestore: (p, _) => p.toMap())
        .snapshots();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        heroTag: 'newProduct',
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute<void>(builder: (context) => const NewProduct())),
      ),
      body: ResponsiveLayout(
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot<Product>>(
            stream: query,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Product>> snapshot) {
              if (snapshot.hasData) {
                final products = snapshot.requireData;
                if (products.size == 0) {
                  return const EmptyWidget(
                    message: 'There are no products available',
                  );
                }
                return PaginatedDataTable(
                    sortColumnIndex: 0,
                    columns: [
                      const DataColumn(label: Text('Image')),
                      const DataColumn(label: Text('Name')),
                      const DataColumn(label: Text('Product type')),
                      const DataColumn(label: Text('Quantity')),
                      const DataColumn(label: Text('Unit Price')),
                      const DataColumn(label: Text('Delete')),
                    ],
                    source: ProductsData(products, context: context));
              } else if (snapshot.hasError) {
                return MErrorWidget(error: snapshot.error.toString());
              } else {
                return const LoadingWidget();
              }
            },
          ),
        ),
      ),
    );
  }
}
