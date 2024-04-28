import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/category_screen.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/finished_order.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/home_screen.dart';

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const String name = 'main-screen';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  List<Widget> _pages = [
    HomeScreen(),
    CategoryScreen(),
    FinishedOrder(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SUPERMERCADO PONTO CERTO'),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 1, 55, 100),
        unselectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(
          color: Colors.black,
        ),
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Lista de pedidos',
          ),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}
