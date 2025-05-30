import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/expense.dart';
import '../services/report_service.dart';

// Pantalla para generar informes de gastos filtrados por fecha y categoría
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // Helper para acceder a la base de datos
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Valores predeterminados para el rango de fechas (últimos 30 días)
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  // Categoría seleccionada para filtrar (null significa todas las categorías)
  String? _selectedCategory;

  // Indicador de estado de generación del informe
  bool _isGenerating = false;

  // Lista de categorías disponibles para el filtro
  final List<String> _categories = [
    'Todas',
    'Comida',
    'Transporte',
    'Entretenimiento',
    'Servicios',
    'Salud',
    'Educación',
    'Ropa',
    'Otros'
  ];

  // Muestra un selector de fecha y actualiza la fecha inicial o final
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // Genera el informe PDF con los filtros aplicados
  Future<void> _generateReport() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      // Obtener los gastos filtrados
      List<Expense> expenses = await _dbHelper.getExpenses();

      // Filtrar por fecha
      expenses = expenses.where((expense) {
        return expense.date.isAfter(_startDate.subtract(const Duration(days: 1))) &&
               expense.date.isBefore(_endDate.add(const Duration(days: 1)));
      }).toList();

      // Filtrar por categoría si es necesario
      if (_selectedCategory != null && _selectedCategory != 'Todas') {
        expenses = expenses.where((expense) => expense.category == _selectedCategory).toList();
      }

      // Calcular total
      double totalAmount = expenses.fold(0, (sum, expense) => sum + expense.amount);

      // Generar PDF
      final file = await ReportService.generateExpenseReport(expenses, totalAmount);

      // Mostrar opciones
      if (mounted) {
        _showReportOptions(file);
      }
    } catch (e) {
      _showErrorDialog('Error al generar el informe: $e');
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  // Muestra un menú con opciones para ver o compartir el informe generado
  void _showReportOptions(File file) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('Ver informe'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    await ReportService.openPdfFile(file);
                  } catch (e) {
                    _showErrorDialog('No se pudo abrir el archivo: $e');
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Compartir informe'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    await ReportService.sharePdfFile(file);
                  } catch (e) {
                    _showErrorDialog('No se pudo compartir el archivo: $e');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Muestra un diálogo con un mensaje de error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Informe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tarjeta con opciones de filtrado
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rango de fechas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Selectores de fecha (desde/hasta)
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context, true),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Desde',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(_startDate),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context, false),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Hasta',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(_endDate),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Selector de categoría
                    DropdownButtonFormField<String>(
                      value: _selectedCategory ?? 'Todas',
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCategory = newValue == 'Todas' ? null : newValue;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Botón para generar el informe
            ElevatedButton(
              onPressed: _isGenerating ? null : _generateReport,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isGenerating
                  ? const CircularProgressIndicator()
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.picture_as_pdf),
                        SizedBox(width: 8),
                        Text(
                          'GENERAR INFORME',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}