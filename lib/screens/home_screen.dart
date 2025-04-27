// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/expense.dart';
import '../widgets/expense_list.dart';
import '../widgets/summary_card.dart';
import '../widgets/expense_chart.dart';
import 'expense_form.dart';
import 'report_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Expense> _expenses = [];
  double _totalExpenses = 0.0;
  bool _isLoading = true;
  String? _mostSpentCategory;
  DateTime? _lastExpenseDate;

  @override
  void initState() {
    super.initState();
    _refreshExpenses();
  }

  Future<void> _refreshExpenses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final expenses = await _dbHelper.getExpenses();
      final total = await _dbHelper.getTotalExpenses();

      // Encontrar la categoría con mayor gasto
      final Map<String, double> categoryTotals = {};
      for (var expense in expenses) {
        categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0) + expense.amount;
      }

      String? topCategory;
      double maxAmount = 0;
      categoryTotals.forEach((category, amount) {
        if (amount > maxAmount) {
          maxAmount = amount;
          topCategory = category;
        }
      });

      // Encontrar la fecha del último gasto
      DateTime? lastDate;
      if (expenses.isNotEmpty) {
        lastDate = expenses.reduce((a, b) => a.date.isAfter(b.date) ? a : b).date;
      }

      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        _expenses = expenses;
        _totalExpenses = total;
        _mostSpentCategory = topCategory;
        _lastExpenseDate = lastDate;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los gastos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Gastos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshExpenses,
            tooltip: 'Actualizar',
          ),
          IconButton(
            icon: const Icon(Icons.summarize),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportScreen()),
              );
            },
            tooltip: 'Generar Informe',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SummaryCard(
                  totalExpenses: _totalExpenses,
                  lastExpenseDate: _lastExpenseDate,
                  mostSpentCategory: _mostSpentCategory,
                ),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Icon(Icons.pie_chart, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Análisis de Gastos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _expenses.isNotEmpty
                          ? ExpenseChart(expenses: _expenses)
                          : const SizedBox(height: 100, child: Center(child: Text('No hay datos para mostrar'))),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.list_alt, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Transacciones Recientes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ExpenseList(
                      expenses: _expenses,
                      refreshExpenses: _refreshExpenses,
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExpenseForm()),
          ).then((_) => _refreshExpenses());
        },
        label: const Text('Nuevo Gasto'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}