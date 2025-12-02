import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Models/chats.dart';

/// Componente reutilizable que representa un elemento de lista de chat
/// Muestra avatar, nombre, último mensaje, fecha, contador de mensajes no leídos y flecha de navegación
/// Similar al diseño de WhatsApp
class MyListTile extends StatelessWidget {
  /// Modelo de datos que contiene la información del chat (nombre, mensaje, avatar, etc.)
  final ChatsModel model;
  
  /// Callback opcional que se ejecuta al hacer tap en toda la fila
  /// Usualmente navega a la pantalla de conversación
  final VoidCallback? onTap;
  
  /// Callback opcional que se ejecuta al hacer tap específicamente en el avatar
  /// Usualmente muestra el perfil o las historias del contacto
  final VoidCallback? onImageTap;

  const MyListTile({
    super.key,
    required this.model,
    this.onTap,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    // Debug: imprime la ruta del avatar recibido
    print("Avatar recibido: ${model.avatar}");
    
    // GestureDetector permite hacer tap en toda la fila
    return GestureDetector(
      onTap: onTap ?? () {}, // Si no se proporciona callback, no hace nada
      child: Padding(
        // Padding horizontal de 16px y vertical de 14px para espaciado entre elementos
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          // Distribuye el espacio entre el contenido izquierdo y derecho
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SECCIÓN IZQUIERDA: Avatar + Nombre + Mensaje
            Row(
              children: [
                // Avatar del contacto
                GestureDetector(
                  onTap: onImageTap ?? () {}, // Tap específico en el avatar
                  child: model.story
                      ? // Si el contacto tiene historias (story = true)
                        Container(
                          width: 61,
                          height: 61,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // Borde verde de WhatsApp para indicar que hay historias
                            border: Border.all(
                              color: const Color(0xFF25D366), // Verde característico de WhatsApp
                              width: 2.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(2.5),
                          child: CircleAvatar(
                            radius: 28,
                            // Carga la imagen desde URL (NetworkImage) o desde assets (AssetImage)
                            backgroundImage: model.avatar.startsWith("http")
                                ? NetworkImage(model.avatar)
                                : AssetImage(model.avatar) as ImageProvider,
                          ),
                        )
                      : // Si no tiene historias, solo muestra el avatar sin borde
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: model.avatar.startsWith("http")
                              ? NetworkImage(model.avatar)
                              : AssetImage(model.avatar) as ImageProvider,
                        ),
                ),

                const SizedBox(width: 12), // Espacio entre avatar y textos

                // Columna con nombre y último mensaje
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda
                  children: [
                    // Nombre del contacto
                    Text(
                      model.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600, // Negrita para destacar
                      ),
                    ),
                    const SizedBox(height: 3), // Pequeño espacio entre nombre y mensaje
                    // Último mensaje recibido/enviado
                    Text(
                      model.msg,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey, // Color gris para texto secundario
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // SECCIÓN DERECHA: Hora + Contador de mensajes + Flecha
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end, // Alineación a la derecha
                  children: [
                    // Fecha/hora del último mensaje
                    Text(
                      model.date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),

                    const SizedBox(height: 8), // Espacio entre fecha y contador

                    // Contador de mensajes no leídos
                    // Solo se muestra si hay mensajes pendientes (count != "0")
                    model.count == "0"
                        ? const SizedBox.shrink() // Si no hay mensajes, no muestra nada
                        : CircleAvatar(
                            radius: 10,
                            backgroundColor: const Color(0xFFC10000), // Color rojo del tema
                            child: Text(
                              model.count, // Número de mensajes no leídos
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                  ],
                ),

                const SizedBox(width: 10), // Espacio entre contador y flecha

                // Flecha indicadora de navegación (estilo iOS)
                Icon(
                  CupertinoIcons.chevron_right,
                  color: Colors.grey.shade400, // Gris claro para indicador discreto
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

