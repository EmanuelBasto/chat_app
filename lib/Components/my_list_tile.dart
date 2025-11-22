import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Models/chats.dart';

class MyListTile extends StatelessWidget {
  final ChatsModel model;
  final VoidCallback? onTap;
  final VoidCallback? onImageTap;

  const MyListTile({
    super.key,
    required this.model,
    this.onTap,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    print("Avatar recibido: ${model.avatar}");
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // FOTO + TEXTOS
            Row(
              children: [
                // Avatar
                GestureDetector(
                  onTap: onImageTap ?? () {},
                  child: model.story
                      ? Container(
                          width: 61,
                          height: 61,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF25D366),
                              width: 2.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(2.5),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: model.avatar.startsWith("http")
                                ? NetworkImage(model.avatar)
                                : AssetImage(model.avatar) as ImageProvider,
                          ),
                        )
                      : CircleAvatar(
                          radius: 28,
                          backgroundImage: model.avatar.startsWith("http")
                              ? NetworkImage(model.avatar)
                              : AssetImage(model.avatar) as ImageProvider,
                        ),
                ),

                const SizedBox(width: 12),

                // Nombre + mensaje
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      model.msg,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // HORA + CONTADOR + FLECHA
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      model.date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),

                    const SizedBox(height: 8),

                    model.count == "0"
                        ? const SizedBox.shrink()
                        : CircleAvatar(
                            radius: 10,
                            backgroundColor: const Color(0xFFC10000),
                            child: Text(
                              model.count,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                  ],
                ),

                const SizedBox(width: 10),

                Icon(
                  CupertinoIcons.chevron_right,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

