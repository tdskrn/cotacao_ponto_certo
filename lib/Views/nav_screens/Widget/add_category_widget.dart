import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddCategoryWidget extends StatefulWidget {
  const AddCategoryWidget({super.key});

  @override
  State<AddCategoryWidget> createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String categoryName;
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
                  categoryName = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Category Name Must not be empty';
                  }
                  if (value.length < 6) {
                    return "Name Category is too short";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Insira o nome da Categoria",
                    hintText: "Insira o nome da Categoria"),
              ),
            ),
          ),
          ElevatedButton(
              child: Text('Salvar'),
              onPressed: () async {
                uploadCategory();
              })
        ],
      ),
    );
  }

  void uploadCategory() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show();
      try {
        await _firestore.collection('categories').add({
          'categoryName': categoryName,
        }).whenComplete(() {
          EasyLoading.showSuccess('Categoria adicionada com sucesso');
          _formKey.currentState!.reset();
        });
      } catch (error) {
        EasyLoading.showError(error.toString());
      }
    } else {
      EasyLoading.showError('Insira uma categoria válida');
    }
  }
}
