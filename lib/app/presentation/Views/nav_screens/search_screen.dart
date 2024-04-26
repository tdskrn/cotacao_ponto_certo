import 'package:cotacao_ponto_certo/app/models/providers/local_base.dart';
import 'package:cotacao_ponto_certo/app/modules/products/data/repositories/add_product_repository_impl.dart';
import 'package:cotacao_ponto_certo/app/modules/products/domain/usecases/add_product_usecase_impl.dart';
import 'package:cotacao_ponto_certo/app/modules/products/external/datasources/add_product_datasource_impl_firebase.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/teste_controller.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final LocalBase _localBase = LocalBase();
  List<Map<String, dynamic>> _localProducts = [];

  Future<void> _loadProductsLocalDataBase() async {
    await _localBase.loadProducts();

    setState(() {
      _localProducts =
          _localBase.products.values.toList().cast<Map<String, dynamic>>();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProductsLocalDataBase();
  }

  @override
  Widget build(BuildContext context) {
    TesteController _testeController = TesteController(AddProductUseCaseImpl(
        AddProductReposytoryImpl(AddProductDataSourceImplFirebase())));
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      // ignore: unnecessary_null_comparison
      body: _localProducts == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _localProducts.length,
              itemBuilder: (context, index) {
                final productData = _localProducts[index];
                return Row(
                  children: [
                    Text(productData['productName']),
                    ElevatedButton(
                        onPressed: () async {
                          _testeController
                              .addProduct(productData['productDto']);
                        },
                        child: Text('Edit')),
                  ],
                );
              },
            ),
    );
  }
}
