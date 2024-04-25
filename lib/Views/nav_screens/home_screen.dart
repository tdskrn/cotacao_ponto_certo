import 'package:cotacao_ponto_certo/Views/nav_screens/Widget/add_category_widget.dart';
import 'package:cotacao_ponto_certo/Views/nav_screens/Widget/add_product_widget.dart';
import 'package:cotacao_ponto_certo/Views/nav_screens/Widget/show_category_widget.dart';
import 'package:cotacao_ponto_certo/Views/nav_screens/Widget/show_product_widget.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: double.infinity,
        height: 50,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Adicionar Produto'),
              IconButton(
                  onPressed: () {
                    _showAddProductPopup(context);
                  },
                  icon: Icon(Icons.add)),
            ],
          ),
        ),
      ),
      Container(
        width: double.infinity,
        height: 50,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Listar Produtos'),
              IconButton(
                  onPressed: () {
                    _showListProductsPopup(context);
                  },
                  icon: Icon(Icons.add)),
            ],
          ),
        ),
      ),
      Container(
        width: double.infinity,
        height: 50,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Adicionar Categoria'),
              IconButton(
                  onPressed: () {
                    _showAddCategoryPopup(context);
                  },
                  icon: Icon(Icons.add)),
            ],
          ),
        ),
      ),
      Container(
        width: double.infinity,
        height: 50,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Listar Categorias'),
              IconButton(
                  onPressed: () {
                    _showListCategoriesPopup(context);
                  },
                  icon: Icon(Icons.list)),
            ],
          ),
        ),
      ),
      Container(
        width: double.infinity,
        height: 50,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Listar Pedidos'),
              IconButton(onPressed: () async {}, icon: Icon(Icons.list)),
            ],
          ),
        ),
      ),
    ]);
  }

  Future<void> _showAddCategoryPopup(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Categoria'),
          content: AddCategoryWidget(),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Fechar'))
          ],
        );
      },
    );
  }

  Future<void> _showListCategoriesPopup(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ShowCategoryAlertDialog();
        });
  }

  Future<void> _showListProductsPopup(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return ShowProductAlertDialog();
      },
    );
  }

  Future<void> _showAddProductPopup(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Produto'),
          content: AddProductWidget(),
          actions: [],
        );
      },
    );
  }
}
