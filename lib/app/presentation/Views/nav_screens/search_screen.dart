import 'package:cotacao_ponto_certo/app/models/providers/local_base.dart';
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
                return Text(productData['productName']);
              },
            ),
    );
  }
}
