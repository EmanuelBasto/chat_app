import 'package:chat_app/Models/people.dart';
import 'package:chat_app/Models/me.dart';
import 'package:chat_app/globla.dart';
import 'package:chat_app/Screens/story_screen.dart';
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
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: me.avatar.isNotEmpty
                              ? (me.avatar.startsWith("http")
                                  ? NetworkImage(me.avatar)
                                  : AssetImage(me.avatar) as ImageProvider)
                              : null,
                          child: me.avatar.isEmpty
                              ? Icon(
                                  CupertinoIcons.person_fill,
                                  size: 28,
                                  color: Colors.grey.shade600,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${me.firstName} ${me.lastName}".trim(),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              me.status.isNotEmpty ? me.status : "Update status",
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
                  padding: const EdgeInsets.only(left: 16, top: 12, bottom: 8),
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
                  height: 110,
                  child: Scrollbar(
                    thickness: 0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: recentUpdates.length,
                      itemBuilder: (context, index) {
                        final person = recentUpdates[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => StoryScreen(person: person),
                              ),
                            );
                          },
                          child: Container(
                            width: 75,
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 2.5,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(2.5),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: person.avatar.startsWith("http")
                                        ? NetworkImage(person.avatar)
                                        : AssetImage(person.avatar) as ImageProvider,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(
                                    "${person.first_name} ${person.last_name}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
                        backgroundImage: e.avatar.startsWith("http")
                            ? NetworkImage(e.avatar)
                            : AssetImage(e.avatar) as ImageProvider,
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

