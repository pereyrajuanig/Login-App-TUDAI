import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact.dart';
import '../data/sample_contacts.dart';

// Helper para manejar la base de datos SQLite
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Obtiene la instancia de la base de datos (singleton)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('contacts.db');
    return _database!;
  }

  // Inicializa la base de datos y crea las tablas si no existen
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Crea la tabla de contactos
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        avatar TEXT NOT NULL
      )
    ''');

    // Inserta los contactos de ejemplo si la base de datos es nueva
    final sampleContacts = SampleContacts.getContacts();
    for (var contact in sampleContacts) {
      await db.insert('contacts', contact.toJson());
    }
  }

  // Cierra la base de datos
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }

  // Obtiene todos los contactos
  Future<List<Contact>> getAllContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('contacts', orderBy: 'id');
    return List.generate(maps.length, (i) => Contact.fromJson(maps[i]));
  }

  // Obtiene un contacto por ID
  Future<Contact?> getContactById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Contact.fromJson(maps.first);
  }

  // Inserta un nuevo contacto
  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return await db.insert('contacts', contact.toJson());
  }

  // Actualiza un contacto existente
  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update(
      'contacts',
      contact.toJson(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  // Elimina un contacto
  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Busca contactos por nombre, teléfono o email
  Future<List<Contact>> searchContacts(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contacts',
      where: 'name LIKE ? OR phone LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => Contact.fromJson(maps[i]));
  }

  // Obtiene el siguiente ID disponible
  Future<int> getNextId() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT MAX(id) as max_id FROM contacts',
    );
    final maxId = result.first['max_id'] as int?;
    return (maxId ?? 0) + 1;
  }

  // Obtiene estadísticas de contactos
  Future<Map<String, int>> getContactStats() async {
    final db = await database;
    final total = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM contacts'),
    ) ?? 0;
    final withEmail = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM contacts WHERE email != ""'),
    ) ?? 0;
    final withPhone = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM contacts WHERE phone != ""'),
    ) ?? 0;
    return {
      'total': total,
      'withEmail': withEmail,
      'withPhone': withPhone,
    };
  }
}

