import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/product_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowIndividualOrderWidget extends StatefulWidget {
  static const String name = 'show-individual-order';
  final dynamic invoiceData;
  const ShowIndividualOrderWidget({super.key, this.invoiceData});

  @override
  State<ShowIndividualOrderWidget> createState() =>
      _ShowIndividualOrderWidgetState();
}

class _ShowIndividualOrderWidgetState extends State<ShowIndividualOrderWidget> {
  Widget _rowHeader(String text, int flex, Color color) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade700,
          ),
          color: Colors.blue,
        ),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              text,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dynamic productsDynamic =
        widget.invoiceData['invoiceData']['products'];
    final List<Map<String, dynamic>> products = productsDynamic is List
        ? productsDynamic.cast<Map<String, dynamic>>()
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos'),
      ),
      body: SingleChildScrollView(
          child: Container(
        width: double.maxFinite,
        child: Column(children: [
          Text(
            DateFormat.MMMEd().format(
                    widget.invoiceData['invoiceData']['created_at'].toDate()) +
                ' --' +
                DateFormat.jm().format(
                    widget.invoiceData['invoiceData']['created_at'].toDate()),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              _rowHeader("QTD", 1, Colors.blue),
              _rowHeader("UND", 1, Colors.blue),
              _rowHeader("DESCRICAO", 3, Colors.blue),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ProductListWidget(products: products),
        ]),
      )),
    );
  }
}
