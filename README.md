
# 📱 Control de Gastos Personales

**Aplicación móvil desarrollada con Flutter para el control y gestión de gastos personales.**

---

## 📋 Descripción

Esta aplicación permite a los usuarios registrar, editar y eliminar sus gastos diarios, categorizarlos y visualizar un resumen general de sus finanzas.  
Desarrollada como proyecto para la asignatura **Desarrollo de Aplicaciones Móviles** - Mayo 2025.

---

## 🚀 Características principales

- ✅ **Registro de gastos**: Agregar nuevos gastos con descripción, categoría, monto y fecha.  
- ✏️ **Edición y eliminación**: Modificar o eliminar gastos existentes.  
- 📂 **Categorización**: Organizar gastos por categorías predefinidas.  
- 📊 **Resumen**: Visualizar el total de gastos en la pantalla principal.  
- 💾 **Almacenamiento local**: Persistencia de datos mediante SQLite.  
- 🎨 **Interfaz intuitiva**: Diseño limpio y fácil de usar.  

---

## 🛠️ Tecnologías utilizadas

- **Flutter**: Framework para el desarrollo de la interfaz de usuario.  
- **Dart**: Lenguaje de programación usado por Flutter.  
- **SQLite**: Base de datos local para el almacenamiento de los gastos.  
- **Intl**: Biblioteca para formateo de fechas y números.

---

## 💻 Requisitos del sistema

- **Flutter SDK**: Versión 3.0.0 o superior  
- **Dart**: Versión 3.0.0 o superior  
- **Android**: Dispositivo con Android 5.0+  
- **iOS**: Dispositivo con iOS 11.0+

---

## 📁 Estructura del proyecto

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
```

---

## 📦 Instalación

1. Clona este repositorio:
   ```bash
   git clone https://github.com/usuario/repositorio.git
   ```
2. Navega al directorio del proyecto:
   ```bash
   cd control_gastos_personales
   ```
3. Instala las dependencias:
   ```bash
   flutter pub get
   ```
4. Conecta un dispositivo físico o inicia un emulador.
5. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

---

## 📸 Capturas de pantalla

> [Aquí se insertarían capturas de pantalla de la aplicación]

---

## 👥 Contribuidores

- Karla María Bermúdez Arriaza   
- Valeria Nicole Arana Rodriguez  
- Kelvin Ernesto Sibrian 0.0   
- Herson Israel Arce Pérez
- Luis Miguel Alvarenga Jacobo
- Nelson Enrique Reyes Fabian

---

## 📄 Licencia

Este proyecto está licenciado bajo [tipo de licencia].  
Consulta el archivo `LICENSE` para más detalles.

---

## 🎓 Créditos

Desarrollado como parte del curso **Desarrollo de Aplicaciones Móviles** en Mayo de 2025.
