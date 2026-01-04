import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/document.dart';
import '../models/invoice_item.dart';
import '../models/resume_models.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/formatters.dart';

class PdfService {
  static Future<File> generateInvoicePDF(
    Document document,
    bool isPremium, {
    String? businessName,
    String? businessAddress,
    String? businessEmail,
    String? businessPhone,
  }) async {
    final pdf = pw.Document();

    // Parse invoice data
    final data = document.data;
    final customerName = data['customerName'] ?? '';
    final invoiceDate = DateTime.parse(data['invoiceDate']);
    final dueDate = DateTime.parse(data['dueDate']);
    final items = (data['items'] as List)
        .map((item) => InvoiceItem.fromMap(item))
        .toList();
    final subtotal = data['subtotal'] ?? 0.0;
    final taxPercent = data['taxPercent'] ?? 0.0;
    final taxAmount = data['taxAmount'] ?? 0.0;
    final discountPercent = data['discountPercent'] ?? 0.0;
    final discountAmount = data['discountAmount'] ?? 0.0;
    final notes = data['notes'] ?? '';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'INVOICE',
                        style: pw.TextStyle(
                          fontSize: 32,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue700,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        document.documentNumber,
                        style: const pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  if (businessName != null)
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          businessName,
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        if (businessAddress != null)
                          pw.Text(businessAddress,
                              style: const pw.TextStyle(fontSize: 10)),
                        if (businessEmail != null)
                          pw.Text(businessEmail,
                              style: const pw.TextStyle(fontSize: 10)),
                        if (businessPhone != null)
                          pw.Text(businessPhone,
                              style: const pw.TextStyle(fontSize: 10)),
                      ],
                    ),
                ],
              ),

              pw.SizedBox(height: 30),

              // Bill To & Dates
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'BILL TO',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        customerName,
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Row(
                        children: [
                          pw.Text('Invoice Date: ',
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Text(
                            Formatters.formatDate(invoiceDate),
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 4),
                      pw.Row(
                        children: [
                          pw.Text('Due Date: ',
                              style: const pw.TextStyle(fontSize: 10)),
                          pw.Text(
                            Formatters.formatDate(dueDate),
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              // Items Table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  // Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: [
                      _buildTableCell('Description', isHeader: true),
                      _buildTableCell('Qty', isHeader: true),
                      _buildTableCell('Rate', isHeader: true),
                      _buildTableCell('Amount', isHeader: true),
                    ],
                  ),
                  // Items
                  ...items.map((item) => pw.TableRow(
                        children: [
                          _buildTableCell(item.description),
                          _buildTableCell(item.quantity.toString()),
                          _buildTableCell(
                            Formatters.formatCurrency(
                                item.rate, document.currency),
                          ),
                          _buildTableCell(
                            Formatters.formatCurrency(
                                item.subtotal, document.currency),
                          ),
                        ],
                      )),
                ],
              ),

              pw.SizedBox(height: 20),

              // Totals
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      _buildTotalRow('Subtotal',
                          Formatters.formatCurrency(subtotal, document.currency)),
                      if (discountPercent > 0)
                        _buildTotalRow(
                          'Discount ($discountPercent%)',
                          '-${Formatters.formatCurrency(discountAmount, document.currency)}',
                        ),
                      if (taxPercent > 0)
                        _buildTotalRow(
                          'Tax ($taxPercent%)',
                          Formatters.formatCurrency(taxAmount, document.currency),
                        ),
                      pw.Divider(),
                      _buildTotalRow(
                        'TOTAL',
                        Formatters.formatCurrency(
                            document.totalAmount, document.currency),
                        isTotal: true,
                      ),
                    ],
                  ),
                ],
              ),

              if (notes.isNotEmpty) ...[
                pw.SizedBox(height: 30),
                pw.Text(
                  'Notes',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(notes, style: const pw.TextStyle(fontSize: 10)),
              ],

              pw.Spacer(),

              // Watermark for free users
              if (!isPremium)
                pw.Center(
                  child: pw.Text(
                    AppConstants.watermarkText,
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );

    return _savePDF(pdf, document.documentNumber);
  }

  static Future<File> generateReceiptPDF(
    Document document,
    bool isPremium,
  ) async {
    final pdf = pw.Document();
    final data = document.data;
    final customerName = data['customerName'] ?? '';
    final receiptDate = DateTime.parse(data['receiptDate']);
    final paymentMethod = data['paymentMethod'] ?? 'Cash';
    final items = (data['items'] as List)
        .map((item) => InvoiceItem.fromMap(item))
        .toList();
    final subtotal = data['subtotal'] ?? 0.0;
    final taxPercent = data['taxPercent'] ?? 0.0;
    final taxAmount = data['taxAmount'] ?? 0.0;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'RECEIPT',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.Text(
                  document.documentNumber,
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),
              _buildInfoRow('Customer', customerName),
              _buildInfoRow('Date', Formatters.formatDate(receiptDate)),
              _buildInfoRow('Payment Method', paymentMethod),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),
              ...items.map((item) => pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          '${item.description} (${item.quantity}x)',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ),
                      pw.Text(
                        Formatters.formatCurrency(
                            item.subtotal, document.currency),
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  )),
              pw.SizedBox(height: 20),
              pw.Divider(),
              _buildTotalRow('Subtotal',
                  Formatters.formatCurrency(subtotal, document.currency)),
              if (taxPercent > 0)
                _buildTotalRow(
                  'Tax ($taxPercent%)',
                  Formatters.formatCurrency(taxAmount, document.currency),
                ),
              pw.Divider(),
              _buildTotalRow(
                'TOTAL PAID',
                Formatters.formatCurrency(
                    document.totalAmount, document.currency),
                isTotal: true,
              ),
              pw.Spacer(),
              if (!isPremium)
                pw.Center(
                  child: pw.Text(
                    AppConstants.watermarkText,
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );

    return _savePDF(pdf, document.documentNumber);
  }

  static Future<File> generateResumePDF(
    Document document,
    bool isPremium,
  ) async {
    final pdf = pw.Document();
    final data = document.data;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      data['fullName'] ?? '',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      '${data['email'] ?? ''} | ${data['phone'] ?? ''} | ${data['address'] ?? ''}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Summary
              if (data['summary'] != null && data['summary'].isNotEmpty) ...[
                _buildSectionTitle('PROFESSIONAL SUMMARY'),
                pw.Text(data['summary'], style: const pw.TextStyle(fontSize: 10)),
                pw.SizedBox(height: 15),
              ],

              // Experience
              if (data['experiences'] != null &&
                  (data['experiences'] as List).isNotEmpty) ...[
                _buildSectionTitle('EXPERIENCE'),
                ...((data['experiences'] as List).map((exp) {
                  final experience = Experience.fromMap(exp);
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        experience.position,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '${experience.company} | ${experience.startDate} - ${experience.endDate}',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontStyle: pw.FontStyle.italic,
                        ),
                      ),
                      if (experience.description != null)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 4),
                          child: pw.Text(
                            experience.description!,
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ),
                      pw.SizedBox(height: 10),
                    ],
                  );
                })),
              ],

              // Education
              if (data['educations'] != null &&
                  (data['educations'] as List).isNotEmpty) ...[
                _buildSectionTitle('EDUCATION'),
                ...((data['educations'] as List).map((edu) {
                  final education = Education.fromMap(edu);
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        education.degree,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '${education.institution} | ${education.startDate} - ${education.endDate}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.SizedBox(height: 10),
                    ],
                  );
                })),
              ],

              // Skills
              if (data['skills'] != null &&
                  (data['skills'] as List).isNotEmpty) ...[
                _buildSectionTitle('SKILLS'),
                pw.Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: (data['skills'] as List).map((skillMap) {
                    final skill = Skill.fromMap(skillMap);
                    return pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey300,
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Text(
                        skill.name,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    );
                  }).toList(),
                ),
              ],

              pw.Spacer(),
              if (!isPremium)
                pw.Center(
                  child: pw.Text(
                    AppConstants.watermarkText,
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );

    return _savePDF(pdf, document.documentNumber);
  }

  static Future<File> generateGenericPDF(
    Document document,
    bool isPremium,
  ) async {
    final pdf = pw.Document();
    final data = document.data;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                document.title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                document.documentNumber,
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Text(
                data['content'] ?? '',
                style: const pw.TextStyle(fontSize: 11),
              ),
              pw.Spacer(),
              if (!isPremium)
                pw.Center(
                  child: pw.Text(
                    AppConstants.watermarkText,
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );

    return _savePDF(pdf, document.documentNumber);
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 11 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget _buildTotalRow(String label, String value,
      {bool isTotal = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.SizedBox(width: 200),
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isTotal ? 14 : 11,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.SizedBox(width: 40),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: isTotal ? 14 : 11,
              fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Text(value, style: const pw.TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue700,
          ),
        ),
        pw.Divider(),
        pw.SizedBox(height: 8),
      ],
    );
  }

  static Future<File> _savePDF(pw.Document pdf, String fileName) async {
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$fileName.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<void> sharePDF(File pdfFile) async {
    await Share.shareXFiles([XFile(pdfFile.path)]);
  }

  static Future<void> printPDF(File pdfFile) async {
    final bytes = await pdfFile.readAsBytes();
    await Printing.layoutPdf(onLayout: (format) async => bytes);
  }
}
