import 'package:chat_app/Models/chats.dart';
import 'package:chat_app/Models/message.dart';
import 'package:chat_app/globla.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatsModel chat;

  const ChatDetailScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getChatId() {
    // Crear un ID único para el chat basado en el nombre del contacto
    // En una app real, usarías los UIDs de los usuarios
    final currentUserId = _currentUser?.uid ?? 'current_user';
    final contactName = widget.chat.name;
    // Ordenar para que siempre sea el mismo ID independientemente del orden
    final participants = [currentUserId, contactName]..sort();
    return participants.join('_');
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    final currentUser = _currentUser;
    if (messageText.isEmpty || currentUser == null) return;

    try {
      final chatId = _getChatId();
      final currentUserId = currentUser.uid;
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc();

      await messageRef.set({
        'msg': messageText,
        'sender': true, // true = usuario actual, false = contacto
        'senderId': currentUserId,
        'type': 'text',
        'opened': false,
        'image': '',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Actualizar el último mensaje en la colección de chats
      await _firestore.collection('chats').doc(chatId).set({
        'lastMessage': messageText,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'participants': [currentUserId, widget.chat.name],
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _messageController.clear();
      
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
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .doc(_getChatId())
                    .collection('messages')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
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

    return Builder(
      builder: (context) => Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
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
          // Botón de más
          Material(
            color: Colors.transparent,
            child: IconButton(
              icon: const Icon(
                CupertinoIcons.add_circled_solid,
                color: Color(0xFF0084FF),
                size: 28,
              ),
              onPressed: () {},
            ),
          ),

          // Botón de cámara
          Material(
            color: Colors.transparent,
            child: IconButton(
              icon: const Icon(
                CupertinoIcons.camera_fill,
                color: Color(0xFF25D366),
                size: 28,
              ),
              onPressed: () {},
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

