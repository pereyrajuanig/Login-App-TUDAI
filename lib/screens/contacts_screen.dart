import 'package:flutter/material.dart'; // UI Material
import '../models/contact.dart'; // modelo Contact
import '../utils/constants.dart'; // textos/constantes
import '../services/contact_service.dart'; // servicio CRUD
import '../services/auth_service.dart'; // manejo de sesion
import '../widgets/confirmation_dialog.dart'; // dialogo de confirmacion
import 'add_edit_contact_screen.dart'; // pantalla de alta/edicion

class ContactsScreen extends StatefulWidget { // pantalla principal de contactos
  const ContactsScreen({super.key}); // constructor

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> { // estado y logica de la pantalla
  List<Contact> contacts = ContactService.getAllContacts(); // lista en memoria
  final TextEditingController _searchController = TextEditingController(); // controlador busqueda
  String _searchQuery = ''; // texto de busqueda actual

  @override
  void initState() { // configurar listeners
    super.initState();
    _searchController.addListener(_onSearchChanged); // escucha cambios en busqueda
  }

  @override
  void dispose() { // liberar controlador
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() { // actualizar query al tipear
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  List<Contact> get filteredContacts { // aplica filtro de busqueda
    if (_searchQuery.isEmpty) {
      return contacts;
    }
    return ContactService.searchContacts(_searchQuery);
  }

  void _refreshContacts() { // recarga desde servicio
    setState(() {
      contacts = ContactService.getAllContacts();
    });
  }

  Future<void> _addContact() async { // navegar a crear contacto
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditContactScreen(),
      ),
    );
    
    if (result == true) {
      _refreshContacts();
    }
  }

  Future<void> _editContact(Contact contact) async { // navegar a editar
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditContactScreen(contact: contact),
      ),
    );
    
    if (result == true) {
      _refreshContacts();
    }
  }

  Future<void> _deleteContact(Contact contact) async { // eliminar con confirmacion
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: 'Eliminar Contacto',
      message: '¿Estás seguro de que quieres eliminar a ${contact.name}? Esta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
    );

    if (confirmed == true) {
      final success = ContactService.deleteContact(contact.id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${contact.name} eliminado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        _refreshContacts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al eliminar el contacto'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) { // construye UI

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Contactos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _addContact, // ir a crear
            tooltip: 'Agregar Contacto',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // limpiar flag de sesion y volver al login
              AuthService.logout();
              Navigator.pop(context);
            },
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header con información
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.contacts,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                const Text(
                  AppConstants.contactsTitle,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${filteredContacts.length} contactos disponibles',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue[100],
                  ),
                ),
              ],
            ),
          ),

          // Barra de búsqueda
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar contactos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Lista de contactos
          Expanded(
            child: filteredContacts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isEmpty ? Icons.person_add : Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty 
                            ? 'No hay contactos'
                            : 'No se encontraron contactos',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isEmpty 
                            ? 'Toca el botón + para agregar uno'
                            : 'Intenta con otros términos de búsqueda',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = filteredContacts[index];
                return Card( // item visual de cada contacto
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blue[600],
                      child: Text(
                        contact.avatar,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    title: Text(
                      contact.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              contact.phone,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                contact.email,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        switch (value) {
                          case 'view':
                            _showContactDetails(context, contact);
                            break;
                          case 'edit':
                            _editContact(contact);
                            break;
                          case 'delete':
                            _deleteContact(contact);
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility, size: 20),
                              SizedBox(width: 8),
                              Text('Ver detalles'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text('Editar'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Eliminar', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      _showContactDetails(context, contact);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDetails(BuildContext context, Contact contact) { // dialogo con detalle del contacto
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[600],
                child: Text(
                  contact.avatar,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  contact.name,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(Icons.phone, 'Teléfono', contact.phone),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.email, 'Email', contact.email),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cerrar',
                style: TextStyle(color: Colors.blue[600]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) { // util para filas de detalle
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



