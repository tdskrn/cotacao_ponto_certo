import 'package:cotacao_ponto_certo/app/modules/products/domain/models/product_dto.dart';
import 'package:cotacao_ponto_certo/app/modules/shared/response/response.dart';

abstract class AddProductUseCase {
  Future<ResponsePresentation> call(ProductDto dto);
}
