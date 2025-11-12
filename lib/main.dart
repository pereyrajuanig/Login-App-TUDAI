import 'package:flutter/material.dart'; // SDK de widgets Material
import 'screens/login_screen.dart'; // pantalla inicial de login
import 'screens/contacts_screen.dart'; // pantalla de contactos
import 'services/auth_service.dart'; // sesion
import 'services/contact_service.dart'; // inicializacion de datos persistidos

void main() { // punto de entrada de la app
  WidgetsFlutterBinding.ensureInitialized(); // asegura binding antes de async
  runApp(const MyApp()); // arranca la app con el widget raiz
}

class MyApp extends StatelessWidget { // widget raiz sin estado
  const MyApp({super.key}); // constructor con key opcional

  @override
  Widget build(BuildContext context) { // construye el arbol de widgets
    return MaterialApp( // configura la app Material
      title: 'Login App', // titulo visible en algunos entornos
      theme: ThemeData( // tema global
        primarySwatch: Colors.blue, // paleta primaria
        visualDensity: VisualDensity.adaptivePlatformDensity, // densidad acorde a plataforma
      ),
      home: const _Bootstrap(), // primera pantalla: bootstrap de datos
      debugShowCheckedModeBanner: false, // oculta cinta de debug
    );
  }
}

class _Bootstrap extends StatefulWidget {
  const _Bootstrap();

  @override
  State<_Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<_Bootstrap> {
  Future<bool> _initFuture = Future.value(false);

  @override
  void initState() {
    super.initState();
    _initFuture = _init(); // inicializa persistencia y sesion
  }

  Future<bool> _init() async {
    await ContactService.init();
    return await AuthService.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initFuture,
      builder: (context, snapshot) {
        // Muestra loading mientras se inicializa
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        // Maneja errores
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _initFuture = _init();
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }
        
        // Obtiene el estado de login (por defecto false si no hay datos)
        final loggedIn = snapshot.data ?? false;
        
        // Debug: puedes comentar esto después
        debugPrint('Estado de login: $loggedIn');
        
        // Muestra LoginScreen si no está logueado, ContactsScreen si lo está
        return loggedIn ? const ContactsScreen() : const LoginScreen();
      },
    );
  }
}
