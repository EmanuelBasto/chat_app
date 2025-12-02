import 'package:chat_app/Models/calls.dart';
import 'package:chat_app/Models/chats.dart';
import 'package:chat_app/Models/message.dart';
import 'package:chat_app/Models/people.dart';
import 'package:chat_app/Models/me.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppColors {
  static Color? primary = const Color(0xFFC10000);
}

class WhatsApp {
  static Future<List<ChatsModel>> Chats() async {
  await Future.delayed(const Duration(milliseconds: 800));

  final fakeJson = [
    {
      "name": "Juan Pérez",
      "avatar": "assets/images/Juan.jpg",
      "msg": "¿Cómo estás?",
      "date": "10:20 AM",
      "count": "1",
      "story": false,
      "opened": true,
      "type": "incoming"
    },
    {
      "name": "María López",
      "avatar": "assets/images/MariaP.jpg",
      "msg": "Te mandé el archivo",
      "date": "Ayer",
      "count": "3",
      "story": true,
      "opened": false,
      "type": "outgoing"
    },
    {
      "name": "Carlos García",
      "avatar": "assets/images/CarlosG.jpg",
      "msg": "¡Listo el proyecto!",
      "date": "Lun",
      "count": "10",
      "story": false,
      "opened": true,
      "type": "incoming"
    },
    {
      "name": "Ana Torres",
      "avatar": "assets/images/AnaT.jpg",
      "msg": "Hablamos luego",
      "date": "12:45 PM",
      "count": "5",
      "story": true,
      "opened": false,
      "type": "missed"
    },
    {
      "name": "Roberto Cruz",
      "avatar": "assets/images/RobertoT.jpg",
      "msg": "¿Vienes hoy?",
      "date": "Mar",
      "count": "2",
      "story": false,
      "opened": true,
      "type": "incoming"
    },
  ];

  return fakeJson.map((e) => ChatsModel.fromJson(e)).toList();
}


  static Future<List<PeopleModel>> People() async {
  await Future.delayed(const Duration(milliseconds: 800));

  final fakeJson = [
    {
      "first_name": "Otilia",
      "last_name": "Carter",
      "msg": "sint nemo ut",
      "date": "Hoy",
      "count": 0,
      "story": true,
      "image": "assets/images/story_otilia.jpg",
      "avatar": "assets/images/otilia.jpg",
      "status": "Disponible",
      "stories": ["assets/images/story_allene.jpg", "assets/images/story_carlos_m.jpg"]
    },
    {
      "first_name": "Laury",
      "last_name": "Walsh",
      "msg": "vel vel ea",
      "date": "Ayer",
      "count": 1,
      "story": true,
      "image": "assets/images/story_laury.jpg",
      "avatar": "assets/images/laury.jpg",
      "status": "Ocupada",
      "stories": ["assets/images/story_daniel.jpg"]
    },
    {
      "first_name": "Jedidiah",
      "last_name": "Denesik",
      "msg": "Gracias!",
      "date": "Dom",
      "count": 2,
      "story": true,
      "image": "assets/images/story_jedidiah.jpg",
      "avatar": "assets/images/jedidiah.jpg",
      "status": "En el trabajo",
      "stories": ["assets/images/story_laura.jpg", "assets/images/story_miguel.jpg", "assets/images/story_sofia.jpg"]
    },
    {
      "first_name": "Sheridan",
      "last_name": "Wehner",
      "msg": "Listo todo",
      "date": "8:15 AM",
      "count": 0,
      "story": true,
      "image": "assets/images/story_sheridan.jpg",
      "avatar": "assets/images/sheridan.jpg",
      "status": "Conectada",
      "stories": []
    },
    {
      "first_name": "Marilie",
      "last_name": "Reinger",
      "msg": "sint nemo ut",
      "date": "Lun",
      "count": 4,
      "story": false,
      "image": "assets/images/story_marilie.jpg",
      "avatar": "assets/images/marilie.jpg",
      "status": "Ausente",
      "stories": []
    },
    {
      "first_name": "Allene",
      "last_name": "Deckow",
      "msg": "vel vel ea",
      "date": "Mar",
      "count": 0,
      "story": false,
      "image": "assets/images/story_allene.jpg",
      "avatar": "assets/images/allene.jpg",
      "status": "Disponible",
      "stories": []
    },
    {
      "first_name": "Carlos",
      "last_name": "Mendoza",
      "msg": "Nos vemos mañana",
      "date": "Hoy",
      "count": 0,
      "story": false,
      "image": "assets/images/story_carlos_m.jpg",
      "avatar": "assets/images/carlos_m.jpg",
      "status": "Disponible",
      "stories": []
    },
    {
      "first_name": "Laura",
      "last_name": "Cortés",
      "msg": "Voy en camino",
      "date": "Ayer",
      "count": 1,
      "story": false,
      "image": "assets/images/story_laura.jpg",
      "avatar": "assets/images/laura.jpg",
      "status": "Ocupada",
      "stories": []
    },
    {
      "first_name": "Miguel",
      "last_name": "Ángel",
      "msg": "Gracias!",
      "date": "Dom",
      "count": 2,
      "story": false,
      "image": "assets/images/story_miguel.jpg",
      "avatar": "assets/images/miguel.jpg",
      "status": "En el trabajo",
      "stories": []
    },
    {
      "first_name": "Sofía",
      "last_name": "Ramírez",
      "msg": "Listo todo",
      "date": "8:15 AM",
      "count": 0,
      "story": false,
      "image": "assets/images/story_sofia.jpg",
      "avatar": "assets/images/sofia.jpg",
      "status": "Conectada",
      "stories": []
    },
    {
      "first_name": "Daniel",
      "last_name": "Torres",
      "msg": "Te marco luego",
      "date": "Lun",
      "count": 4,
      "story": false,
      "image": "assets/images/story_daniel.jpg",
      "avatar": "assets/images/daniel.jpg",
      "status": "Ausente",
      "stories": []
    },
  ];

  return fakeJson.map((e) => PeopleModel.fromJson(e)).toList();
}


