import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../../models/order.dart';
import '../../models/product.dart';
import '../../models/user.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/empty_widget.dart';
import '../product_grid_card.dart';
import '../product_list_card.dart';

class ProductsView extends StatelessWidget {
  final bool isList;
  final String? category;
  final isLoading = ValueNotifier(false);
  ProductsView({Key? key, this.category, required this.isList})
      : super(key: key);

  static Future<void> order(BuildContext context, Product product, int quantity,
      String phone, String location) async {
    final user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseFirestore.instance.collection('orders');
    final dateNow = Timestamp.now();

    final orderId = dateNow.millisecondsSinceEpoch.toString();
    final bid = Order(
        product: product,
        orderId: orderId,
        phone: phone,
        location: location,
        quantity: quantity,
        date: dateNow,
        customer: User(
            name: user?.displayName ?? '',
            email: user?.email ?? '',
            phone: user?.phoneNumber));
    ref.doc(orderId).set(bid.toMap()).then((value) {
      CustomSnackBar.snackBar(context,
          text: 'Order placed successfully', message: Message.success);
    }).catchError((Object? err) {
      CustomSnackBar.snackBar(context,
          text: 'An error occurred: ${err?.toString()}',
          message: Message.error);
    });
  }

  static void showSheet(BuildContext buildContext, Product product,
      {bool isLoading = false}) {
    final quantityController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(buildContext).size.width - 20,
        ),
        backgroundColor: Colors.transparent,
        context: buildContext,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: quantityController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          labelText: 'Product quantity',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Quantity is required';
                          }
                          if (double.tryParse(value) == null ||
                              double.tryParse(value) == 0) {
                            return 'Invalid quantity price';
                          }
                          if (double.tryParse(value)! > product.stock) {
                            return '''Quantity cannot be more than ${product.stock}''';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: phoneController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone number is required';
                          }
                          if (value.length < 10 || value.length > 14) {
                            return 'Invalid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: addressController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          labelText: 'Your location',
                        ),
                        maxLines: 5,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Location is required';
                          }
                          if (value.length < 10) {
                            return 'Invalid location';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Future.delayed(const Duration(seconds: 3),
                                  () => Navigator.pop(context));
                              order(
                                  buildContext,
                                  product,
                                  int.parse(quantityController.text),
                                  phoneController.text,
                                  addressController.text);
                            }
                          },
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: const Text('PURCHASE NOW'))),
                    ]),
                  ),
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final query = FirebaseFirestore.instance
        .collection('products')
        .withConverter<Product>(
            fromFirestore: (s, _) => Product.fromMap(s.data()!),
            toFirestore: (p, _) => p.toMap())
        .orderBy('name');
    final refreshChangeListener = PaginateRefreshedChangeListener();

    return RefreshIndicator(
      child: PaginateFirestore(
          isLive: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180, mainAxisExtent: 220),
          shrinkWrap: true,
          itemBuilderType: isList
              ? PaginateBuilderType.listView
              : PaginateBuilderType.gridView,
          itemBuilder: (context, snapshot, index) {
            final product = snapshot[index].data() as Product;
            if (isList) {
              return ValueListenableBuilder<bool>(
                  valueListenable: isLoading,
                  builder: (context, loading, child) {
                    return ProductListCard(
                        product: product,
                        onButtonPressed: () =>
                            showSheet(context, product, isLoading: loading));
                  });
            }
            return ValueListenableBuilder<bool>(
                valueListenable: isLoading,
                builder: (context, loading, child) {
                  return ProductGridCard(
                      product: product,
                      onBidPressed: () => showSheet(context, product,
                          isLoading: isLoading.value));
                });
          },
          query: query,
          listeners: [
            refreshChangeListener,
          ],
          onEmpty:
              const EmptyWidget(message: 'Sorry, there are no products yet')),
      onRefresh: () async {
        refreshChangeListener.refreshed = true;
      },
    );
  }
}
