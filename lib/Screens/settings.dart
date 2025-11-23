import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const CupertinoSliverNavigationBar(
            largeTitle: Text("Settings"),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSettingsItem(
                icon: CupertinoIcons.star,
                iconColor: Colors.yellow.shade700,
                title: "Starred Messaged",
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: CupertinoIcons.device_phone_portrait,
                iconColor: Colors.lightBlue,
                title: "Linked Devices",
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: CupertinoIcons.person,
                iconColor: Colors.blue,
                title: "Account",
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: CupertinoIcons.chat_bubble_2,
                iconColor: Colors.green,
                title: "Chats",
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: CupertinoIcons.bell,
                iconColor: Colors.red,
                title: "Notifications",
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: CupertinoIcons.arrow_up_arrow_down,
                iconColor: Colors.lightGreen,
                title: "Storage and Data",
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: CupertinoIcons.info_circle,
                iconColor: Colors.blue,
                title: "Help",
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: CupertinoIcons.heart,
                iconColor: Colors.red,
                title: "Tell a Friend",
                onTap: () {},
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 0.5,
            ),
          ),
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF8B0000),
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: const Icon(
            CupertinoIcons.chevron_right,
            color: Color(0xFF8B0000),
            size: 18,
          ),
        ),
      ),
    );
  }
}
