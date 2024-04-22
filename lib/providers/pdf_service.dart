import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:cotacao_ponto_certo/models/cart_attributes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';

class PdfService {
  Future<void> printCustomersPdfMobile(Map<String, CartAttributes> data) async {
    PdfFontFamily helvetica = PdfFontFamily.helvetica;
    // double dinamicDistance = 180;

    List<CartAttributes> cartData = [];

    data.forEach((key, value) {
      cartData.add(value);
    });

    PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    PdfSolidBrush brushBlack = PdfSolidBrush(PdfColor(0, 0, 0));
    Rect bounds = Rect.fromLTWH(110, 20, page.graphics.clientSize.width, 0);

    String currentDate =
        'DATA: ' + DateFormat('dd-MM-yyyy').format(DateTime.now());

    page.graphics.drawString(
        "SUPERMERCADO PONTO CERTO", PdfStandardFont(helvetica, 16),
        brush: brushBlack, bounds: bounds);

    page.graphics.drawString(
        "Tel: (33) 3314-1087", PdfStandardFont(helvetica, 10),
        bounds: Rect.fromLTWH(
            230, bounds.top + 20, page.graphics.clientSize.width, 20));

    page.graphics.drawString(currentDate, PdfStandardFont(helvetica, 10),
        bounds: Rect.fromLTWH(
            350, bounds.top + 40, page.graphics.clientSize.width, 20));

    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 3);
    final List<double> columnWidths = [220, 80, 40];
    grid.headers.add(1);
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Descrição';
    header.cells[1].value = 'Quantidade';
    header.cells[2].value = 'Unidade';

    grid.columns[0].width = columnWidths[0];

    header.style = PdfGridCellStyle();
    for (final cartItem in cartData) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = cartItem.productName;
      row.cells[1].value = cartItem.quantity.toStringAsFixed(2);
      row.cells[2].value = cartItem.unity;
      // dinamicDistance += 35;
    }
    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 5, right: 3, top: 4, bottom: 5),
      backgroundBrush: PdfBrushes.white,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 10),
    );

    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, bounds.top + 80,
            page.graphics.clientSize.width, page.graphics.clientSize.height));

    List<int> bytes = await document.save();
    Uint8List file = Uint8List.fromList(bytes);

    Printing.sharePdf(bytes: file, filename: Uuid().v4().toString() + '.pdf');

    document.dispose();
  }

  Future<void> printCustomerPdfWeb(Map<String, CartAttributes> data) async {
    PdfFontFamily helvetica = PdfFontFamily.helvetica;
    // double dinamicDistance = 180;

    List<CartAttributes> cartData = [];

    data.forEach((key, value) {
      cartData.add(value);
    });

    PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    PdfSolidBrush brushBlack = PdfSolidBrush(PdfColor(0, 0, 0));
    Rect bounds = Rect.fromLTWH(110, 20, page.graphics.clientSize.width, 0);

    String currentDate =
        'DATA: ' + DateFormat('dd-MM-yyyy').format(DateTime.now());

    page.graphics.drawString(
        "SUPERMERCADO PONTO CERTO", PdfStandardFont(helvetica, 16),
        brush: brushBlack, bounds: bounds);

    page.graphics.drawString(
        "Tel: (33) 3314-1087", PdfStandardFont(helvetica, 10),
        bounds: Rect.fromLTWH(
            230, bounds.top + 20, page.graphics.clientSize.width, 20));

    page.graphics.drawString(currentDate, PdfStandardFont(helvetica, 10),
        bounds: Rect.fromLTWH(
            350, bounds.top + 40, page.graphics.clientSize.width, 20));

    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 3);
    final List<double> columnWidths = [220, 80, 40];
    grid.headers.add(1);
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Descrição';
    header.cells[1].value = 'Quantidade';
    header.cells[2].value = 'Unidade';

    grid.columns[0].width = columnWidths[0];

    header.style = PdfGridCellStyle();
    for (final cartItem in cartData) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = cartItem.productName;
      row.cells[1].value = cartItem.quantity.toStringAsFixed(2);
      row.cells[2].value = cartItem.unity;
      // dinamicDistance += 35;
    }
    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 5, right: 3, top: 4, bottom: 5),
      backgroundBrush: PdfBrushes.white,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 10),
    );

    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(0, bounds.top + 80,
            page.graphics.clientSize.width, page.graphics.clientSize.height));

    List<int> bytes = await document.save();
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "document.pdf")
      ..click();

    document.dispose();
  }
}
