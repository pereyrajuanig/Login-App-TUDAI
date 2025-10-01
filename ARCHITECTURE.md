# Arquitectura del Proyecto - Login App

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada de la aplicación
├── models/                      # Modelos de datos
│   └── contact.dart            # Modelo Contact con serialización JSON
├── services/                    # Servicios de negocio
│   └── auth_service.dart       # Servicio de autenticación
├── data/                        # Fuentes de datos
│   └── sample_contacts.dart    # Datos de ejemplo para contactos
├── utils/                       # Utilidades y constantes
│   └── constants.dart          # Constantes de la aplicación
└── screens/                     # Pantallas de la aplicación
    ├── login_screen.dart       # Pantalla de login
    └── contacts_screen.dart    # Pantalla de contactos
```

## 🏗️ Arquitectura Implementada

### **Patrón MVC (Model-View-Controller)**
- **Model**: `Contact` class en `models/contact.dart`
- **View**: Pantallas en `screens/`
- **Controller**: Lógica de negocio en `services/`

### **Separación de Responsabilidades**

#### **Models** (`lib/models/`)
- **Contact**: Modelo de datos con serialización JSON
- Define la estructura de datos de los contactos

#### **Services** (`lib/services/`)
- **AuthService**: Maneja toda la lógica de autenticación
- Validación de credenciales
- Credenciales de demo centralizadas

#### **Data** (`lib/data/`)
- **SampleContacts**: Fuente de datos de ejemplo
- Separación entre datos y lógica de presentación

#### **Utils** (`lib/utils/`)
- **Constants**: Todas las constantes de la aplicación
- Textos, colores, rutas centralizadas

#### **Screens** (`lib/screens/`)
- **LoginScreen**: Interfaz de inicio de sesión
- **ContactsScreen**: Lista de contactos

## 🔧 Beneficios de la Reorganización

### **Mantenibilidad**
- Código más organizado y fácil de mantener
- Cambios en constantes desde un solo lugar
- Lógica de autenticación centralizada

### **Escalabilidad**
- Fácil agregar nuevos modelos
- Servicios reutilizables
- Estructura preparada para crecimiento

### **Legibilidad**
- Separación clara de responsabilidades
- Nombres descriptivos de archivos y carpetas
- Código más limpio y profesional

## 🚀 Funcionalidades

### **Autenticación**
- Validación de credenciales
- Mensajes de error personalizados
- Credenciales de demo configurables

### **Navegación**
- Transición fluida entre pantallas
- Gestión de estado simple
- Navegación con MaterialPageRoute

### **Contactos**
- Lista de contactos con información completa
- Modal de detalles
- Datos de ejemplo extensibles

## 📱 Compatibilidad

- **Web**: Chrome, Edge, Opera GX, Safari
- **Mobile**: iOS, Android (navegadores web)
- **Desktop**: Windows, macOS, Linux (navegadores web)
- **Responsive**: Se adapta a cualquier tamaño de pantalla
