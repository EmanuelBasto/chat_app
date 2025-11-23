import 'package:chat_app/Models/chats.dart';
import 'package:chat_app/globla.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Components/my_list_tile.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

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
                    return MyListTile(
                      model: e,
                      onTap: () {},
                      onImageTap: () {},
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



