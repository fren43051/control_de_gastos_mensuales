import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryCard extends StatelessWidget {
  final double totalExpenses;
  final DateTime? lastExpenseDate;
  final String? mostSpentCategory;

  const SummaryCard({
    super.key,
    required this.totalExpenses,
    this.lastExpenseDate,
    this.mostSpentCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2E7D32), // Verde principal
            const Color(0xFF81C784), // Verde secundario
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen de Gastos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(color: Colors.white30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Gastado:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${totalExpenses.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (lastExpenseDate != null)
            Text(
              'Último gasto: ${DateFormat('dd/MM/yyyy').format(lastExpenseDate!)}',
              style: const TextStyle(color: Colors.white70),
            ),
          if (mostSpentCategory != null)
            Text(
              'Categoría principal: $mostSpentCategory',
              style: const TextStyle(color: Colors.white70),
            ),
        ],
      ),
    );
  }
}