import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotacao_ponto_certo/Views/nav_screens/Widget/productDetailScreen.dart';
import 'package:flutter/material.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key, this.categoryData});
  final dynamic categoryData;

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  late final ScrollController _scrollController;
  List<QueryDocumentSnapshot> _productsList = [];
  int _perPage = 5;
  bool _isLoading = false;
  late DocumentSnapshot _lastDocument;

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('productCategory',
            isEqualTo: widget.categoryData['categoryName'])
        .orderBy('productName')
        .limit(_perPage)
        .get();

    setState(() {
      _productsList = querySnapshot.docs;
      _lastDocument = querySnapshot.docs.last;
      _isLoading = false;
    });
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.yellow.shade900,
        ),
      ),
    );
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('productCategory',
            isEqualTo: widget.categoryData['categoryName'])
        .orderBy('productName')
        .startAfterDocument(_lastDocument)
        .limit(_perPage)
        .get();

    setState(() {
      _productsList.addAll(querySnapshot.docs);
      _lastDocument = querySnapshot.docs.last;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_infiniteScrolling);
    _loadProducts();
  }

  void _infiniteScrolling() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsForCategory = FirebaseFirestore
        .instance
        .collection('products')
        .orderBy('productName')
        .where('productCategory',
            isEqualTo: widget.categoryData['categoryName'])
        .snapshots();
    return AlertDialog(
      title: Text(widget.categoryData['categoryName']),
      content: Container(
        width: double.maxFinite,
        height: 300,
        child: StreamBuilder(
            stream: _productsForCategory,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow.shade900,
                  ),
                );
              }
              _productsList =
                  snapshot.data!.docs.cast<QueryDocumentSnapshot>().toList();

              return ListView.builder(
                  controller: _scrollController,
                  itemCount: _productsList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _productsList.length) {
                      if (_isLoading) {
                        return _buildLoadingIndicator();
                      } else {
                        return Container();
                      }
                    }

                    final productData = _productsList[index];
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: ProductDetailScreen(
                                productData: productData,
                              ),
                            );
                          },
                        );
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(productData['productName'])),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(productData['productUnity'])),
                          ],
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
