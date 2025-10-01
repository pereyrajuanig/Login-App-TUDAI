import 'package:flutter/material.dart'; // UI Material

class ConfirmationDialog { // dialogo reutilizable para confirmar acciones
  static Future<bool?> show({ // retorna true/false segun eleccion, o null si se cancela
    required BuildContext context, // contexto para mostrar el dialogo
    required String title, // titulo del dialogo
    required String message, // mensaje de detalle
    String confirmText = 'Confirmar', // texto del boton confirmar
    String cancelText = 'Cancelar', // texto del boton cancelar
    Color confirmColor = Colors.red, // color del boton confirmar
  }) {
    return showDialog<bool>( // muestra un AlertDialog y espera el resultado
      context: context,
      barrierDismissible: false, // evita cerrar tocando fuera del dialogo
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // bordes redondeados
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded, // icono de advertencia
                color: confirmColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title, // titulo del dialogo
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message, // mensaje descriptivo
            style: const TextStyle(fontSize: 16),
          ),
          actions: [ // botones de accion
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // devuelve false
              child: Text(
                cancelText,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true), // devuelve true
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                confirmText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
