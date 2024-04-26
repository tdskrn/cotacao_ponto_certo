import 'package:cotacao_ponto_certo/app/models/cart_attributes.dart';
import 'package:flutter/material.dart';

class ProductWidgetCart extends StatefulWidget {
  final Map<String, CartAttributes> data;
  const ProductWidgetCart({super.key, required this.data});

  @override
  State<ProductWidgetCart> createState() => _ProductWidgetCartState();
}

class _ProductWidgetCartState extends State<ProductWidgetCart> {
  Widget productWidgetCartRow(int? flex, Widget widget) {
    return Expanded(
      flex: flex!,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: widget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<CartAttributes> cartData = [];
    widget.data.forEach((key, value) {
      cartData.add(value);
    });
    return ListView.builder(
      shrinkWrap: true,
      itemCount: cartData.length,
      itemBuilder: (context, index) {
        final cartProductData = cartData[index];

        return Container(
          child: Row(
            children: [
              productWidgetCartRow(
                  1, Text(cartProductData.quantity.toString())),
              productWidgetCartRow(1, Text(cartProductData.unity)),
              productWidgetCartRow(3, Text(cartProductData.productName)),
            ],
          ),
        );
      },
    );
  }
}