  static Future<List<MessageModel>> Messages() async {
  await Future.delayed(const Duration(milliseconds: 800));

  final fakeJson = [
    {
      "name": "Juan Pérez",
      "time": "10:20 AM",
      "callType": "incoming",
      "profilePic": "assets/images/JuanP.jpg"
    },
    {
      "name": "María López",
      "time": "Ayer",
      "callType": "missed",
      "profilePic": "assets/images/MariaPM.jpg"
    },
    {
      "name": "Carlos García",
      "time": "Lun",
      "callType": "outgoing",
      "profilePic": "assets/images/CarlosGM.jpg"
    },
    {
      "name": "Ana Torres",
      "time": "Hoy 8:00 AM",
      "callType": "incoming",
      "profilePic": "assets/images/AnaTM.jpg"
    },
    {
      "name": "Roberto Cruz",
      "time": "Mar",
      "callType": "missed",
      "profilePic": "RobertoTM.jpg"
    },
  ];

  return fakeJson.map((e) => MessageModel.fromJson(e)).toList();
}

  static Future<List<MessageModel>> getChatMessages(String contactName) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mensajes de prueba basados en la imagen - expandidos para permitir scroll
    final fakeJson = [
      {
        "image": "",
        "msg": "https://loremflickr.com/640/480/nature",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Hic corrupti laboriosam soluta voluptatum asperiores sed doloribus culpa similique consequatur at recusandae beatae qui a qui eius dolorum blanditiis.",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "https://www.youtube.com/watch?v=lTmoxYjtZZO",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Eligendi sed soluta rem ipsa at sunt praesentium minima ut doloremque rem dolor reprehenderit error non et non repellat nobis.",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "https://loremflickr.com/640/480/technics",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "https://www.youtube.com/watch?v=W-dYWkcqFXc",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "https://loremflickr.com/640/480/cats",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "https://loremflickr.com/640/480/technics",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "https://loremflickr.com/640/480/",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "¡Hola! ¿Cómo estás?",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Muy bien, gracias. ¿Y tú qué tal?",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Perfecto, aquí trabajando en el proyecto",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Qué bien! ¿Necesitas ayuda con algo?",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Gracias, por ahora todo bien",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "https://www.example.com/article",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Interesante, lo revisaré más tarde",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Perfecto, avísame qué te parece",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Claro, sin problema",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "https://loremflickr.com/640/480/abstract",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Wow, qué imagen tan genial!",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Me alegra que te guste",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "¿Vamos a almorzar juntos?",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Sí, claro. ¿A qué hora?",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "A la 1:30 PM, ¿te va bien?",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Perfecto, nos vemos entonces",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Jaja, muy bueno ese video",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Sabía que te gustaría",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "https://loremflickr.com/640/480/business",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Necesito tu opinión sobre esto",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Déjame verlo con calma y te respondo",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Perfecto, no hay prisa",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "¿Qué planes tienes para el fin de semana?",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Nada especial, probablemente descansar",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Suena bien, todos necesitamos un descanso",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Exacto, el descanso es importante",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "https://loremflickr.com/640/480/food",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Se ve delicioso!",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Es de un nuevo restaurante que encontré",
        "sender": false,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "Tenemos que ir juntos algún día",
        "sender": true,
        "type": "text",
        "opened": true,
      },
      {
        "image": "",
        "msg": "¡Por supuesto! Te invito",
        "sender": false,
        "type": "text",
        "opened": true,
      },
    ];

