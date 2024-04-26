import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/all_product_screen.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoriesStream =
        FirebaseFirestore.instance.collection('categories').snapshots();

    return StreamBuilder(
      stream: _categoriesStream,
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

        return Container(
          height: MediaQuery.of(context).size.width - 50,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final categoryData = snapshot.data!.docs[index];
              return ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AllProductScreen(
                        categoryData: categoryData,
                      );
                    },
                  );
                },
                title: Text(categoryData['categoryName']),
              );
            },
          ),
        );
      },
    );
  }
}
