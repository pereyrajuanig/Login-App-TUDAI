// Agrupa constantes reutilizables de la aplicacion
class AppConstants {
  // Informacion de la aplicacion
  static const String appName = 'Login App';
  static const String appVersion = '1.0.0';
  
  // Rutas de navegacion (aun no usadas como rutas con nombre)
  static const String loginRoute = '/login';
  static const String contactsRoute = '/contacts';
  
  // Textos de la interfaz (UI)
  static const String loginTitle = 'Iniciar Sesion';
  static const String loginSubtitle = 'Ingresa tus credenciales para continuar';
  static const String contactsTitle = 'Lista de Contactos';
  
  // Mensajes de error para formularios y login
  static const String invalidCredentials = 'Usuario o contrasena incorrectos';
  static const String requiredField = 'Este campo es requerido';
  
  // Colores en formato ARGB (0xAARRGGBB)
  static const int primaryColor = 0xFF2196F3; // Azul
  static const int errorColor = 0xFFF44336;   // Rojo
  static const int successColor = 0xFF4CAF50; // Verde
}
