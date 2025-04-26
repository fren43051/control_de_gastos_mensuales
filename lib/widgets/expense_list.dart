import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../screens/expense_form.dart';
import '../database/database_helper.dart';
import 'expense_card.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final Function refreshExpenses;

  const ExpenseList({
    super.key,
    required this.expenses,
    required this.refreshExpenses,
  });

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.money_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay gastos registrados',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return ExpenseCard(
          expense: expense,
          onEdit: () async {
            // Navegar a la pantalla de edición
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpenseForm(expense: expense),
              ),
            ).then((_) => refreshExpenses());
          },
          onDelete: () async {
            // Mostrar diálogo de confirmación
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirmar eliminación'),
                content: const Text('¿Está seguro de que desea eliminar este gasto?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final dbHelper = DatabaseHelper();
                      await dbHelper.deleteExpense(expense.id!);
                      Navigator.pop(context);
                      refreshExpenses();
                    },
                    child: const Text(
                      'Eliminar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}