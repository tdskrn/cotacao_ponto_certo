import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/product_list_widget.dart';

import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowOrdersWidget extends StatefulWidget {
  const ShowOrdersWidget({super.key});

  @override
  State<ShowOrdersWidget> createState() => _ShowOrdersWidgetState();
}

class _ShowOrdersWidgetState extends State<ShowOrdersWidget> {
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

  final Query query = FirebaseFirestore.instance
      .collection('invoices')
      .orderBy('created_at', descending: true);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pedidos'),
      content: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.7,
          child: FirestorePagination(
            query: query,
            limit: 5,
            itemBuilder: (context, documentSnapshot, index) {
              final invoiceData =
                  documentSnapshot.data() as Map<String, dynamic>?;
              if (invoiceData == null) return Container();

              final productsDynamic = invoiceData['products'];

              final products = productsDynamic.cast<Map<String, dynamic>>();

              return InkWell(
                onTap: () async {
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Invoices'),
                          content: SingleChildScrollView(
                            child: Container(
                              width: double.maxFinite,
                              height: 350,
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  Text(
                                    DateFormat.MMMEd().format(
                                            invoiceData['created_at']
                                                .toDate()) +
                                        ' --' +
                                        DateFormat.jm().format(
                                            invoiceData['created_at'].toDate()),
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
                                  ProductListWidget(products: products)
                                ]),
                              ),
                            ),
                          ),
                        );
                      });
                },
                child: Card(
                    child: ListTile(
                  title: Text(DateFormat.MMMEd()
                          .format(invoiceData['created_at'].toDate()) +
                      ' --' +
                      DateFormat.jm()
                          .format(invoiceData['created_at'].toDate())),
                )),
              );
            },
          )),
    );
  }
}
