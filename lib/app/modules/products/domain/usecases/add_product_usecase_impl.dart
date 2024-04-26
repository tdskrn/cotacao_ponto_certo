import 'package:cotacao_ponto_certo/app/modules/products/domain/models/product_dto.dart';
import 'package:cotacao_ponto_certo/app/modules/products/domain/repositories/add_product_repository.dart';
import 'package:cotacao_ponto_certo/app/modules/products/domain/usecases/add_product_usecase.dart';
import 'package:cotacao_ponto_certo/app/modules/shared/response/response.dart';

class AddProductUseCaseImpl implements AddProductUseCase {
  AddProductUseCaseImpl(this._addProductRepository);
  final AddProductRepository _addProductRepository;

  @override
  Future<ResponsePresentation> call(ProductDto dto) async {
    try {
      var res = await _addProductRepository(dto);
      return ResponsePresentation(success: true, body: res, message: '');
    } catch (e) {
      return ResponsePresentation(
          success: false, message: e.toString(), body: null);
    }
  }
}
