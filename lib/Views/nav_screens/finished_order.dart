import 'package:cotacao_ponto_certo/Views/nav_screens/checkout_screen.dart';
import 'package:cotacao_ponto_certo/providers/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinishedOrder extends StatefulWidget {
  const FinishedOrder({super.key});

  @override
  State<FinishedOrder> createState() => _FinishedOrderState();
}

class _FinishedOrderState extends State<FinishedOrder> {
  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
        appBar: AppBar(
          actions: [
            _cartProvider.cartItems.isEmpty
                ? Text('')
                : IconButton(
                    onPressed: () {
                      _cartProvider.deleteAllCart();
                    },
                    icon: Icon(Icons.delete),
                  ),
          ],
          centerTitle: true,
          title: Text('Pedido'),
        ),
        body: _cartProvider.cartItems.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: _cartProvider.cartItems.length,
                itemBuilder: (context, index) {
                  final cartData =
                      _cartProvider.cartItems.values.toList()[index];

                  return Card(
                    child: SizedBox(
                      height: 130,
                      child: Column(
                        children: [
                          Row(children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                cartData.productName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ]),
                          Row(children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(cartData.unity),
                            ),
                            IconButton(
                              onPressed: cartData.quantity == 1.00
                                  ? null
                                  : () {
                                      _cartProvider.decrement(cartData);
                                    },
                              icon: Icon(CupertinoIcons.minus),
                            ),
                            Text(cartData.quantity.toString()),
                            IconButton(
                              onPressed: () {
                                _cartProvider.increment(cartData);
                              },
                              icon: Icon(CupertinoIcons.plus),
                            ),
                            IconButton(
                              onPressed: () {
                                _cartProvider
                                    .removeProductToCart(cartData.productId);
                              },
                              icon: Icon(CupertinoIcons.cart_badge_minus),
                            ),
                            IconButton(
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      final TextEditingController
                                          _quantityController =
                                          TextEditingController();
                                      _quantityController.text =
                                          cartData.quantity.toString();

                                      return AlertDialog(
                                        title:
                                            Text('Edite o valor manualmente'),
                                        content: TextFormField(
                                          keyboardType:
                                              TextInputType.numberWithOptions(
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
                                                cartData.quantity =
                                                    double.parse(
                                                        _quantityController
                                                            .text);
                                              });

                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Salvar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.edit))
                          ]),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Column(
                  children: [Text('Nenhum item adicionado')],
                ),
              ),
        bottomSheet: _cartProvider.cartItems.isEmpty
            ? Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: Text('FINALIZAR LISTA'),
                ),
              )
            : InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CheckoutScreen();
                    },
                  );
                },
                child: Container(
                  color: Colors.blue,
                  height: 50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('FINALIZAR LISTA'),
                    ],
                  ),
                ),
              ));
  }
}
