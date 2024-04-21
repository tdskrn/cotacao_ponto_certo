import 'package:cotacao_ponto_certo/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, this.productData});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    double initialQuantity = widget.productData['quantity'];
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Container(
      height: 300,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.productData['productName'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.productData['productUnity'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            child: InkWell(
              onTap: _cartProvider.cartItems
                      .containsKey(widget.productData['productId'])
                  ? null
                  : () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            final TextEditingController _quantityController =
                                TextEditingController(
                                    text: initialQuantity.toString());
                            return AlertDialog(
                              title: Text('Edite o valor manulamente'),
                              content: TextFormField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: _quantityController,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Retornar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      initialQuantity = double.parse(
                                          _quantityController.text);
                                    });

                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Salvar'),
                                ),
                              ],
                            );
                          }).whenComplete(() {
                        _cartProvider.addProductToCart(
                          widget.productData['productName'],
                          widget.productData['productId'],
                          widget.productData['productUnity'],
                          initialQuantity,
                        );
                      });
                    },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: _cartProvider.cartItems
                            .containsKey(widget.productData['productId'])
                        ? Text('IN CART')
                        : Text('ADD TO CART'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
