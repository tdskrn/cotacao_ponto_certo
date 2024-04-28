import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ShowOrdersWidget extends StatefulWidget {
  static const String name = 'show-orders';
  const ShowOrdersWidget({super.key});

  @override
  State<ShowOrdersWidget> createState() => _ShowOrdersWidgetState();
}

class _ShowOrdersWidgetState extends State<ShowOrdersWidget> {
  final Query query = FirebaseFirestore.instance
      .collection('invoices')
      .orderBy('created_at', descending: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos'),
      ),
      body: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.7,
          child: FirestorePagination(
            query: query,
            limit: 5,
            itemBuilder: (context, documentSnapshot, index) {
              final invoiceData =
                  documentSnapshot.data() as Map<String, dynamic>?;
              if (invoiceData == null) return Container();

              return InkWell(
                onTap: () async {
                  context.push(
                    '/show-individual-order',
                    extra: {"invoiceData": invoiceData},
                  );
                },
                child: Card(
                  child: ListTile(
                    title: Text(DateFormat.MMMEd()
                            .format(invoiceData['created_at'].toDate()) +
                        ' --' +
                        DateFormat.jm()
                            .format(invoiceData['created_at'].toDate())),
                  ),
                ),
              );
            },
          )),
    );
  }
}
