import 'package:chat_app/Models/chats.dart';
import 'package:chat_app/globla.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Components/my_list_tile.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

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
              const CupertinoSliverNavigationBar(
                largeTitle: Text("Chats"),
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



