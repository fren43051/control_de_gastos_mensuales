import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/expense.dart';
// Importar tipos y ocultar getter conflictivo
import 'database_factory_provider.dart' as db_provider; // Importar de nuevo para usar el getter con prefijo

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // Inicialización del database usando el factory correcto (FFI o no)
  Future<Database> _initDatabase() async {
    if (_database != null) return _database!;

    final path = join(
      await db_provider.databaseFactory.getDatabasesPath(), // Usar databaseFactory con prefijo desde el proveedor
      'expenses_database.db',
    );

    _database = await db_provider.databaseFactory.openDatabase( // Usar databaseFactory con prefijo desde el proveedor
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _createDatabase,
      ),
    );

    return _database!;
  }

  // Getter para acceder al database desde otras clases
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Creación de la tabla de gastos
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  // =============================
  // Métodos CRUD (Create, Read, Update, Delete)
  // =============================

  // Crear un nuevo gasto
  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  // Leer todos los gastos
  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expenses');
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  // Actualizar un gasto
  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // Eliminar un gasto
  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Obtener el total de gastos
  Future<double> getTotalExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT SUM(amount) as total FROM expenses');

    if (result.isEmpty || result.first['total'] == null) {
      return 0.0;
    } else {
      return (result.first['total'] as num).toDouble();
    }
  }
}