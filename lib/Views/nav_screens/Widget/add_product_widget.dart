import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uuid/uuid.dart';

class AddProductWidget extends StatefulWidget {
  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductWidget> {
  late String productName;
  late String productUnity;
  late String productCategory;
  List _categories = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text('Categorias'),
          ),
          Divider(
            color: Colors.grey,
          ),
          Flexible(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextFormField(
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
              width: MediaQuery.of(context).size.width * 0.3,
              child: TextFormField(
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
                    labelText: "Insira o nome da unidade medida",
                    hintText: "Insira o nome da unidade medida"),
              ),
            ),
          ),
          DropdownButtonFormField(
            items: _categories.map<DropdownMenuItem<String>>((e) {
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
          ElevatedButton(
              child: Text('Salvar'),
              onPressed: () async {
                saveProduct();
              })
        ],
      ),
    );
  }

  void saveProduct() async {
    EasyLoading.show(status: 'Aguarde um momento...');
    if (_formKey.currentState!.validate()) {
      try {
        final productId = Uuid().v4();
        await _firestore.collection('products').doc(productId).set({
          'productId': productId,
          'productName': productName,
          'productUnity': productUnity,
          'productCategory': productCategory,
          'quantity': 0,
        }).whenComplete(() {
          _formKey.currentState!.reset();
          EasyLoading.dismiss();
          Navigator.of(context).pop();
        });
      } catch (error) {
        EasyLoading.showError(error.toString());
      }
    }
  }
}
