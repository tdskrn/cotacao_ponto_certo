import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotacao_ponto_certo/app/modules/products/domain/models/product_dto.dart';
import 'package:cotacao_ponto_certo/app/modules/products/domain/usecases/add_product_usecase.dart';

class TesteController {
  final AddProductUseCase _addProductUseCase;
  TesteController(this._addProductUseCase);

  Future<void> addProduct(ProductDto product) async {
    ProductDto produto = ProductDto(
        productId: product.productId,
        productName: product.productName,
        productCategory: product.productCategory,
        productUnity: product.productUnity,
        quantity: product.quantity,
        last_modified: Timestamp.now(),
        created_at: Timestamp.now());

    try {
      var response = await _addProductUseCase.call(produto);
      if (response.success) {
        print(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
