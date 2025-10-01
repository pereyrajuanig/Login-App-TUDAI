import 'package:shared_preferences/shared_preferences.dart'; // persistencia de sesion

// Servicio muy simple de autenticacion de demo
class AuthService {
  // Credenciales validas para la demo (sin backend)
  static const String validUsername = 'usuario';
  static const String validPassword = '123456';
  static const String _loggedInKey = 'is_logged_in'; // clave de sesion

  // Valida usuario y contrasena comparando con las constantes
  // Retorna true si ambas coinciden (tras aplicar trim a los inputs)
  static bool validateCredentials(String username, String password) {
    return username.trim() == validUsername && password.trim() == validPassword;
  }

  // Retorna las credenciales de demo para mostrarlas en la UI
  static Map<String, String> getDemoCredentials() {
    return {
      'username': validUsername,
      'password': validPassword,
    };
  }

  // Guarda el estado de sesion (true para logueado, false para deslogueado)
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, value);
  }

  // Lee si hay una sesion activa
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  // Limpia la sesion (equivalente a setLoggedIn(false))
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
  }
}
