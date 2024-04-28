import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

class ShowProductAlertDialog extends StatefulWidget {
  const ShowProductAlertDialog({super.key});

  @override
  State<ShowProductAlertDialog> createState() => _ShowProductAlertDialogState();
}

class _ShowProductAlertDialogState extends State<ShowProductAlertDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    return AlertDialog(
      title: Column(
        children: [
          Text("Todos os Produtos"),
          TextFormField(
            onFieldSubmitted: (value) {
              setState(() {
                _searchedValue = value;
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
      content: Container(
        width: double.maxFinite,
        height: 300,
        child: StreamBuilder(
            stream: getProductsStream(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.cyan,
                  ),
                );
              }

              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final productData = snapshot.data!.docs[index];
                    return Card(
                      child: ListTile(
                        title: Text(productData['productName']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    productId = productData.id;
                                    productName = productData['productName'];
                                    productUnity = productData['productUnity'];
                                    productCategory =
                                        productData['productCategory'];

                                    return AlertDialog(
                                        content: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Flexible(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: TextFormField(
                                                initialValue: productName,
                                                onChanged: (value) {
                                                  productName = value;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please Product Name Must not be empty';
                                                  }
                                                  if (value.length < 2) {
                                                    return "Name Product is too short";
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                    labelText:
                                                        "Insira o nome do Produto",
                                                    hintText:
                                                        "Insira o nome do Produto"),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: TextFormField(
                                                initialValue: productUnity,
                                                onChanged: (value) {
                                                  productUnity = value;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please Unity Must not be empty';
                                                  }

                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                    labelText:
                                                        "Insira o nome da unidade medida",
                                                    hintText:
                                                        "Insira o nome da unidade medida"),
                                              ),
                                            ),
                                          ),
                                          DropdownButtonFormField(
                                            value: productCategory,
                                            items: _categories
                                                .map<DropdownMenuItem<String>>(
                                                    (e) {
                                              return DropdownMenuItem(
                                                value: e,
                                                child: Text(e),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                productCategory =
                                                    value.toString();
                                              });
                                            },
                                          ),
                                          Row(children: [
                                            ElevatedButton(
                                                child: Text('Cancelar'),
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                }),
                                            ElevatedButton(
                                                child: Text('Salvar'),
                                                onPressed: () async {
                                                  productId = productData.id;

                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    EasyLoading.show(
                                                        status:
                                                            'Aguarde um momento...');
                                                    try {
                                                      await _firestore
                                                          .collection(
                                                              'products')
                                                          .doc(productId)
                                                          .update({
                                                        'productName':
                                                            productName,
                                                        'productUnity':
                                                            productUnity,
                                                        'productCategory':
                                                            productCategory,
                                                        'last_modified':
                                                            DateTime.now(),
                                                      }).whenComplete(() {
                                                        _formKey.currentState!
                                                            .reset();
                                                        EasyLoading.dismiss();
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    } catch (error) {
                                                      EasyLoading.showError(
                                                          error.toString());
                                                    }
                                                  }
                                                })
                                          ])
                                        ],
                                      ),
                                    ));
                                  },
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text('Tem certeza?'),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Voltar'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('products')
                                                .doc(productData.id)
                                                .delete();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Deletar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.delete),
                            )
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
