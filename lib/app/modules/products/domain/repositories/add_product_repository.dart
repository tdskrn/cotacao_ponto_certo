import 'package:cotacao_ponto_certo/app/modules/products/domain/models/product_dto.dart';

abstract class AddProductRepository {
  Future<ProductDto> call(ProductDto dto);
}
