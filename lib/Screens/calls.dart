import 'package:chat_app/Models/calls.dart';
import 'package:chat_app/globla.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CallsScreen extends StatelessWidget {
  const CallsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(   // ⭐ NECESARIO PARA WEB
      child: FutureBuilder<List<CallsModel>>(
        future: WhatsApp.Calls(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final calls = snapshot.data!;

          return CustomScrollView(
            slivers: [
              const CupertinoSliverNavigationBar(
                largeTitle: Text("Calls"),
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
                delegate: SliverChildListDelegate(
                  calls.map(
                    (e) => ListTile(   // ya NO falla
                      title: Text(e.name),
                      subtitle: Text("${e.callType} • ${e.time}"),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(e.profilePic),
                      ),
                    ),
                  ).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


