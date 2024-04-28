import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/show_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        InkWell(
          onTap: () {
            // _showAddProductPopup(context);
            context.push('/add-product');
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
            context.push('/list-products');
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
                    'Editar Produtos',
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
            context.push('/add-category');
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
                    'Editar Categorias',
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
            context.push('/show-orders');
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

  Future<void> _showListCategoriesPopup(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ShowCategoryAlertDialog();
        });
  }
}
