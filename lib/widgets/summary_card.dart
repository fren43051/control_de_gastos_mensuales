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
    // Determina si el tema actual es oscuro para ajustar los colores dinámicamente.
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // Color primario del gradiente, adaptado al tema.
            isDarkMode
                ? const Color(0xFF1E5128)  // Verde oscuro para modo oscuro.
                : const Color(0xFF2E7D32),  // Verde normal para modo claro.
            // Color secundario del gradiente, adaptado al tema.
            isDarkMode
                ? const Color(0xFF2E7D32)  // Verde medio para modo oscuro.
                : const Color(0xFF81C784),  // Verde claro para modo claro.
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // Color de la sombra adaptado al tema.
            color: isDarkMode
                ? Colors.black26 // Sombra más visible en modo oscuro.
                : Colors.black12, // Sombra más sutil en modo claro.
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen de Gastos',
            style: TextStyle(
              // El color del texto del título es blanco en ambos modos para contrastar con el gradiente.
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Divider(
            // Color del divisor adaptado al tema para una mejor integración visual.
            color: isDarkMode ? Colors.white24 : Colors.white30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Gastado:',
                style: TextStyle(
                  // Color del texto "Total Gastado" es blanco en ambos modos.
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                // Formatea el total de gastos a dos decimales.
                '\$${totalExpenses.toStringAsFixed(2)}',
                style: TextStyle(
                  // Color del monto total es blanco en ambos modos.
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Espacio vertical.
          // Muestra la fecha del último gasto si está disponible.
          if (lastExpenseDate != null)
            Text(
              'Último gasto: ${DateFormat('dd/MM/yyyy').format(lastExpenseDate!)}',
              style: TextStyle(
                // Color del texto de "Último gasto" es blanco semitransparente en ambos modos.
                color: Colors.white70,
              ),
            ),
          // Muestra la categoría con mayor gasto si está disponible.
          if (mostSpentCategory != null)
            Text(
              'Categoría principal: $mostSpentCategory',
              style: TextStyle(
                // Color del texto de "Categoría principal" es blanco semitransparente en ambos modos.
                color: Colors.white70,
              ),
            ),
        ],
      ),
    );
  }
}
