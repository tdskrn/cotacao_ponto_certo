import 'package:cotacao_ponto_certo/app/modules/products/data/datasources/add_product_datasource.dart';
import 'package:cotacao_ponto_certo/app/modules/products/domain/models/product_dto.dart';
import 'package:cotacao_ponto_certo/app/modules/shared/firebase/firebase_client.dart';

class AddProductDataSourceImplFirebase implements AddProductDataSource {
  @override
  Future<Map<String, dynamic>> call(ProductDto dto) async {
    final FirebaseClient _client = FirebaseClient();
    var res = await _client.addProduct(dto);

    return res;
  }
}
