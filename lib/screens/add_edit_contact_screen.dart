import 'package:flutter/material.dart'; // UI Material
import '../models/contact.dart'; // modelo Contact
import '../services/contact_service.dart'; // servicio CRUD

class AddEditContactScreen extends StatefulWidget { // pantalla de alta/edicion
  final Contact? contact; // null para crear, Contact para editar

  const AddEditContactScreen({super.key, this.contact}); // constructor

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> { // estado
  final _formKey = GlobalKey<FormState>(); // clave para validar formulario
  final _nameController = TextEditingController(); // nombre
  final _phoneController = TextEditingController(); // telefono
  final _emailController = TextEditingController(); // email

  bool get isEditing => widget.contact != null; // true si vino contacto

  @override
  void initState() { // precargar si edita
    super.initState();
    if (isEditing) {
      _nameController.text = widget.contact!.name;
      _phoneController.text = widget.contact!.phone;
      _emailController.text = widget.contact!.email;
    }
  }

  @override
  void dispose() { // liberar controladores
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveContact() async { // valida y guarda (crear/actualizar)
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final email = _emailController.text.trim();

      if (isEditing) {
        // Actualizar contacto existente
        final success = await ContactService.updateContact(
          id: widget.contact!.id,
          name: name,
          phone: phone,
          email: email,
        );
        
        if (success) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Contacto actualizado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error al actualizar el contacto'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        // Crear nuevo contacto
        await ContactService.createContact(
          name: name,
          phone: phone,
          email: email,
        );
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contacto creado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
      
      if (context.mounted) {
        Navigator.pop(context, true); // indica a la pantalla anterior que refresque
      }
    }
  }

  @override
  Widget build(BuildContext context) { // construye la UI
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Contacto' : 'Agregar Contacto',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // clave para validacion
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        isEditing ? Icons.edit : Icons.person_add,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isEditing ? 'Editar Información' : 'Nuevo Contacto',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isEditing 
                          ? 'Modifica la información del contacto'
                          : 'Completa los datos del nuevo contacto',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[100],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Campo de nombre
                TextFormField( // nombre
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre Completo',
                    hintText: 'Ej: Juan Pérez',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es requerido';
                    }
                    if (value.trim().length < 2) {
                      return 'El nombre debe tener al menos 2 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de teléfono
                TextFormField( // telefono
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    hintText: 'Ej: +54 9 11 1234-5678',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El teléfono es requerido';
                    }
                    if (value.trim().length < 8) {
                      return 'El teléfono debe tener al menos 8 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo de email
                TextFormField( // email
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Ej: juan.perez@email.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El email es requerido';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Ingresa un email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Botón de guardar
                ElevatedButton( // guardar
                  onPressed: _saveContact,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    isEditing ? 'Actualizar Contacto' : 'Crear Contacto',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Botón de cancelar
                OutlinedButton( // cancelar
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey[400]!),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
