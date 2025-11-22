import 'package:chat_app/Models/people.dart';
import 'package:chat_app/Models/me.dart';
import 'package:chat_app/globla.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(   // ⭐ IMPORTANTE AQUÍ TAMBIÉN
      child: FutureBuilder<List<dynamic>>(
        future: Future.wait([WhatsApp.People(), WhatsApp.Me()]),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final people = snapshot.data![0] as List<PeopleModel>;
          final me = snapshot.data![1] as MeModel;
          final recentUpdates = people.where((p) => p.story).toList();

          return CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text("People"),
                trailing: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.person_add),
                    onPressed: () {},
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: CupertinoSearchTextField(
                    placeholder: "Search",
                    onChanged: (value) {},
                    onSubmitted: (value) {},
                  ),
                ),
              ),
              // My Status Section
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 61,
                        height: 61,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.red,
                            width: 2.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(2.5),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(me.avatar),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "My Status",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              "Update status",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(CupertinoIcons.camera_fill, color: Colors.green.shade600, size: 28),
                      const SizedBox(width: 12),
                      Icon(CupertinoIcons.pencil, color: Colors.blue.shade600, size: 24),
                    ],
                  ),
                ),
              ),
              // Recent Updates Section
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  child: const Text(
                    "Recent Updates",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: recentUpdates.length,
                    itemBuilder: (context, index) {
                      final person = recentUpdates[index];
                      return Container(
                        width: 70,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            Container(
                              width: 61,
                              height: 61,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.red,
                                  width: 2.5,
                                ),
                              ),
                              padding: const EdgeInsets.all(2.5),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(person.avatar),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${person.first_name} ${person.last_name}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Contacts List
              SliverList(
                delegate: SliverChildListDelegate(
                  people.map(
                    (e) => ListTile(
                      title: Text("${e.first_name} ${e.last_name}"),
                      subtitle: Text(e.status),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(e.avatar),
                      ),
                      trailing: Icon(
                        CupertinoIcons.chevron_right,
                        color: Colors.grey.shade400,
                        size: 20,
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

