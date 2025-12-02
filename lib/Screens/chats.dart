import 'package:chat_app/Models/chats.dart';
import 'package:chat_app/globla.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Components/my_list_tile.dart';
import 'package:chat_app/Screens/chat_detail_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  String _getChatId(String contactName) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid ?? 'current_user';
    final participants = [currentUserId, contactName]..sort();
    return participants.join('_');
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
                    
                    // StreamBuilder para obtener el último mensaje desde Firestore
                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .doc(chatId)
                          .snapshots(),
                      builder: (context, chatSnapshot) {
                        String lastMessage = e.msg;
                        String lastMessageTime = e.date;
                        
                        // Si hay un último mensaje en Firestore, usarlo
                        if (chatSnapshot.hasData && chatSnapshot.data!.exists) {
                          final chatData = chatSnapshot.data!.data() as Map<String, dynamic>?;
                          if (chatData != null && chatData['lastMessage'] != null) {
                            lastMessage = chatData['lastMessage'] as String;
                            
                            // Formatear la fecha del último mensaje
                            if (chatData['lastMessageTime'] != null) {
                              final timestamp = chatData['lastMessageTime'] as Timestamp?;
                              if (timestamp != null) {
                                final date = timestamp.toDate();
                                final now = DateTime.now();
                                final difference = now.difference(date);
                                
                                if (difference.inDays == 0) {
                                  // Hoy: mostrar hora
                                  lastMessageTime = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                                } else if (difference.inDays == 1) {
                                  lastMessageTime = 'Ayer';
                                } else if (difference.inDays < 7) {
                                  // Esta semana: mostrar día
                                  final days = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
                                  lastMessageTime = days[date.weekday % 7];
                                } else {
                                  // Más de una semana: mostrar fecha
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



