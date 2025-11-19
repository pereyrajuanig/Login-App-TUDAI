import '../models/contact.dart'; // modelo de contacto
import '../database/database_helper.dart'; // helper de base de datos SQLite

class ContactService { // servicio CRUD con persistencia en SQLite
  static bool _initialized = false; // flag de inicialización

  // Inicializa el servicio: asegura que la base de datos esté lista
  static Future<void> init() async {
    if (!_initialized) {
      await DatabaseHelper.instance.database; // inicializa la base de datos
      _initialized = true;
    }
  }

  /// Obtener todos los contactos
  static Future<List<Contact>> getAllContacts() async {
    await init();
    return await DatabaseHelper.instance.getAllContacts();
  }

  /// Obtener un contacto por ID
  static Future<Contact?> getContactById(int id) async {
    await init();
    return await DatabaseHelper.instance.getContactById(id);
  }

  /// Crear un nuevo contacto
  static Future<Contact> createContact({ // crea y agrega un nuevo contacto
    required String name,
    required String phone,
    required String email,
  }) async {
    await init();
    final avatar = _generateAvatar(name); // iniciales del nombre
    final nextId = await DatabaseHelper.instance.getNextId();
    final newContact = Contact(
      id: nextId,
      name: name,
      phone: phone,
      email: email,
      avatar: avatar,
    );
    
    await DatabaseHelper.instance.insertContact(newContact);
    return newContact; // retorna creado
  }

  /// Actualizar un contacto existente
  static Future<bool> updateContact({ // actualiza un contacto existente
    required int id,
    required String name,
    required String phone,
    required String email,
  }) async {
    await init();
    final existingContact = await DatabaseHelper.instance.getContactById(id);
    if (existingContact == null) return false;
    
    final avatar = _generateAvatar(name); // recalcula avatar si cambia nombre
    final updatedContact = Contact(
      id: id,
      name: name,
      phone: phone,
      email: email,
      avatar: avatar,
    );
    
    final rowsAffected = await DatabaseHelper.instance.updateContact(updatedContact);
    return rowsAffected > 0;
  }

  /// Eliminar un contacto
  static Future<bool> deleteContact(int id) async { // elimina un contacto por id
    await init();
    final rowsAffected = await DatabaseHelper.instance.deleteContact(id);
    return rowsAffected > 0;
  }

  /// Buscar contactos por nombre, teléfono o email
  static Future<List<Contact>> searchContacts(String query) async { // filtra por nombre/telefono/email
    await init();
    if (query.isEmpty) return await getAllContacts(); // sin query -> todo
    return await DatabaseHelper.instance.searchContacts(query);
  }

  /// Generar avatar basado en el nombre
  static String _generateAvatar(String name) { // devuelve iniciales del nombre
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  /// Obtener estadísticas de contactos
  static Future<Map<String, int>> getContactStats() async { // estadisticas simples
    await init();
    return await DatabaseHelper.instance.getContactStats();
  }
}
