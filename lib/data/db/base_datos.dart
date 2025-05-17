import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BaseDatos {
  static Database? _db;

  static Future<Database> obtenerDB() async {
    if (_db != null) return _db!;

    final pathDB = join(await getDatabasesPath(), 'mascotas.db');

    _db = await openDatabase(
      pathDB,
      version: 1,
      onConfigure: (db) async {
        // Activa las claves foráneas
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE mascotas (
            id_mascota INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            especie TEXT,
            raza TEXT,
            fecha_nacimiento TEXT,
            foto TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE vacunas (
            id_vacuna INTEGER PRIMARY KEY AUTOINCREMENT,
            id_mascota INTEGER,
            nombre_vacuna TEXT,
            fecha_vacuna TEXT,
            proxima_vacuna TEXT,
            FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota) ON DELETE CASCADE
          )
        ''');
      },
    );

    return _db!;
  }
  }