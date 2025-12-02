import 'package:chat_app/Models/chats.dart';
import 'package:chat_app/Models/message.dart';
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

/// Pantalla de detalle de chat donde se muestran los mensajes
/// Permite enviar mensajes de texto e imágenes en tiempo real
/// Los mensajes se sincronizan con Firestore usando StreamBuilder
class ChatDetailScreen extends StatefulWidget {
  final ChatsModel chat;  // Información del contacto con quien se chatea

  const ChatDetailScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();  // Controlador para el campo de mensaje
  final ScrollController _scrollController = ScrollController();            // Controlador para hacer scroll automático
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;          // Instancia de Firestore
  final User? _currentUser = FirebaseAuth.instance.currentUser;             // Usuario actual autenticado
  final ImagePicker _imagePicker = ImagePicker();                           // Selector de imágenes
  bool _isUploadingImage = false;                                           // Indica si se está subiendo una imagen

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Genera un ID único para el chat basado en los participantes
  /// Ordena los IDs para que siempre sea el mismo independientemente del orden
  String _getChatId() {
    final currentUserId = _currentUser?.uid ?? 'current_user';
    final contactName = widget.chat.name;
    // Ordenar para que siempre sea el mismo ID independientemente del orden
    final participants = [currentUserId, contactName]..sort();
    return participants.join('_');  // Ejemplo: "user1_user2"
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 100, // Calidad inicial alta, luego comprimiremos
      );

