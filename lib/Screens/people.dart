import 'package:chat_app/Models/people.dart';
import 'package:chat_app/globla.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:chat_app/Components/search_bar.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(   // ⭐ IMPORTANTE AQUÍ TAMBIÉN
      child: FutureBuilder<List<PeopleModel>>(
        future: WhatsApp.People(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final people = snapshot.data!;

          return CustomScrollView(
            slivers: [
              const CupertinoSliverNavigationBar(
                largeTitle: Text("People"),
              ),
              SearchBar(onChanged: () {}, onSubmitted: () {}),
              SliverList(
                delegate: SliverChildListDelegate(
                  people.map(
                    (e) => ListTile(
                      title: Text("${e.first_name} ${e.last_name}"),
                      subtitle: Text(e.status),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(e.avatar),
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

