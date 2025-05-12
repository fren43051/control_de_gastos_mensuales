import 'dart:io'; // Necesario para verificar la plataforma (Windows, Linux, macOS).
import 'package:flutter/foundation.dart'; // Para kIsWeb, que verifica si la app corre en web.
import 'package:flutter/material.dart'; // Framework principal de Flutter para UI.
import 'package:flutter/services.dart'; // Para controlar la orientación del dispositivo.
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Para inicializar sqflite en escritorio.
import 'screens/home_screen.dart'; // Importa la pantalla principal de la aplicación.

// Punto de entrada principal de la aplicación.
void main() async {
  // Asegura que los bindings de Flutter estén inicializados antes de cualquier otra cosa.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialización específica de sqflite para plataformas de escritorio (Windows, Linux, macOS).
  // kIsWeb es una constante booleana que es true si la aplicación se ejecuta en un navegador web.
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    // Inicializa el backend FFI para sqflite, necesario para que funcione en escritorio.
    sqfliteFfiInit();
  }

  // Configura las orientaciones preferidas de la aplicación a vertical (arriba y abajo).
  // Esto evita que la aplicación rote a modo horizontal.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Ejecuta la aplicación Flutter.
  runApp(const MyApp());
}

// Widget principal de la aplicación, que es un StatelessWidget ya que su estado no cambia.
class MyApp extends StatelessWidget {
  // Constructor constante para el widget MyApp.
  const MyApp({super.key});

  // Método build que describe la parte de la interfaz de usuario representada por este widget.
  @override
  Widget build(BuildContext context) {
    // MaterialApp es un widget de conveniencia que envuelve una serie de widgets
    // que son comúnmente requeridos para aplicaciones Material Design.
    return MaterialApp(
      title: 'Control de Gastos', // Título de la aplicación, usado por el sistema operativo.
      debugShowCheckedModeBanner: false, // Oculta el banner de "debug" en la esquina superior derecha.

      // Define el tema claro de la aplicación.
      theme: ThemeData(
        // Esquema de colores basado en un color semilla (seedColor).
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), // Color principal para generar la paleta.
          primary: const Color(0xFF2E7D32), // Color primario explícito.
          secondary: const Color(0xFF81C784), // Color secundario explícito.
          background: Colors.grey[50], // Color de fondo para el tema claro.
          brightness: Brightness.light, // Indica que este es un tema claro.
        ),
        useMaterial3: true, // Habilita el uso de componentes de Material Design 3.
        fontFamily: 'Roboto', // Fuente predeterminada para la aplicación.

        // Tema para las AppBars en modo claro.
        appBarTheme: const AppBarTheme(
          centerTitle: true, // Centra el título en la AppBar.
          elevation: 2, // Sombra debajo de la AppBar.
          backgroundColor: Color(0xFF2E7D32), // Color de fondo de la AppBar.
          foregroundColor: Colors.white, // Color del texto y los íconos en la AppBar.
        ),

        // Tema para los FloatingActionButtons en modo claro.
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF2E7D32), // Color de fondo del FAB.
          foregroundColor: Colors.white, // Color del ícono del FAB.
        ),

        // Tema para los Cards en modo claro.
        cardTheme: CardTheme(
          elevation: 3, // Sombra de las tarjetas.
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Bordes redondeados.
        ),
        scaffoldBackgroundColor: Colors.grey[50], // Color de fondo para los Scaffolds.
      ),

      // Define el tema oscuro de la aplicación.
      darkTheme: ThemeData(
        // Esquema de colores para el tema oscuro.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), // Color semilla también para el tema oscuro.
          primary: const Color(0xFF2E7D32), // Primario.
          secondary: const Color(0xFF81C784), // Secundario.
          brightness: Brightness.dark, // Indica que este es un tema oscuro.
          background: const Color(0xFF121212), // Color de fondo oscuro principal.
          surface: const Color(0xFF1E1E1E), // Color de superficie para elementos como Cards.
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',

        // Tema para las AppBars en modo oscuro.
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
          backgroundColor: Color(0xFF1E1E1E), // Color de fondo oscuro para AppBar.
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212), // Color de fondo oscuro para Scaffolds.

        // Tema para los Cards en modo oscuro.
        cardTheme: CardTheme(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: const Color(0xFF1E1E1E), // Color de fondo para las tarjetas en modo oscuro.
        ),
      ),

      // Define cómo se selecciona el tema (claro, oscuro o según el sistema).
      themeMode: ThemeMode.system,
      // Widget que se muestra como la pantalla de inicio de la aplicación.
      home: const HomeScreen(),
    );
  }
}

