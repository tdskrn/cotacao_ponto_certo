import 'package:flutter/material.dart';

class CartAttributes with ChangeNotifier {
  final String productName;
  final String productId;
  String unity;
  double quantity;

  CartAttributes({
    required this.productName,
    required this.productId,
    required this.unity,
    required this.quantity,
  });

  void increase() {
    quantity++;
  }

  void decrease() {
    quantity--;
  }
}
