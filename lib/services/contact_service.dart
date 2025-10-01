import 'dart:convert'; // para jsonEncode/jsonDecode
import 'package:shared_preferences/shared_preferences.dart'; // persistencia local
import '../models/contact.dart'; // modelo de contacto
import '../data/sample_contacts.dart'; // datos de ejemplo iniciales

class ContactService { // servicio CRUD con persistencia local
  static const String _prefsKey = 'contacts_json'; // clave en SharedPreferences
  static SharedPreferences? _prefs; // instancia cacheada

  static List<Contact> _contacts = <Contact>[]; // estado interno
  static int _nextId = 1; // contador de ids

  // Inicializa el servicio: carga desde disco o si no existe, usa datos de ejemplo
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final String? jsonString = _prefs!.getString(_prefsKey);
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
      _contacts = decoded
          .map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      _contacts = SampleContacts.getContacts();
      await _persist();
    }
    // Ajusta el siguiente id para no colisionar
    _nextId = (_contacts.isEmpty
            ? 0
            : _contacts.map((c) => c.id).reduce((a, b) => a > b ? a : b)) +
        1;
  }

  // Guarda en SharedPreferences la lista actual
  static Future<void> _persist() async {
    if (_prefs == null) return;
    final List<Map<String, dynamic>> asMaps =
        _contacts.map((c) => c.toJson()).toList();
    await _prefs!.setString(_prefsKey, jsonEncode(asMaps));
  }

  /// Obtener todos los contactos
  static List<Contact> getAllContacts() { // retorna copia para evitar mutaciones externas
    return List.from(_contacts);
  }

  /// Obtener un contacto por ID
  static Contact? getContactById(int id) { // busca un contacto por id
    try {
      return _contacts.firstWhere((contact) => contact.id == id);
    } catch (e) {
      return null; // no encontrado
    }
  }

  /// Crear un nuevo contacto
  static Contact createContact({ // crea y agrega un nuevo contacto
    required String name,
    required String phone,
    required String email,
  }) {
    final avatar = _generateAvatar(name); // iniciales del nombre
    final newContact = Contact(
      id: _nextId++,
      name: name,
      phone: phone,
      email: email,
      avatar: avatar,
    );
    
    _contacts.add(newContact); // agrega a la lista
    // persistir cambios (no se espera aqui para no bloquear la UI)
    _persist();
    return newContact; // retorna creado
  }

  /// Actualizar un contacto existente
  static bool updateContact({ // actualiza un contacto existente
    required int id,
    required String name,
    required String phone,
    required String email,
  }) {
    final index = _contacts.indexWhere((contact) => contact.id == id); // indice en la lista
    if (index != -1) {
      final avatar = _generateAvatar(name); // recalcula avatar si cambia nombre
      _contacts[index] = Contact(
        id: id,
        name: name,
        phone: phone,
        email: email,
        avatar: avatar,
      );
      _persist(); // guarda cambios
      return true;
    }
    return false;
  }

  /// Eliminar un contacto
  static bool deleteContact(int id) { // elimina un contacto por id
    final index = _contacts.indexWhere((contact) => contact.id == id);
    if (index != -1) {
      _contacts.removeAt(index); // elimina por posicion
      _persist(); // guarda cambios
      return true;
    }
    return false; // no encontrado
  }

  /// Buscar contactos por nombre
  static List<Contact> searchContacts(String query) { // filtra por nombre/telefono/email
    if (query.isEmpty) return getAllContacts(); // sin query -> todo
    
    return _contacts.where((contact) {
      return contact.name.toLowerCase().contains(query.toLowerCase()) ||
             contact.phone.contains(query) ||
             contact.email.toLowerCase().contains(query.toLowerCase());
    }).toList();
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
  static Map<String, int> getContactStats() { // estadisticas simples
    return {
      'total': _contacts.length,
      'withEmail': _contacts.where((c) => c.email.isNotEmpty).length,
      'withPhone': _contacts.where((c) => c.phone.isNotEmpty).length,
    };
  }
}
