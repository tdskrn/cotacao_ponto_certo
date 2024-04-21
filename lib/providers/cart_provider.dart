import 'package:cotacao_ponto_certo/models/cart_attributes.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttributes> _cartItems = {};

  Map<String, CartAttributes> get cartItems => _cartItems;

  int get totalItems => _cartItems.entries.length;

  void deleteAllCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void addProductToCart(
    String productName,
    String productId,
    String unity,
    double quantity,
  ) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(productId, (existingCart) {
        return CartAttributes(
            productId: existingCart.productId,
            productName: existingCart.productName,
            unity: existingCart.unity,
            quantity: existingCart.quantity + 1.00);
      });
      notifyListeners();
    } else {
      _cartItems.putIfAbsent(productId, () {
        return CartAttributes(
          productName: productName,
          productId: productId,
          unity: unity,
          quantity: quantity,
        );
      });
      notifyListeners();
    }
  }

  void increment(CartAttributes cartAttributes) {
    cartAttributes.increase();
    notifyListeners();
  }

  void decrement(CartAttributes cartAttributes) {
    cartAttributes.decrease();
    notifyListeners();
  }
}
