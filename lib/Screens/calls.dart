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
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text("Calls"),
                trailing: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.phone),
                    onPressed: () {},
                    iconSize: 24,
                    color: Colors.red,
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
              SliverList(
                delegate: SliverChildListDelegate(
                  calls.map(
                    (e) {
                      // Determinar el icono según el tipo de llamada
                      IconData callIcon;
                      Color iconColor;
                      String callTypeText;
                      
                      switch (e.callType.toLowerCase()) {
                        case 'outgoing':
                          callIcon = CupertinoIcons.phone_arrow_up_right;
                          iconColor = Colors.grey.shade600;
                          callTypeText = 'Outgoing';
                          break;
                        case 'incoming':
                          callIcon = CupertinoIcons.phone_arrow_down_left;
                          iconColor = Colors.grey.shade600;
                          callTypeText = 'Incoming';
                          break;
                        case 'missed':
                          callIcon = CupertinoIcons.phone_arrow_down_left;
                          iconColor = Colors.red;
                          callTypeText = 'Missed';
                          break;
                        default:
                          callIcon = CupertinoIcons.phone;
                          iconColor = Colors.grey.shade600;
                          callTypeText = e.callType;
                      }
                      
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        minLeadingWidth: 60,
                        title: Text(
                          e.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            callTypeText,
                            style: TextStyle(
                              fontSize: 15,
                              color: e.callType.toLowerCase() == 'missed' 
                                  ? Colors.red 
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                        leading: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: e.profilePic.startsWith("http")
                              ? NetworkImage(e.profilePic)
                              : AssetImage(e.profilePic) as ImageProvider,
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            callIcon,
                            color: iconColor,
                            size: 20,
                          ),
                        ),
                      );
                    },
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


