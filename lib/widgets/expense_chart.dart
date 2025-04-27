// lib/widgets/expense_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    // Agrupar gastos por categoría
    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    // Preparar datos para el gráfico
    final pieChartSections = categoryTotals.entries.map((entry) {
      final color = _getCategoryColor(entry.key);
      return PieChartSectionData(
        value: entry.value,
        title: '${entry.key}\n${(entry.value / expenses.fold(0.0, (sum, expense) => sum + expense.amount) * 100).toStringAsFixed(1)}%',
        color: color,
        radius: 100,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      );
    }).toList();

    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: pieChartSections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    // Mapa de colores por categoría
    final colors = {
      'Comida': Colors.red,
      'Transporte': Colors.blue,
      'Entretenimiento': Colors.purple,
      'Servicios': Colors.orange,
      'Salud': Colors.green,
      'Educación': Colors.indigo,
      'Ropa': Colors.pink,
      'Otros': Colors.teal,
    };

    return colors[category] ?? Colors.grey;
  }
}