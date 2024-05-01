import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotacao_ponto_certo/app/config/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddProductWidget extends StatefulWidget {
  static const String name = 'add-product';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Produto'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Flexible(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    onChanged: (value) {
                      productName = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor insira um nome';
                      }
                      if (value.length < 2) {
                        return "O nome é muito curto";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Insira o nome do Produto",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Flexible(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    onChanged: (value) {
                      productUnity = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Insira uma unidade de medida';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Insira a unidade de medida",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    hintText: "Selecione uma categoria",
                  ),
                  validator: (value) =>
                      value == null ? 'Selecione uma categoria' : null,
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
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: Text(
                    'Salvar',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () async {
                    saveProduct();
                  })
            ],
          ),
        ),
      ),
    );
  }

  void saveProduct() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Aguarde um momento...');
      try {
        final productId = Uuid().v4();
        final upperProductName =
            removeSpecialCharacters(productName.toUpperCase());
        final upperProductUnity =
            removeSpecialCharacters(productUnity.toUpperCase());

        await _firestore.collection('products').doc(productId).set({
          'productId': productId,
          'productName': upperProductName,
          'productUnity': upperProductUnity,
          'productCategory': productCategory,
          'quantity': 0,
          'created_at': DateTime.now(),
          'last_modified': DateTime.now(),
        }).whenComplete(() {
          _formKey.currentState!.reset();
          EasyLoading.dismiss();
          context.pop();
        });
      } catch (error) {
        EasyLoading.showError("Algum erro ocorreu, tente novamente");
      }
    }
  }
}
