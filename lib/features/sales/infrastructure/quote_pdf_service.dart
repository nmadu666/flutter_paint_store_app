import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:flutter_paint_store_app/models/quote.dart';

class QuotePdfService {
  Future<void> generateAndPrintQuote({
    required List<QuoteItem> cartItems,
    required Customer? customer,
    required double totalAmount,
  }) async {
    final doc = pw.Document();

    // Load a font that supports Vietnamese characters
    // Load fonts in parallel for slightly better performance
    final fontDataList = await Future.wait([
      rootBundle.load("assets/fonts/Roboto_Condensed-Regular.ttf"),
      rootBundle.load("assets/fonts/Roboto_Condensed-Bold.ttf"),
    ]);

    final ttf = pw.Font.ttf(fontDataList[0]);
    final boldFont = pw.Font.ttf(fontDataList[1]);

    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: ttf, bold: boldFont),
        header: (context) => _buildHeader(),
        build: (context) => [
          _buildCustomerInfo(customer),
          pw.SizedBox(height: 20),
          _buildQuoteTable(cartItems, currencyFormat),
          pw.Divider(),
          _buildTotal(totalAmount, currencyFormat),
        ],
        footer: (context) => _buildFooter(),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  pw.Widget _buildHeader() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'CỬA HÀNG SƠN ABC',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
        ),
        pw.Text('Địa chỉ: 123 Đường XYZ, Quận 1, TP.HCM'),
        pw.Text('Điện thoại: 0987 654 321'),
        pw.SizedBox(height: 20),
        pw.Center(
          child: pw.Text(
            'BÁO GIÁ SẢN PHẨM',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24),
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Ngày: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
          ),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Widget _buildCustomerInfo(Customer? customer) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Kính gửi: ${customer?.name ?? 'Khách lẻ'}',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        if (customer?.address.isNotEmpty ?? false)
          pw.Text('Địa chỉ: ${customer!.address}'),
        if (customer?.phone.isNotEmpty ?? false)
          pw.Text('Điện thoại: ${customer!.phone}'),
      ],
    );
  }

  pw.Widget _buildQuoteTable(List<QuoteItem> items, NumberFormat format) {
    final headers = [
      'STT',
      'Tên sản phẩm',
      'Số lượng',
      'Đơn giá',
      'Thành tiền',
    ];
    final data = items.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return [
 (index + 1).toString(),
 item.product.name,
        item.quantity.toInt().toString(),
        format.format(item.unitPrice),
        format.format(item.totalPrice),
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      cellAlignment: pw.Alignment.center,
      cellAlignments: {1: pw.Alignment.centerLeft},
    );
  }

  pw.Widget _buildTotal(double total, NumberFormat format) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        'Tổng cộng: ${format.format(total)}',
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
      ),
    );
  }

  pw.Widget _buildFooter() {
    return pw.Center(
      child: pw.Text(
        'Cảm ơn quý khách!',
        style: const pw.TextStyle(fontSize: 12),
      ),
    );
  }
}