      if (image != null) {
        setState(() {
          _isUploadingImage = true;
        });

        File? file;
        Uint8List? compressedBytes;

        // Comprimir la imagen antes de subirla
        if (kIsWeb) {
          compressedBytes = await ImageCompressor.compressImage(
            xFile: image,
            maxSizeKB: 500,
          );
        } else {
          file = File(image.path);
          compressedBytes = await ImageCompressor.compressImage(
            file: file,
            maxSizeKB: 500,
          );
        }

        // Subir foto comprimida a Supabase
        final imageUrl = await SupabaseStorageService.uploadPhoto(
          bytes: compressedBytes,
        );

        // Enviar mensaje con la foto
        await _sendMessageWithImage(imageUrl);

        setState(() {
          _isUploadingImage = false;
        });
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

  Future<void> _sendMessageWithImage(String imageUrl) async {
    final currentUser = _currentUser;
    if (currentUser == null) return;

    try {
      final chatId = _getChatId();
      final currentUserId = currentUser.uid;
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc();

      await messageRef.set({
        'msg': '📷 Foto',
        'sender': true,
        'senderId': currentUserId,
        'type': 'image',
        'opened': false,
        'image': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Actualizar el último mensaje en la colección de chats
      await _firestore.collection('chats').doc(chatId).set({
        'lastMessage': '📷 Foto',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'participants': [currentUserId, widget.chat.name],
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Scroll al final después de un pequeño delay
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      print('Error al enviar mensaje con imagen: $e');
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

  /// Envía un mensaje de texto al chat
  /// Guarda el mensaje en Firestore y actualiza el último mensaje del chat
  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    final currentUser = _currentUser;
    if (messageText.isEmpty || currentUser == null) return;

    try {
      final chatId = _getChatId();
      final currentUserId = currentUser.uid;
      
      // Crear un nuevo documento de mensaje en la subcolección 'messages'
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc();

      // Guardar el mensaje en Firestore
      await messageRef.set({
        'msg': messageText,
        'sender': true,                    // true = usuario actual, false = contacto
        'senderId': currentUserId,
        'type': 'text',                     // Tipo de mensaje: texto
        'opened': false,                     // Aún no leído
        'image': '',                        // Sin imagen
        'timestamp': FieldValue.serverTimestamp(),  // Timestamp del servidor
      });

      // Actualizar el último mensaje en la colección de chats (para mostrar en la lista)
      await _firestore.collection('chats').doc(chatId).set({
        'lastMessage': messageText,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'participants': [currentUserId, widget.chat.name],
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));  // merge: true para no sobrescribir otros campos

      _messageController.clear();  // Limpiar el campo de texto
      
      // Scroll al final después de un pequeño delay
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      print('Error al enviar mensaje: $e');
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text('No se pudo enviar el mensaje: $e'),
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: CupertinoSearchTextField(
                placeholder: 'Q Search',
                placeholderStyle: TextStyle(color: Colors.grey.shade600),
                style: const TextStyle(color: CupertinoColors.black),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8),
                ),
                onChanged: (value) {},
              ),
            ),

            // Lista de mensajes con StreamBuilder para tiempo real
            // Se actualiza automáticamente cuando hay nuevos mensajes en Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .doc(_getChatId())
                    .collection('messages')
                    .orderBy('timestamp', descending: false)  // Ordenar por timestamp (más antiguos primero)
                    .snapshots(),  // Escuchar cambios en tiempo real
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error al cargar mensajes: ${snapshot.error}',
                        style: const TextStyle(color: CupertinoColors.black),
                      ),
                    );
                  }

                  // Obtener mensajes de Firestore
                  final firestoreMessages = snapshot.data?.docs ?? [];
                  
                  // Combinar mensajes de prueba con mensajes de Firestore
                  return FutureBuilder<List<MessageModel>>(
                    future: WhatsApp.getChatMessages(widget.chat.name),
                    builder: (context, futureSnapshot) {
                      List<MessageModel> allMessages = [];
                      
                      // Agregar mensajes de prueba primero (si existen)
                      if (futureSnapshot.hasData) {
                        allMessages.addAll(futureSnapshot.data!);
                      }
                      
                      // Agregar mensajes de Firestore
                      for (var doc in firestoreMessages) {
                        final messageData = doc.data() as Map<String, dynamic>;
                        final message = MessageModel(
                          image: messageData['image'] ?? '',
                          msg: messageData['msg'] ?? '',
                          sender: messageData['sender'] ?? false,
                          type: messageData['type'] ?? 'text',
                          opened: messageData['opened'] ?? false,
                        );
                        allMessages.add(message);
                      }
                      
                      // Scroll al final cuando se cargan los mensajes
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      });

                      if (allMessages.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay mensajes',
                            style: TextStyle(color: CupertinoColors.black),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        itemCount: allMessages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageBubble(allMessages[index]);
                        },
                      );
                    },
                  );
                },
              ),
            ),

            // Barra de entrada
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Botón de retroceso
          Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Icon(
                CupertinoIcons.chevron_left,
                color: AppColors.primary,
                size: 28,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          const SizedBox(width: 10),

          // Nombre del contacto
          Expanded(
            child: Text(
              widget.chat.name,
              style: const TextStyle(
                color: CupertinoColors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Botón de video llamada
          Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  CupertinoIcons.videocam_fill,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: () {},
            ),
          ),

          const SizedBox(width: 8),

          // Botón de llamada de voz
          Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF0084FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  CupertinoIcons.phone_fill,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message) {
    final isSender = message.sender;
    final hasImage = message.image.isNotEmpty && message.type == 'image';

    return Builder(
      builder: (context) => Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: hasImage ? Colors.transparent : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: hasImage
              ? Column(
                  crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        message.image,
                        width: MediaQuery.of(context).size.width * 0.75,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 200,
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 200,
                            color: Colors.grey.shade300,
                            child: const Icon(
                              CupertinoIcons.photo,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    if (message.msg.isNotEmpty && message.msg != '📷 Foto')
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSender
                              ? AppColors.primary
                              : CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          message.msg,
                          style: TextStyle(
                            color: isSender ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSender
                        ? AppColors.primary
                        : CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message.msg,
                    style: TextStyle(
                      color: isSender ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Botón de más (galería)
          Material(
            color: Colors.transparent,
            child: IconButton(
              icon: const Icon(
                CupertinoIcons.add_circled_solid,
                color: Color(0xFF0084FF),
                size: 28,
              ),
              onPressed: _isUploadingImage
                  ? null
                  : () => _pickImage(ImageSource.gallery),
            ),
          ),

          // Botón de cámara
          Material(
            color: Colors.transparent,
            child: IconButton(
              icon: _isUploadingImage
                  ? const CupertinoActivityIndicator()
                  : const Icon(
                      CupertinoIcons.camera_fill,
                      color: Color(0xFF25D366),
                      size: 28,
                    ),
              onPressed: _isUploadingImage
                  ? null
                  : () => _pickImage(ImageSource.camera),
            ),
          ),

          // Campo de texto
          Expanded(
            child: CupertinoTextField(
              controller: _messageController,
              placeholder: 'type something...',
              placeholderStyle: TextStyle(color: Colors.grey.shade600),
              style: const TextStyle(color: CupertinoColors.black),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),

          const SizedBox(width: 8),

          // Botón de enviar
          Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  CupertinoIcons.paperplane_fill,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

