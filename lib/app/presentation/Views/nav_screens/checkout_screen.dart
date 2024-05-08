import 'package:cotacao_ponto_certo/app/presentation/Views/nav_screens/Widget/finished_lista_widget.dart';
import 'package:cotacao_ponto_certo/app/models/providers/cart_provider.dart';
import 'package:cotacao_ponto_certo/app/models/providers/invoice_service.dart';
import 'package:cotacao_ponto_certo/app/models/providers/pdf_service.dart';
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
  final controller = TextEditingController();
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
        height: MediaQuery.of(context).size.height * 0.7,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Insira um nome para o seu pedido"),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira um nome';
                  }
                  return null;
                },
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Insira um nome',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  _rowHeader("QTD", 1),
                  _rowHeader("UND", 1),
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
          child: Text('Retornar'),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              EasyLoading.show(status: "Salvando o pedido");
              await _invoiceService
                  .addInvoice(_cartProvider.cartItems, controller.text,
                      _cartProvider.uid)
                  .whenComplete(() {
                EasyLoading.showSuccess("Pedido salvo com sucesso");
                EasyLoading.dismiss();
                _cartProvider.deleteAllCart();
                _cartProvider.setUid('');
              });
            } catch (e) {
              EasyLoading.showError(e.toString());
            }
            Navigator.of(context).pop();
          },
          child: Text('Salvar'),
        ),
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
                    .addInvoice(_cartProvider.cartItems, controller.text,
                        _cartProvider.uid)
                    .whenComplete(() {
                  EasyLoading.showSuccess("Pedido salvo com sucesso");
                  EasyLoading.dismiss();
                  _cartProvider.deleteAllCart();
                  _cartProvider.setUid('');
                });
              } catch (e) {
                EasyLoading.showError(e.toString());
              }
              Navigator.of(context).pop();
            },
            child: Text('Salvar e Enviar')),
      ],
    );
  }
}
