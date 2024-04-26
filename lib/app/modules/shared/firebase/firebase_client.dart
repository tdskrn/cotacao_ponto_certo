import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotacao_ponto_certo/app/modules/products/domain/models/product_dto.dart';

import 'package:uuid/uuid.dart';

class FirebaseClient {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addProduct(ProductDto product) async {
    final String productId = Uuid().v4();
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .set(product.toMap(productId));

      return product.toMap(productId);
    } catch (error) {
      rethrow;
    }
  }
}
