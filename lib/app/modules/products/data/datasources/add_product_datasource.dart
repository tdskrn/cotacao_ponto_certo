import 'package:cotacao_ponto_certo/app/modules/products/domain/models/product_dto.dart';

abstract class AddProductDataSource {
  Future<Map<String, dynamic>> call(ProductDto dto);
}
