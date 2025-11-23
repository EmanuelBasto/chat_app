import 'package:chat_app/Models/people.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoryScreen extends StatefulWidget {
  final PeopleModel person;

  const StoryScreen({
    Key? key,
    required this.person,
  }) : super(key: key);

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late List<String> allStories;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    // Combinar la imagen principal con las historias adicionales
    allStories = [widget.person.image, ...widget.person.stories];
    currentIndex = 0;
  }

  void _nextStory() {
    if (currentIndex < allStories.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void _previousStory() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStory = allStories[currentIndex];
    
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          // Imagen de fondo a pantalla completa
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (details) {
                final screenWidth = MediaQuery.of(context).size.width;
                final tapX = details.globalPosition.dx;
                
                // Si toca en la mitad derecha, siguiente estado
                if (tapX > screenWidth / 2) {
                  _nextStory();
                } else {
                  // Si toca en la mitad izquierda, estado anterior
                  _previousStory();
                }
              },
              child: currentStory.startsWith("http")
                  ? Image.network(
                      currentStory,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade900,
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.photo,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      currentStory,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade900,
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.photo,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          // Barra superior con información del usuario
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      // Información del usuario a la izquierda
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: widget.person.avatar.startsWith("http")
                                ? NetworkImage(widget.person.avatar)
                                : AssetImage(widget.person.avatar) as ImageProvider,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${widget.person.first_name} ${widget.person.last_name}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Contador de estados
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${currentIndex + 1}/${allStories.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Botones a la derecha
                      IconButton(
                        icon: const Icon(
                          CupertinoIcons.ellipsis,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          CupertinoIcons.xmark,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

