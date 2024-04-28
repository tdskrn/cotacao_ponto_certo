import 'package:flutter/material.dart';

class ProductListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ProductListWidget({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _rowHeader(
      String text,
      int flex,
    ) {
      return Expanded(
        flex: flex,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade700,
            ),
            color: Colors.white,
          ),
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                text,
              )),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Row(children: [
          _rowHeader(product['quantity'].toString(), 1),
          _rowHeader(product['unity'], 1),
          _rowHeader(product['product_name'], 3),
        ]);
      },
    );
  }
}
