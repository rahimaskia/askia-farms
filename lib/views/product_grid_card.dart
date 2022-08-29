import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductGridCard extends StatelessWidget {
  final Product product;
  final Function onBidPressed;

  const ProductGridCard({
    Key? key,
    required this.product,
    required this.onBidPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              product.images.first.toString(),
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                    child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ));
              },
              fit: BoxFit.fill,
              width: 200,
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 4.0, left: 4.0),
            child: Text(product.name),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('₵${product.unitCost}'),
                TextButton(
                    onPressed: () => onBidPressed(), child: const Text('Buy')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
