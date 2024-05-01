import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ShowAllProducts extends StatefulWidget {
  const ShowAllProducts({super.key});

  @override
  State<ShowAllProducts> createState() => _ShowAllProductsState();
}

class _ShowAllProductsState extends State<ShowAllProducts> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String productName;
  late String productUnity;
  late String productCategory;
  String? productId;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List _categories = [];
  final Query query =
      FirebaseFirestore.instance.collection('products').orderBy("productName");

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
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FirestorePagination(
        query: query,
        limit: 10,
        itemBuilder: (context, documentSnapshot, index) {
          final productData = documentSnapshot.data() as Map<String, dynamic>?;
          if (productData == null) return Container();
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
                          productId = productData['productId'];
                          productName = productData['productName'];
                          productUnity = productData['productUnity'];
                          productCategory = productData['productCategory'];

                          return AlertDialog(
                              content: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Flexible(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
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
                                          labelText: "Insira o nome do Produto",
                                          hintText: "Insira o nome do Produto"),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
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
                                      .map<DropdownMenuItem<String>>((e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      productCategory = value.toString();
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
                                        productId = productData['productId'];

                                        if (_formKey.currentState!.validate()) {
                                          EasyLoading.show(
                                              status: 'Aguarde um momento...');
                                          try {
                                            await _firestore
                                                .collection('products')
                                                .doc(productId)
                                                .update({
                                              'productName':
                                                  productName.toUpperCase(),
                                              'productUnity':
                                                  productUnity.toUpperCase(),
                                              'productCategory':
                                                  productCategory.toUpperCase(),
                                              'last_modified': DateTime.now(),
                                            }).whenComplete(() {
                                              _formKey.currentState!.reset();
                                              EasyLoading.dismiss();
                                              Navigator.of(context).pop();
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
                                      .doc(productData['productId'])
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
  }
}
