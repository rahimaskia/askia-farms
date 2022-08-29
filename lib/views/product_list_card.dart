import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductListCard extends StatelessWidget {
  final Product product;
  final Function onButtonPressed;

  const ProductListCard({
    Key? key,
    required this.product,
    required this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Image.network(product.images.first.toString(), height: 80,
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
              ),
            );
          }),
          Expanded(
            child: ListTile(
              title: Text(product.name),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('GHS${product.unitCost}'),
                  ElevatedButton(
                      onPressed: () => onButtonPressed(),
                      child: const Text('Buy'))
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
