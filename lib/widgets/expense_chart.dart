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

    // Calcular el total para los porcentajes
    final double totalExpense = expenses.fold(0.0, (sum, expense) => sum + expense.amount);

    // Preparar datos para el gráfico - mostrar todos los porcentajes
    final pieChartSections = categoryTotals.entries.map((entry) {
      final color = _getCategoryColor(entry.key);
      final percentage = (entry.value / totalExpense) * 100;

      // Ajustar el tamaño del texto según el porcentaje para evitar solapamiento
      final fontSize = percentage < 5 ? 8.0 : 10.0;

      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%', // Mostrar todos los porcentajes
        color: color,
        radius: 80,
        titlePositionPercentageOffset: 0.6, // Mover etiquetas hacia el borde
        titleStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: fontSize, // Texto más pequeño para segmentos pequeños
          shadows: const [
            Shadow(blurRadius: 3),
          ],
        ),
      );
    }).toList();

    // Usar un Row para posicionar leyendas a la derecha del gráfico
    return Container(
      padding: const EdgeInsets.only(top: 25.0, bottom: 10.0), // Más espacio en la parte superior
      height: 200, // Mantener altura para asegurar que todas las leyendas sean visibles
      child: Row(
        children: [
          // Gráfico a la izquierda
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sections: pieChartSections,
                centerSpaceRadius: 30, // Centro más grande
                sectionsSpace: 2,
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    // Interacción táctil
                  },
                ),
              ),
            ),
          ),
          // Leyendas a la derecha con espacio suficiente en ambos lados
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0), // Margen horizontal adecuado
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categoryTotals.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getCategoryColor(entry.key),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entry.key,
                              style: const TextStyle(fontSize: 11),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
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