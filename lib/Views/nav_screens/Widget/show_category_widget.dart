import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ShowCategoryAlertDialog extends StatelessWidget {
  final TextEditingController _categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Todas as Categorias'),
      content: Container(
        width: double.maxFinite,
        height: 300,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('categories')
              .orderBy('categoryName')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
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
                final categoryData = snapshot.data!.docs[index];
                return Card(
                  child: ListTile(
                    title: Text(categoryData['categoryName']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              _categoryController.text =
                                  categoryData['categoryName'];
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Edit Category',
                                        hintText: 'Edit Category',
                                        border: OutlineInputBorder(),
                                        suffixIcon: Icon(Icons.edit),
                                        filled: true,
                                      ),
                                      controller: _categoryController,
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancelar")),
                                      ElevatedButton(
                                          onPressed: () async {
                                            EasyLoading.show();
                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('categories')
                                                  .doc(categoryData.id)
                                                  .update({
                                                "categoryName":
                                                    _categoryController.text
                                              }).whenComplete(() {
                                                EasyLoading.showSuccess(
                                                    'Alterado com sucesso');
                                                Navigator.of(context).pop();
                                              });
                                            } catch (error) {
                                              EasyLoading.showError(
                                                  error.toString());
                                            }
                                          },
                                          child: Text("Salvar")),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Fechar'),
        ),
      ],
    );
  }
}
