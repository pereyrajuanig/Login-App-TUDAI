# Login App - Mobile II

Una aplicación Flutter profesional que implementa un sistema de login con navegación a una pantalla de contactos, desarrollada para la materia Mobile II de TUDAI.

## 🎯 Características

- **✅ Pantalla de Login**: Interfaz visual moderna para ingresar credenciales
- **✅ Validación Robusta**: Verificación de credenciales con mensajes de error
- **✅ Navegación Fluida**: Transición suave a la pantalla de contactos
- **✅ Operaciones CRUD Completas**: Crear, Leer, Actualizar y Eliminar contactos
- **✅ Búsqueda en Tiempo Real**: Filtrado instantáneo por nombre, teléfono o email
- **✅ Validaciones Avanzadas**: Formularios con validación completa
- **✅ Confirmaciones de Seguridad**: Diálogos para acciones destructivas
- **✅ Diseño Responsive**: Se adapta a cualquier dispositivo y tamaño de pantalla
- **✅ Arquitectura Limpia**: Código organizado con patrón MVC

## 🏗️ Estructura del Proyecto

```
lib/
├── main.dart                           # Punto de entrada
├── models/                             # Modelos de datos
│   └── contact.dart                   # Modelo Contact con ID
├── services/                           # Servicios de negocio
│   ├── auth_service.dart              # Autenticación
│   └── contact_service.dart           # Operaciones CRUD
├── data/                               # Fuentes de datos
│   └── sample_contacts.dart           # Datos de ejemplo
├── utils/                              # Utilidades
│   └── constants.dart                 # Constantes de la app
├── widgets/                            # Widgets reutilizables
│   └── confirmation_dialog.dart       # Diálogo de confirmación
└── screens/                            # Pantallas
    ├── login_screen.dart              # Login
    ├── contacts_screen.dart           # Lista de contactos CRUD
    └── add_edit_contact_screen.dart   # Formulario crear/editar
```

## 🔑 Credenciales de Demo

Para probar la aplicación, utiliza estas credenciales:

- **Usuario**: `usuario`
- **Contraseña**: `123456`

## 🚀 Cómo Ejecutar

### **1. Instalar Dependencias**
```bash
flutter pub get
```

### **2. Ejecutar la Aplicación**

**En Navegador Web:**
```bash
flutter run -d chrome
# o
flutter run -d web-server --web-port 8080
```

**En Dispositivo Móvil:**
```bash
flutter run
```

**Acceso desde Móvil:**
- Asegúrate de estar en la misma red WiFi
- Abre navegador y ve a: `http://[IP_DE_TU_PC]:8080`

## 📱 Compatibilidad

- **✅ Web**: Chrome, Edge, Opera GX, Safari, Firefox
- **✅ Mobile**: iOS, Android (navegadores web)
- **✅ Desktop**: Windows, macOS, Linux (navegadores web)
- **✅ Responsive**: Se adapta a cualquier tamaño de pantalla

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo multiplataforma
- **Dart**: Lenguaje de programación
- **Material Design**: Sistema de diseño de Google
- **Patrón MVC**: Arquitectura limpia y escalable

## 📋 Funcionalidades Implementadas

### **Pantalla de Login**
- Campos de texto para usuario y contraseña
- Validación de campos requeridos
- Botón de inicio de sesión
- Mostrar/ocultar contraseña
- Mensajes de error para credenciales incorrectas
- Diseño visual atractivo con Material Design

### **Pantalla de Contactos (CRUD Completo)**
- **CREATE**: Agregar nuevos contactos con formulario validado
- **READ**: Lista completa con búsqueda en tiempo real
- **UPDATE**: Editar contactos existentes
- **DELETE**: Eliminar contactos con confirmación
- Avatar personalizado generado automáticamente
- Búsqueda por nombre, teléfono o email
- Menú de acciones para cada contacto
- Estados vacíos informativos
- 8 contactos de ejemplo iniciales

### **Formulario de Contacto**
- Validación completa de todos los campos
- Modo crear y editar en la misma pantalla
- Generación automática de avatar
- Mensajes de confirmación y error

## 🎨 Características del Diseño

- **Material Design**: Interfaz moderna y consistente
- **Responsive**: Se adapta a móviles, tablets y desktop
- **Accesible**: Colores contrastantes y tamaños apropiados
- **Intuitivo**: Navegación clara y fácil de usar

## 📚 Documentación Adicional

- [Arquitectura del Proyecto](ARCHITECTURE.md)
- [Funcionalidades CRUD](CRUD_FEATURES.md)
- [Guía de Desarrollo](https://docs.flutter.dev/)

## 👨‍💻 Autor

Desarrollado para la materia Mobile II - TUDAI

## 📄 Licencia

Proyecto académico - Uso educativo