import 'package:flutter/material.dart'; //importacion de la libreria material.dart
import 'dart:async'; // Timer para rotar fondos
import '../services/auth_service.dart'; //importacion del servicio de autenticacion
import '../utils/constants.dart'; //importacion de las constantes
import 'contacts_screen.dart'; //importacion de la pantalla de contactos

class LoginScreen extends StatefulWidget { //pantalla de login
  const LoginScreen({super.key}); //constructor de la pantalla de login

  @override //crear el estado de la pantalla de login
  State<LoginScreen> createState() => _LoginScreenState(); //crear el estado de la pantalla de login
}

class _LoginScreenState extends State<LoginScreen> { //estado de la pantalla de login
  final _formKey = GlobalKey<FormState>(); //llave global para el formulario
  final _usernameController = TextEditingController(); //controlador de texto para el nombre de usuario
  final _passwordController = TextEditingController(); //controlador de texto para la contraseña
  bool _isPasswordVisible = false; //variable para controlar la visibilidad de la contraseña
  // lista de imagenes de fondo (agrega las que quieras en assets/images/)
  final List<String> _bgImages = const [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg'
  ];
  int _bgIndex = 0; // indice actual
  Timer? _bgTimer; // temporizador para rotacion


  @override
  void initState() { // inicia rotacion del fondo
    super.initState();
    if (_bgImages.length > 1) {
      _bgTimer = Timer.periodic(const Duration(seconds: 6), (_) {
        setState(() {
          _bgIndex = (_bgIndex + 1) % _bgImages.length;
        });
      });
    }
  }

  @override //liberar los controladores de texto
  void dispose() { 
    //liberar los controladores de texto
    _usernameController.dispose();
    _passwordController.dispose();
    _bgTimer?.cancel(); // detiene el timer
    super.dispose(); //liberar el estado de la pantalla de login
  }

  void _validateLogin() { //validar las credenciales
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim(); //obtener el nombre de usuario y eliminar espacios en blanco
      String password = _passwordController.text.trim(); //obtener la contraseña y eliminar espacios en blanco

      if (AuthService.validateCredentials(username, password)) { //validar las credenciales
        // guardar flag de sesion para recordar login
        AuthService.setLoggedIn(true);
        // Credenciales correctas, navegar a la pantalla de contactos
        Navigator.push( //navegar a la pantalla de contactos
          context,
          MaterialPageRoute(
            builder: (context) => const ContactsScreen(), //navegar a la pantalla de contactos
          ),
        );
        
        // Limpiar los campos después del login exitoso
        _usernameController.clear(); //limpiar los campos de texto
        _passwordController.clear(); //limpiar los campos de texto
      } else {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar( //mostrar mensaje de error
            content: Text(AppConstants.invalidCredentials), //mostrar mensaje de error
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override //construir la pantalla de login
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo a pantalla completa con resolución consistente
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: Container(
              key: ValueKey<String>(_bgImages[_bgIndex]),
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                _bgImages[_bgIndex],
                fit: BoxFit.cover, // cubre toda la pantalla manteniendo proporción
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center, // centra la imagen
                errorBuilder: (context, error, stackTrace) {
                  // fallback si la imagen no existe
                  return Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Capa de oscurecimiento más intenso para mejor contraste
          Container(color: Colors.black.withValues(alpha: 0.5)),
          // Contenido flotante
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5), // más oscuro para mejor contraste
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              AppConstants.loginTitle,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppConstants.loginSubtitle,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.95),
                                shadows: const [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),

                            // Campo de usuario
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'Usuario',
                                hintText: 'Ingresa tu nombre de usuario',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppConstants.requiredField;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Campo de contraseña
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                hintText: 'Ingresa tu contraseña',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppConstants.requiredField;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            ElevatedButton(
                              onPressed: _validateLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[600],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                              ),
                              child: const Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Credenciales de demo
                            Text(
                              'Credenciales de Demo:\nUsuario: ${AuthService.getDemoCredentials()['username']}\nContraseña: ${AuthService.getDemoCredentials()['password']}',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.95),
                                shadows: const [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


