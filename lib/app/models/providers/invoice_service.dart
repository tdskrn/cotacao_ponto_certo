import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotacao_ponto_certo/app/models/cart_attributes.dart';
import 'package:uuid/uuid.dart';

class InvoiceService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  addInvoice(
    Map<String, dynamic> data,
  ) async {
    List<CartAttributes> cartAttributes = [];

    data.forEach((key, value) {
      cartAttributes.add(value);
    });

    List<Map<String, dynamic>> cartProducts = [];

    cartAttributes.forEach((element) {
      cartProducts.add({
        "product_name": element.productName,
        "unity": element.unity,
        "quantity": element.quantity,
      });
    });

    final invoiceId = Uuid().v4();
    await firestore.collection('invoices').doc(invoiceId).set({
      'invoice_id': invoiceId,
      'created_at': DateTime.now(),
      'last_modified': DateTime.now(),
      'products': cartProducts,
    });
  }
}
