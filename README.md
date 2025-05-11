# Control de Gastos Personales

**Aplicación móvil desarrollada con Flutter para el control y gestión de gastos personales.**

---

## Descripción

Esta aplicación permite a los usuarios registrar, editar y eliminar sus gastos diarios, categorizarlos y visualizar un resumen general de sus finanzas. Desarrollada como proyecto para la asignatura **Desarrollo de Aplicaciones Móviles** - Mayo 2025.

---

## Características principales

- **Registro de gastos**: Agregar nuevos gastos con descripción, categoría, monto y fecha.  
- **Edición y eliminación**: Modificar o eliminar gastos existentes.  
- **Categorización**: Organizar gastos por categorías predefinidas.  
- **Resumen**: Visualizar el total de gastos en la pantalla principal.  
- **Almacenamiento local**: Persistencia de datos mediante SQLite.  
- **Interfaz intuitiva**: Diseño limpio y fácil de usar.  

---

## Tecnologías utilizadas

- **Flutter**: Framework para el desarrollo de la interfaz de usuario.  
- **Dart**: Lenguaje de programación usado por Flutter.  
- **SQLite**: Base de datos local para el almacenamiento de los gastos.  
- **Intl**: Biblioteca para formateo de fechas y números.  

---

## Requisitos del sistema

- **Flutter SDK**: Versión 3.0.0 o superior.  
- **Dart**: Versión 3.0.0 o superior.  
- **Android**: Dispositivo con Android 5.0+.  
- **iOS**: Dispositivo con iOS 11.0+.  

---

## Estructura del proyecto

```plaintext
lib/
├── main.dart                  // Punto de entrada de la aplicación
├── database/
│   └── database_helper.dart   // Configuración y métodos para SQLite
├── models/
│   └── expense.dart           // Modelo de datos para los gastos
├── screens/
│   ├── home_screen.dart       // Pantalla principal con resumen y lista
│   └── expense_form.dart      // Formulario para agregar/editar gastos
└── widgets/
    ├── expense_list.dart      // Widget para mostrar la lista de gastos
    ├── expense_card.dart      // Widget para mostrar un gasto individual
    └── summary_card.dart      // Widget para mostrar el resumen de gastos

___
Instalación

Clona este repositorio
Ejecuta flutter pub get para instalar las dependencias
Conecta un dispositivo o inicia un emulador
Ejecuta flutter run para iniciar la aplicación

Capturas de pantalla
[Aquí se insertarían capturas de pantalla de la aplicación]
Contribuidores
[Lista de integrantes del equipo]
Licencia
Este proyecto está licenciado bajo [tipo de licencia].

Desarrollado para la asignatura de Desarrollo de Aplicaciones Móviles - Mayo 2025.
