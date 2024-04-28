import 'package:cotacao_ponto_certo/app/presentation/Views/mainScreenView.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/addCategory/add_category_widget.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/addProduct/add_product_widget.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/showOrders/show_individual_order_widget.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/showOrders/show_orders_widget.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/show_product_widget.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: MainScreen.name,
      builder: (context, state) => MainScreen(),
    ),
    GoRoute(
      path: '/add-product',
      name: AddProductWidget.name,
      builder: (context, state) => AddProductWidget(),
    ),
    GoRoute(
      path: '/list-products',
      name: ListProductWidget.name,
      builder: (context, state) => ListProductWidget(),
    ),
    GoRoute(
      path: '/add-category',
      name: AddCategoryWidget.name,
      builder: (context, state) => AddCategoryWidget(),
    ),
    GoRoute(
      path: '/show-orders',
      name: ShowOrdersWidget.name,
      builder: (context, state) => ShowOrdersWidget(),
    ),
    GoRoute(
      path: '/show-individual-order',
      name: ShowIndividualOrderWidget.name,
      builder: (context, state) {
        final invoiceData = state.extra;
        return ShowIndividualOrderWidget(
          invoiceData: invoiceData,
        );
      },
    ),
  ],
);
