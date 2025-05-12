import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final Function onEdit;
  final Function onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Determina si el tema actual es oscuro.
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      // El color de la tarjeta se define en el tema principal (main.dart)
      // para el modo oscuro (ThemeData.cardTheme.color).
      // Para el modo claro, toma el color por defecto de Card.
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          expense.description,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            // Color del texto del título adaptable al tema.
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categoría: ${expense.category}',
              style: TextStyle(
                // Color del texto de la categoría adaptable al tema.
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            Text(
              'Fecha: ${DateFormat('dd/MM/yyyy').format(expense.date)}',
              style: TextStyle(
                // Color del texto de la fecha adaptable al tema.
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${expense.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                // Color del texto del monto adaptable al tema.
                color: isDarkMode
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).primaryColor,
                fontSize: 16,
              ),
            ),
            PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                // Color del ícono del menú adaptable al tema.
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              // Los colores del PopupMenuButton en sí (fondo) son manejados por el tema general.
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        // Color del ícono de editar adaptable al tema.
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Editar',
                        style: TextStyle(
                          // Color del texto "Editar" adaptable al tema.
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red), // Color rojo se mantiene.
                      SizedBox(width: 8),
                      Text('Eliminar', style: TextStyle(color: Colors.red)), // Color rojo se mantiene.
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

