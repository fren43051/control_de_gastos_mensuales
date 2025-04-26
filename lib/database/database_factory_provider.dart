import 'dart:io';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

DatabaseFactory get databaseFactory {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return ffi.databaseFactoryFfi;
  } else {
    return sqflite.databaseFactory;
  }
}

