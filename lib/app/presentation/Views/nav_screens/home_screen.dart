import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/add_category_widget.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/add_product_widget.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/show_category_widget.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/show_orders_widget.dart';
// import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/show_product_dialog2.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/show_product_widget.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        InkWell(
          onTap: () {
            _showAddProductPopup(context);
          },
          child: Container(
            width: double.infinity,
            height: 50,
            child: Card(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Adicionar Produto',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.add, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _showListProductsPopup(context);
          },
          child: Container(
            width: double.infinity,
            height: 50,
            child: Card(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Listar Produtos',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _showAddCategoryPopup(context);
          },
          child: Container(
            width: double.infinity,
            height: 50,
            child: Card(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Adicionar Categoria',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _showListCategoriesPopup(context);
          },
          child: Container(
            width: double.infinity,
            height: 50,
            child: Card(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Listar Categorias',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.list,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _showOrdersPopup(context);
          },
          child: Container(
            width: double.infinity,
            height: 50,
            child: Card(
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Listar Pedidos',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.list,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
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

  Future<void> _showOrdersPopup(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return ShowOrdersWidget();
        });
  }
}
