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
  // Controladores y estado
  final _formKey = GlobalKey<FormState>(); //llave global para el formulario
  final _usernameController = TextEditingController(); //controlador de texto para el nombre de usuario
  final _passwordController = TextEditingController(); //controlador de texto para la contraseña
  bool _isPasswordVisible = false; //variable para controlar la visibilidad de la contraseña
  
  // Configuración de imágenes de fondo
  // lista de imagenes de fondo (agrega las que quieras en assets/images/)
  static const List<String> _bgImages = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg'
  ];
  int _bgIndex = 0; // indice actual
  Timer? _bgTimer; // temporizador para rotacion

  // Constantes de estilo
  static const Duration _bgTransitionDuration = Duration(milliseconds: 1000); // duracion de transicion
  static const Duration _bgRotationInterval = Duration(seconds: 8); // intervalo de rotacion
  static const double _overlayOpacity = 0.5; // opacidad de la capa oscura
  static const double _formMaxWidth = 420.0; // ancho maximo del formulario
  static const double _formBorderRadius = 16.0; // radio de borde del formulario
  static const double _inputBorderRadius = 12.0; // radio de borde de los inputs

  @override
  void initState() { // inicia rotacion del fondo
    super.initState();
    _startBackgroundRotation(); // inicia la rotacion de imagenes
  }

  void _startBackgroundRotation() { // inicia el timer de rotacion
    if (_bgImages.length > 1) {
      _bgTimer = Timer.periodic(_bgRotationInterval, (_) {
        if (mounted) { // verifica que el widget aun este montado
          setState(() {
            _bgIndex = (_bgIndex + 1) % _bgImages.length;
          });
        }
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

  Future<void> _validateLogin() async { //validar las credenciales
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim(); //obtener el nombre de usuario y eliminar espacios en blanco
    final password = _passwordController.text.trim(); //obtener la contraseña y eliminar espacios en blanco

    if (AuthService.validateCredentials(username, password)) { //validar las credenciales
      await _handleSuccessfulLogin(); // manejar login exitoso
    } else {
      _showErrorSnackBar(); // mostrar error de credenciales
    }
  }

  Future<void> _handleSuccessfulLogin() async { // maneja el login exitoso
    await AuthService.setLoggedIn(true); // guardar flag de sesion para recordar login
    
    if (!context.mounted) return;
    
    // Credenciales correctas, navegar a la pantalla de contactos reemplazando LoginScreen
    Navigator.pushReplacement( //reemplaza LoginScreen con ContactsScreen
      context,
      MaterialPageRoute(
        builder: (context) => const ContactsScreen(),
      ),
    );
    
    // Limpiar los campos después del login exitoso
    _usernameController.clear(); //limpiar los campos de texto
    _passwordController.clear(); //limpiar los campos de texto
  }

  void _showErrorSnackBar() { // muestra mensaje de error
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar( //mostrar mensaje de error
        content: Text(AppConstants.invalidCredentials), //mostrar mensaje de error
        backgroundColor: Colors.red,
      ),
    );
  }

  @override //construir la pantalla de login
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackgroundImage(), // Imagen de fondo a pantalla completa con resolución consistente
          _buildOverlay(), // Capa de oscurecimiento más intenso para mejor contraste
          _buildLoginForm(), // Contenido flotante
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() { // construye la imagen de fondo animada
    return AnimatedSwitcher(
      duration: _bgTransitionDuration, // transicion mas suave
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Container(
        key: ValueKey<String>(_bgImages[_bgIndex]),
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          _bgImages[_bgIndex],
          fit: BoxFit.cover, // cubre toda la pantalla manteniendo proporción
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
    );
  }

  Widget _buildOverlay() { // construye la capa oscura de superposicion
    return Container(color: Colors.black.withValues(alpha: _overlayOpacity));
  }

  Widget _buildLoginForm() { // construye el formulario de login
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _formMaxWidth),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_formBorderRadius),
              child: Container(
                decoration: _buildFormDecoration(), // decoracion del contenedor del formulario
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTitle(), // titulo del formulario
                      const SizedBox(height: 8),
                      _buildSubtitle(), // subtitulo del formulario
                      const SizedBox(height: 32),
                      _buildUsernameField(), // Campo de usuario
                      const SizedBox(height: 16),
                      _buildPasswordField(), // Campo de contraseña
                      const SizedBox(height: 24),
                      _buildLoginButton(), // boton de login
                      const SizedBox(height: 16),
                      _buildDemoCredentials(), // Credenciales de demo
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildFormDecoration() { // decoracion del contenedor del formulario
    return BoxDecoration(
      color: Colors.black.withValues(alpha: _overlayOpacity), // más oscuro para mejor contraste
      borderRadius: BorderRadius.circular(_formBorderRadius),
      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 20,
          spreadRadius: 5,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  Widget _buildTitle() { // construye el titulo
    return const Text(
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
    );
  }

  Widget _buildSubtitle() { // construye el subtitulo
    return Text(
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
    );
  }

  Widget _buildUsernameField() { // construye el campo de usuario
    return TextFormField(
      controller: _usernameController,
      decoration: _buildInputDecoration(
        label: 'Usuario',
        hint: 'Ingresa tu nombre de usuario',
        icon: Icons.person_outline,
      ),
      validator: _validateRequiredField, // validador de campo requerido
    );
  }

  Widget _buildPasswordField() { // construye el campo de contraseña
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: _buildInputDecoration(
        label: 'Contraseña',
        hint: 'Ingresa tu contraseña',
        icon: Icons.lock_outline,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: _validateRequiredField, // validador de campo requerido
    );
  }

  InputDecoration _buildInputDecoration({ // construye la decoracion de los campos de texto
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_inputBorderRadius),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  String? _validateRequiredField(String? value) { // valida que el campo no este vacio
    if (value == null || value.isEmpty) {
      return AppConstants.requiredField;
    }
    return null;
  }

  Widget _buildLoginButton() { // construye el boton de login
    return ElevatedButton(
      onPressed: _validateLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_inputBorderRadius),
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
    );
  }

  Widget _buildDemoCredentials() { // construye el texto con credenciales de demo
    final credentials = AuthService.getDemoCredentials();
    return Text(
      'Credenciales de Demo:\nUsuario: ${credentials['username']}\nContraseña: ${credentials['password']}',
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.95),
        fontSize: 14,
        shadows: const [
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 2,
            color: Colors.black54,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