    return fakeJson.map((e) => MessageModel.fromJson(e)).toList();
  }

static Future<List<CallsModel>> Calls() async {
  await Future.delayed(const Duration(milliseconds: 800));

  final fakeJson = [
    {
      "name": "Axel Quigley",
      "time": "10:20 AM",
      "callType": "outgoing",
      "profilePic": "assets/images/Juan.jpg"
    },
    {
      "name": "Asia Pouros",
      "time": "Ayer",
      "callType": "outgoing",
      "profilePic": "assets/images/MariaP.jpg"
    },
    {
      "name": "Emmie Weimann",
      "time": "Lun",
      "callType": "missed",
      "profilePic": "assets/images/CarlosG.jpg"
    },
    {
      "name": "Concepcion Bauch",
      "time": "Hoy 8:00 AM",
      "callType": "outgoing",
      "profilePic": "assets/images/AnaT.jpg"
    },
    {
      "name": "Daniela Stark",
      "time": "Mar",
      "callType": "incoming",
      "profilePic": "assets/images/RobertoT.jpg"
    },
    {
      "name": "Garnet Hermiston",
      "time": "Ayer",
      "callType": "missed",
      "profilePic": "assets/images/laura.jpg"
    },
  ];

  return fakeJson.map((e) => CallsModel.fromJson(e)).toList();
}





   static Future<MeModel> Me() async {
     try {
       final user = FirebaseAuth.instance.currentUser;
       
       if (user == null) {
         // Si no hay usuario autenticado, devolver datos por defecto
         final fakeJson = {
           "first_name": "Usuario",
           "last_name": "",
           "avatar": "assets/images/me.jpg",
           "city": "",
           "relationship": "",
           "gender": "",
           "job_title": "",
           "job_area": "",
           "story": false,
           "status": "Disponible",
           "stories": []
         };
         return MeModel.fromJson(fakeJson);
       }

       // Obtener datos del usuario desde Firestore
       final userDoc = await FirebaseFirestore.instance
           .collection('users')
           .doc(user.uid)
           .get();

       if (!userDoc.exists) {
         // Si no existe el documento, devolver datos por defecto
         final name = user.displayName ?? "Usuario";
         final nameParts = name.split(' ');
         final firstName = nameParts.isNotEmpty ? nameParts[0] : "Usuario";
         final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : "";
         
         final fakeJson = {
           "first_name": firstName,
           "last_name": lastName,
           "avatar": user.photoURL ?? "assets/images/me.jpg",
           "city": "",
           "relationship": "",
           "gender": "",
           "job_title": "",
           "job_area": "",
           "story": false,
           "status": "Disponible",
           "stories": []
         };
         return MeModel.fromJson(fakeJson);
       }

       final userData = userDoc.data() as Map<String, dynamic>;
       
       // Dividir el nombre en first_name y last_name
       final name = userData['name'] ?? user.displayName ?? "Usuario";
       final nameParts = name.split(' ');
       final firstName = nameParts.isNotEmpty ? nameParts[0] : "Usuario";
       final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : "";
       
       // Obtener la URL de la imagen de perfil
       final profileImageUrl = userData['profileImageUrl'] ?? user.photoURL ?? "assets/images/me.jpg";
       
       final json = {
         "first_name": firstName,
         "last_name": lastName,
         "avatar": profileImageUrl,
         "city": userData['city'] ?? "",
         "relationship": userData['relationship'] ?? "",
         "gender": userData['gender'] ?? "",
         "job_title": userData['job_title'] ?? "",
         "job_area": userData['job_area'] ?? "",
         "story": userData['story'] ?? false,
         "status": userData['status'] ?? "Disponible",
         "stories": List<String>.from(userData['stories'] ?? [])
       };

       return MeModel.fromJson(json);
     } catch (e) {
       print('Error obteniendo datos del usuario: $e');
       // En caso de error, devolver datos por defecto
       final fakeJson = {
         "first_name": "Usuario",
         "last_name": "",
         "avatar": "assets/images/me.jpg",
         "city": "",
         "relationship": "",
         "gender": "",
         "job_title": "",
         "job_area": "",
         "story": false,
         "status": "Disponible",
         "stories": []
       };
       return MeModel.fromJson(fakeJson);
     }
   }

}
