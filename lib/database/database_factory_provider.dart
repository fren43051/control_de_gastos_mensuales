import 'dart:io';

import 'package:flutter/foundation.dart'; // Para usar kIsWeb
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

sqflite.DatabaseFactory get databaseFactory {
  if (kIsWeb) {
    throw UnsupportedError('La base de datos no es compatible con Flutter Web.');
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return ffi.databaseFactoryFfi;
  } else {
    return sqflite.databaseFactory;
  }
}

