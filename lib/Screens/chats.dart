import 'package:chat_app/Models/chats.dart';
import 'package:chat_app/globla.dart';
import 'package:chat_app/Services/supabase_storage_service.dart';
import 'package:chat_app/utils/image_compressor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:typed_data';
import 'package:chat_app/Components/my_list_tile.dart';
import 'package:chat_app/Screens/chat_detail_screen.dart';

/// Pantalla principal que muestra la lista de chats/conversaciones
/// Permite seleccionar una foto y enviarla a cualquier chat
/// Muestra el último mensaje de cada chat en tiempo real desde Firestore
class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final ImagePicker _imagePicker = ImagePicker();  // Selector de imágenes
  bool _isUploadingImage = false;                 // Indica si se está subiendo una imagen

  /// Genera un ID único para el chat basado en los participantes
  /// Ordena los IDs para que siempre sea el mismo independientemente del orden
  String _getChatId(String contactName) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid ?? 'current_user';
    final participants = [currentUserId, contactName]..sort();  // Ordenar para consistencia
    return participants.join('_');  // Ejemplo: "user1_user2"
  }

  /// Muestra un menú para seleccionar foto desde cámara o galería
  /// Luego permite elegir a qué chat enviar la foto
  Future<void> _pickImageAndSend() async {
    try {
      // Mostrar opciones: Cámara o Galería
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Seleccionar foto'),
          message: const Text('Elige de dónde quieres tomar la foto'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
              child: const Text('Cámara'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
              child: const Text('Galería'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
        ),
      );
    } catch (e) {
      print('Error al mostrar opciones: $e');
    }
  }

  /// Selecciona una imagen desde la cámara o galería
  /// Comprime la imagen a máximo 500KB y la sube a Supabase
  /// Luego muestra un selector para elegir a qué chat enviarla
  Future<void> _pickImage(ImageSource source) async {
    try {
      // Seleccionar imagen con límites de tamaño
      final XFile? image = await _imagePicker.pickImage(
        source: source,        // Cámara o galería
        maxWidth: 2048,        // Ancho máximo
        maxHeight: 2048,       // Alto máximo
        imageQuality: 100,    // Calidad inicial alta, luego comprimiremos
      );

      if (image != null) {
        setState(() {
          _isUploadingImage = true;  // Mostrar indicador de carga
        });

        File? file;
        Uint8List? compressedBytes;

        // Comprimir la imagen antes de subirla (máximo 500KB)
        if (kIsWeb) {
          // Para web, usar XFile directamente
          compressedBytes = await ImageCompressor.compressImage(
            xFile: image,
            maxSizeKB: 500,
          );
        } else {
          // Para móvil, convertir a File primero
          file = File(image.path);
          compressedBytes = await ImageCompressor.compressImage(
            file: file,
            maxSizeKB: 500,
          );
        }

        // Subir foto comprimida a Supabase Storage
        final imageUrl = await SupabaseStorageService.uploadPhoto(
          bytes: compressedBytes,
        );

        setState(() {
          _isUploadingImage = false;
        });

        // Mostrar lista de chats para seleccionar a quién enviar
        _showChatSelector(imageUrl);
      }
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
      });
      
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text('Error al seleccionar imagen: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _showChatSelector(String imageUrl) async {
    // Obtener lista de chats
    final chats = await WhatsApp.Chats();
    
    if (!mounted) return;

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Enviar foto a'),
        message: const Text('Selecciona el chat al que quieres enviar la foto'),
        actions: chats.map((chat) {
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _sendImageToChat(chat, imageUrl);
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: chat.avatar.startsWith("http")
                      ? NetworkImage(chat.avatar)
                      : AssetImage(chat.avatar) as ImageProvider,
                ),
                const SizedBox(width: 12),
                Text(chat.name),
              ],
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
      ),
    );
  }

  /// Envía una imagen a un chat específico
  /// Guarda el mensaje en Firestore y actualiza el último mensaje del chat
  Future<void> _sendImageToChat(ChatsModel chat, String imageUrl) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final chatId = _getChatId(chat.name);
      final currentUserId = currentUser.uid;
      
      // Crear un nuevo documento de mensaje en la subcolección 'messages'
      final messageRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc();

      // Guardar el mensaje con la URL de la imagen
      await messageRef.set({
        'msg': '📷 Foto',
        'sender': true,                    // true = enviado por el usuario actual
        'senderId': currentUserId,
        'type': 'image',                    // Tipo de mensaje: imagen
        'opened': false,                    // Aún no leído
        'image': imageUrl,                  // URL de la imagen en Supabase
        'timestamp': FieldValue.serverTimestamp(),  // Timestamp del servidor
      });

      // Actualizar el último mensaje en la colección de chats (para mostrar en la lista)
      await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
        'lastMessage': '📷 Foto',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'participants': [currentUserId, chat.name],  // Participantes del chat
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));  // merge: true para no sobrescribir otros campos

      // Navegar al chat
      if (mounted) {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => ChatDetailScreen(chat: chat),
          ),
        );
      }
    } catch (e) {
      print('Error al enviar imagen al chat: $e');
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text('No se pudo enviar la foto: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Title'),
        message: const Text('Message'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Action One',
              style: TextStyle(color: Colors.red),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Action Two',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(   // ⭐ NECESARIO PARA WEB
      child: FutureBuilder<List<ChatsModel>>(
        future: WhatsApp.Chats(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final chats = snapshot.data!;

          return CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text("Chats"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: _isUploadingImage
                            ? const CupertinoActivityIndicator()
                            : const Icon(
                                CupertinoIcons.camera_fill,
                                color: Color(0xFF25D366),
                              ),
                        onPressed: _isUploadingImage ? null : _pickImageAndSend,
                        iconSize: 24,
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(CupertinoIcons.pencil),
                        onPressed: () {},
                        iconSize: 24,
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(CupertinoIcons.add),
                        onPressed: () => _showActionSheet(context),
                        iconSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: CupertinoSearchTextField(
                    onChanged: (value) {},
                    onSubmitted: (value) {},
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final e = chats[index];
                    final chatId = _getChatId(e.name);
                    
                    // StreamBuilder para obtener el último mensaje desde Firestore en tiempo real
                    // Se actualiza automáticamente cuando hay cambios en Firestore
                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatId)
                          .snapshots(),  // Escuchar cambios en tiempo real
                      builder: (context, chatSnapshot) {
                        // Valores por defecto (mensajes de prueba)
                        String lastMessage = e.msg;
                        String lastMessageTime = e.date;
                        
                        // Si hay un último mensaje en Firestore, usarlo (sobrescribe los valores por defecto)
                        if (chatSnapshot.hasData && chatSnapshot.data!.exists) {
                          final chatData = chatSnapshot.data!.data() as Map<String, dynamic>?;
                          if (chatData != null && chatData['lastMessage'] != null) {
                            lastMessage = chatData['lastMessage'] as String;
                            
                            // Formatear la fecha del último mensaje según cuándo fue enviado
                            if (chatData['lastMessageTime'] != null) {
                              final timestamp = chatData['lastMessageTime'] as Timestamp?;
                              if (timestamp != null) {
                                final date = timestamp.toDate();
                                final now = DateTime.now();
                                final difference = now.difference(date);
                                
                                if (difference.inDays == 0) {
                                  // Hoy: mostrar hora (ej: "14:30")
                                  lastMessageTime = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                                } else if (difference.inDays == 1) {
                                  lastMessageTime = 'Ayer';
                                } else if (difference.inDays < 7) {
                                  // Esta semana: mostrar día de la semana (ej: "Lun", "Mar")
                                  final days = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
                                  lastMessageTime = days[date.weekday % 7];
                                } else {
                                  // Más de una semana: mostrar fecha (ej: "15/12")
                                  lastMessageTime = '${date.day}/${date.month}';
                                }
                              }
                            }
                          }
                        }
                        
                        // Crear un modelo actualizado con el último mensaje
                        final updatedChat = ChatsModel(
                          name: e.name,
                          avatar: e.avatar,
                          msg: lastMessage,
                          date: lastMessageTime,
                          count: e.count,
                          story: e.story,
                          opened: e.opened,
                          type: e.type,
                        );
                        
                        return MyListTile(
                          model: updatedChat,
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => ChatDetailScreen(chat: updatedChat),
                              ),
                            );
                          },
                          onImageTap: () {},
                        );
                      },
                    );
                  },
                  childCount: chats.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}



