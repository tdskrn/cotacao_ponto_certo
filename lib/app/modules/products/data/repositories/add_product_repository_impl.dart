import 'package:cotacao_ponto_certo/app/modules/products/data/datasources/add_product_datasource.dart';
import 'package:cotacao_ponto_certo/app/modules/products/domain/models/product_dto.dart';
import 'package:cotacao_ponto_certo/app/modules/products/domain/repositories/add_product_repository.dart';

class AddProductReposytoryImpl implements AddProductRepository {
  AddProductReposytoryImpl(this._addProductDataSource);
  final AddProductDataSource _addProductDataSource;

  @override
  Future<ProductDto> call(ProductDto dto) async {
    try {
      var res = await _addProductDataSource(dto);
      return ProductDto.fromMap(res);
    } catch (e) {
      rethrow;
    }
  }
}
