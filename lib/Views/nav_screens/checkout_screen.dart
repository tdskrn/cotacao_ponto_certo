import 'package:cotacao_ponto_certo/Views/nav_screens/Widget/finished_lista_widget.dart';
import 'package:cotacao_ponto_certo/providers/cart_provider.dart';
import 'package:cotacao_ponto_certo/providers/invoice_service.dart';
import 'package:cotacao_ponto_certo/providers/pdf_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Widget _rowHeader(String text, int flex) {
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
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    final PdfService service = PdfService();
    final InvoiceService _invoiceService = InvoiceService();
    return AlertDialog(
      content: Container(
        width: double.maxFinite,
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  _rowHeader("QUANTIDADE", 1),
                  _rowHeader("UNIDADE", 1),
                  _rowHeader("DESCRICAO", 3),
                ],
              ),
              ProductWidgetCart(data: _cartProvider.cartItems)
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Retornar')),
        ElevatedButton(
            onPressed: () async {
              if (kIsWeb) {
                await service.printCustomerPdfWeb(_cartProvider.cartItems);
              } else {
                await service.printCustomersPdfMobile(_cartProvider.cartItems);
              }

              try {
                EasyLoading.show(status: "Salvando o pedido");
                await _invoiceService
                    .addInvoice(_cartProvider.cartItems)
                    .whenComplete(() {
                  EasyLoading.showSuccess("Pedido salvo com sucesso");
                  EasyLoading.dismiss();
                  _cartProvider.deleteAllCart();
                });
              } catch (e) {
                EasyLoading.showError(e.toString());
              }
              Navigator.of(context).pop();
            },
            child: Text('Salvar')),
      ],
    );
  }
}
