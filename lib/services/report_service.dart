import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import '../models/expense.dart';

class ReportService {
  // Generar un informe PDF de gastos
  static Future<File> generateExpenseReport(List<Expense> expenses, double totalAmount) async {
    // Crear documento PDF
    final pdf = pw.Document();

    // Cargar fuente personalizada
    final font = await rootBundle.load("fonts/Roboto-Regular.ttf");
    final fontData = font.buffer.asUint8List();
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    // Agrupar gastos por categoría
    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    // Agregar página con título e información
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('Informe de Gastos', style: pw.TextStyle(fontSize: 24, font: ttf)),
            ),
            pw.Paragraph(
              text: 'Fecha de generación: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
              style: pw.TextStyle(font: ttf),
            ),
            pw.Paragraph(
              text: 'Total de gastos: \$${totalAmount.toStringAsFixed(2)}',
              style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),

            // Tabla de gastos por categoría
            pw.Header(
              level: 1,
              child: pw.Text('Resumen por Categoría', style: pw.TextStyle(font: ttf)),
            ),
            pw.TableHelper.fromTextArray(
              headers: ['Categoría', 'Monto Total', 'Porcentaje'],
              data: categoryTotals.entries.map((entry) {
                final percentage = '${(entry.value / totalAmount * 100).toStringAsFixed(1)}%';
                return [entry.key, '\$${entry.value.toStringAsFixed(2)}', percentage];
              }).toList(),
              headerStyle: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
              cellStyle: pw.TextStyle(font: ttf),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              border: null,
              headerHeight: 25,
              cellHeight: 25,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
              },
            ),
            pw.SizedBox(height: 20),

            // Lista detallada de gastos
            pw.Header(
              level: 1,
              child: pw.Text('Detalle de Gastos', style: pw.TextStyle(font: ttf)),
            ),
            pw.TableHelper.fromTextArray(
              headers: ['Fecha', 'Descripción', 'Categoría', 'Monto'],
              data: expenses.map((expense) {
                return [
                  DateFormat('dd/MM/yyyy').format(expense.date),
                  expense.description,
                  expense.category,
                  '\$${expense.amount.toStringAsFixed(2)}'
                ];
              }).toList(),
              headerStyle: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
              cellStyle: pw.TextStyle(font: ttf),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              border: null,
              headerHeight: 25,
              cellHeight: 25,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerRight,
              },
            ),
          ];
        },
        footer: (context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
              'Página ${context.pageNumber} de ${context.pagesCount}',
              style: pw.TextStyle(font: ttf, color: PdfColors.grey),
            ),
          );
        },
      ),
    );

    // Guardar documento
    final outputFile = await _saveDocument(pdf, 'informe_gastos.pdf');
    return outputFile;
  }

  // Guardar el documento en almacenamiento externo
  static Future<File> _saveDocument(pw.Document pdf, String fileName) async {
    // Solicitar permisos en Android
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }

    // Guardar el archivo
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }

  // Abrir el archivo PDF
  static Future<void> openPdfFile(File file) async {
    final result = await OpenFile.open(file.path);
    if (result.type != ResultType.done) {
      throw Exception('No se pudo abrir el archivo');
    }
  }

  // Compartir el archivo PDF
  static Future<void> sharePdfFile(File file) async {
    await Share.shareXFiles([XFile(file.path)], text: 'Informe de Gastos Personales');
  }
}