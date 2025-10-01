// Modelo de datos que representa un contacto en la app
class Contact {
  // Identificador unico del contacto
  final int id;
  // Nombre completo del contacto
  final String name;
  // Numero de telefono del contacto
  final String phone;
  // Correo electronico del contacto
  final String email;
  // Iniciales o etiqueta para el avatar (por ejemplo "JP")
  final String avatar;

  // Constructor inmutable con parametros requeridos
  Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.avatar,
  });

  // Crea un Contact a partir de un mapa (por ejemplo, JSON deserializado)
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      // Lee el id del mapa
      id: json['id'],
      // Lee el nombre del mapa
      name: json['name'],
      // Lee el telefono del mapa
      phone: json['phone'],
      // Lee el email del mapa
      email: json['email'],
      // Lee el avatar (iniciales) del mapa
      avatar: json['avatar'],
    );
  }

  // Convierte este Contact a un mapa (util para guardar o enviar por red)
  Map<String, dynamic> toJson() {
    return {
      // Clave "id" con el valor del identificador
      'id': id,
      // Clave "name" con el valor del nombre
      'name': name,
      // Clave "phone" con el valor del telefono
      'phone': phone,
      // Clave "email" con el valor del correo
      'email': email,
      // Clave "avatar" con el valor de las iniciales
      'avatar': avatar,
    };
  }
}
