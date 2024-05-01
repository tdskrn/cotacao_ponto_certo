import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotacao_ponto_certo/app/models/providers/searched_provider.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/showProduct/widgets/show_all.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/showProduct/widgets/show_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListProductWidget2 extends StatefulWidget {
  static const String name = 'list-products';
  const ListProductWidget2({super.key});

  @override
  State<ListProductWidget2> createState() => _ListProductWidget2State();
}

class _ListProductWidget2State extends State<ListProductWidget2> {
  late String productName;
  late String productUnity;
  late String productCategory;

  String _searchedValue = '';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? productId;
  List _categories = [];

  Stream<QuerySnapshot> getProductsStream() {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    Query query = _firestore.collection('products');
    if (_searchedValue.isEmpty) {
      return query.orderBy("productName").limit(5).snapshots();
    }

    return query
        .orderBy('productName')
        .startAt([_searchedValue.toUpperCase()]).endAt(
            [_searchedValue.toUpperCase() + '\uf8ff']).snapshots();
  }

  getCategories() async {
    return _firestore
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _categories.add(doc['categoryName']);
        });
      });
    });
  }

  @override
  initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<Search>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text("Todos os Produtos"),
            TextFormField(
              onFieldSubmitted: (value) {
                setState(() {
                  _searchedValue = value;
                  searchProvider.attValue(value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Pesquise pelos produtos',
                labelStyle: TextStyle(
                  color: Colors.black,
                  letterSpacing: 4,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.7,
          child: _searchedValue.isEmpty
              ? ShowAllProducts()
              : ShowSearchProducts(searchedValue: _searchedValue)),
    );
  }
}
