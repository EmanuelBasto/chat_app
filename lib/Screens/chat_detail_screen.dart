import 'package:chat_app/Models/chats.dart';
import 'package:chat_app/Models/message.dart';
import 'package:chat_app/globla.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatelessWidget {
  final ChatsModel chat;

  const ChatDetailScreen({Key? key, required this.chat}) : super(key: key);

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

            // Lista de mensajes
            Expanded(
              child: FutureBuilder<List<MessageModel>>(
                future: WhatsApp.getChatMessages(chat.name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child: Text(
                        'Error al cargar mensajes',
                        style: TextStyle(color: CupertinoColors.black),
                      ),
                    );
                  }

                  final messages = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(messages[index]);
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
              chat.name,
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
              placeholder: 'type something...',
              placeholderStyle: TextStyle(color: Colors.grey.shade600),
              style: const TextStyle(color: CupertinoColors.black),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

