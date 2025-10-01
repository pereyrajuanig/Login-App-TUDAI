import '../models/contact.dart';

class SampleContacts {
  static List<Contact> getContacts() {
    return [
      Contact(
        id: 1,
        name: 'Juan Pérez',
        phone: '+54 9 11 1234-5678',
        email: 'juan.perez@email.com',
        avatar: 'JP',
      ),
      Contact(
        id: 2,
        name: 'María García',
        phone: '+54 9 11 2345-6789',
        email: 'maria.garcia@email.com',
        avatar: 'MG',
      ),
      Contact(
        id: 3,
        name: 'Carlos López',
        phone: '+54 9 11 3456-7890',
        email: 'carlos.lopez@email.com',
        avatar: 'CL',
      ),
      Contact(
        id: 4,
        name: 'Ana Rodríguez',
        phone: '+54 9 11 4567-8901',
        email: 'ana.rodriguez@email.com',
        avatar: 'AR',
      ),
      Contact(
        id: 5,
        name: 'Luis Martínez',
        phone: '+54 9 11 5678-9012',
        email: 'luis.martinez@email.com',
        avatar: 'LM',
      ),
      Contact(
        id: 6,
        name: 'Sofía Torres',
        phone: '+54 9 11 6789-0123',
        email: 'sofia.torres@email.com',
        avatar: 'ST',
      ),
      Contact(
        id: 7,
        name: 'Diego Fernández',
        phone: '+54 9 11 7890-1234',
        email: 'diego.fernandez@email.com',
        avatar: 'DF',
      ),
      Contact(
        id: 8,
        name: 'Valentina Ruiz',
        phone: '+54 9 11 8901-2345',
        email: 'valentina.ruiz@email.com',
        avatar: 'VR',
      ),
    ];
  }
}
