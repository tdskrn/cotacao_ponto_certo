import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
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
  @override
  void dispose() {
    super.dispose();
  }

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
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          child: FirestoreListView(
              pageSize: 5,
              query: query,
              itemBuilder: (context, snapshot) {
                final invoiceData = snapshot.data() as Map<String, dynamic>?;
                if (invoiceData == null) return Container();
                return InkWell(
                  onTap: () async {},
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: Colors.grey.shade700,
                        )),
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  DateFormat.MMMEd().format(
                                          invoiceData['created_at'].toDate()) +
                                      ' --' +
                                      DateFormat.jm().format(
                                        invoiceData['created_at'].toDate(),
                                      )),
                            ],
                          ),
                          Text(
                            invoiceData['name'] ?? '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    iconSize: 45,
                                    color: Colors.blue,
                                    onPressed: () async {
                                      setState(() {});
                                      context.push(
                                        '/show-individual-order',
                                        extra: {"invoiceData": invoiceData},
                                      );
                                    },
                                    icon: Icon(Icons.remove_red_eye_outlined)),
                                IconButton(
                                    iconSize: 45,
                                    color: Colors.red,
                                    onPressed: () async {
                                      return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text('Tem certeza?'),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Voltar'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection('invoices')
                                                        .doc(invoiceData[
                                                            'invoice_id'])
                                                        .delete();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Deletar'),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.delete))
                              ])
                        ]),
                  ),
                );
              })

          // FirestorePagination(
          //   query: query,
          //   limit: 5,
          //   itemBuilder: (context, documentSnapshot, index) {
          //     final invoiceData =
          //         documentSnapshot.data() as Map<String, dynamic>?;
          //     if (invoiceData == null) return Container();

          //     return InkWell(
          //       onTap: () async {
          //         context.push(
          //           '/show-individual-order',
          //           extra: {"invoiceData": invoiceData},
          //         );
          //       },
          //       child: Card(
          //         child: ListTile(
          //           trailing: Text(
          //             invoiceData['name'] ?? '',
          //             style:
          //                 TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          //           ),
          //           title: Text(DateFormat.MMMEd()
          //                   .format(invoiceData['created_at'].toDate()) +
          //               ' --' +
          //               DateFormat.jm()
          //                   .format(invoiceData['created_at'].toDate())),
          //         ),
          //       ),
          //     );
          //   },
          // ),
          ),
    );
  }
}
