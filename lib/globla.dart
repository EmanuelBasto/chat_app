import 'package:chat_app/Models/calls.dart';
import 'package:chat_app/Models/chats.dart';
import 'package:chat_app/Models/message.dart';
import 'package:chat_app/Models/people.dart';
import 'package:chat_app/Models/me.dart';
import 'package:flutter/cupertino.dart';

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
      "first_name": "Stacy",
      "last_name": "Hermiston",
      "msg": "Lorem ipsum",
      "date": "Hoy",
      "count": 0,
      "story": true,
      "image": "assets/images/story_otilia.jpg",
      "avatar": "assets/images/otilia.jpg",
      "status": "Disponible",
      "stories": ["assets/images/story_marilie.jpg"]
    },
    {
      "first_name": "Jessica",
      "last_name": "Ratke",
      "msg": "dolor sit amet",
      "date": "Ayer",
      "count": 1,
      "story": true,
      "image": "assets/images/story_laury.jpg",
      "avatar": "assets/images/laury.jpg",
      "status": "Ocupada",
      "stories": ["assets/images/story_allene.jpg", "assets/images/story_carlos_m.jpg"]
    },
    {
      "first_name": "Cristopher",
      "last_name": "Hagenes",
      "msg": "consectetur",
      "date": "Dom",
      "count": 0,
      "story": true,
      "image": "assets/images/story_jedidiah.jpg",
      "avatar": "assets/images/jedidiah.jpg",
      "status": "En el trabajo",
      "stories": ["assets/images/story_daniel.jpg"]
    },
    {
      "first_name": "Lewis",
      "last_name": "Glover",
      "msg": "adipiscing elit",
      "date": "Lun",
      "count": 2,
      "story": true,
      "image": "assets/images/story_sheridan.jpg",
      "avatar": "assets/images/sheridan.jpg",
      "status": "Conectada",
      "stories": ["assets/images/story_laura.jpg", "assets/images/story_miguel.jpg"]
    },
    {
      "first_name": "Beryl",
      "last_name": "Wintheiser",
      "msg": "sed do eiusmod",
      "date": "Mar",
      "count": 0,
      "story": true,
      "image": "assets/images/story_otilia.jpg",
      "avatar": "assets/images/otilia.jpg",
      "status": "Disponible",
      "stories": ["assets/images/story_sofia.jpg"]
    },
    {
      "first_name": "Vicenta",
      "last_name": "Jaskolski",
      "msg": "tempor incididunt",
      "date": "Mié",
      "count": 1,
      "story": true,
      "image": "assets/images/story_laury.jpg",
      "avatar": "assets/images/laury.jpg",
      "status": "Ocupada",
      "stories": ["assets/images/story_marilie.jpg"]
    },
    {
      "first_name": "Maurine",
      "last_name": "Effertz",
      "msg": "ut labore",
      "date": "Jue",
      "count": 0,
      "story": true,
      "image": "assets/images/story_jedidiah.jpg",
      "avatar": "assets/images/jedidiah.jpg",
      "status": "En el trabajo",
      "stories": ["assets/images/story_allene.jpg", "assets/images/story_carlos_m.jpg"]
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

static Future<List<CallsModel>> Calls() async {
  await Future.delayed(const Duration(milliseconds: 800));

  final fakeJson = [
    {
      "name": "Estefania Stokes",
      "time": "10:27 AM",
      "callType": "outgoing",
      "profilePic": "assets/images/estefania.jpg"
    },
    {
      "name": "Irma O'Reilly",
      "time": "9:45 AM",
      "callType": "outgoing",
      "profilePic": "assets/images/irma.jpg"
    },
    {
      "name": "Velma Brown",
      "time": "Ayer",
      "callType": "outgoing",
      "profilePic": "assets/images/velma.jpg"
    },
    {
      "name": "Eugenia O'Conner",
      "time": "Ayer",
      "callType": "incoming",
      "profilePic": "assets/images/eugenia.jpg"
    },
    {
      "name": "Adaline Crooks",
      "time": "Lun",
      "callType": "incoming",
      "profilePic": "assets/images/adaline.jpg"
    },
    {
      "name": "Jonatan Hansen",
      "time": "Dom",
      "callType": "missed",
      "profilePic": "assets/images/jonatan.jpg"
    },
    {
      "name": "Juan Pérez",
      "time": "Sáb",
      "callType": "outgoing",
      "profilePic": "assets/images/juan_calls.jpg"
    },
    {
      "name": "María López",
      "time": "Vie",
      "callType": "incoming",
      "profilePic": "assets/images/maria_calls.jpg"
    },
    {
      "name": "Carlos García",
      "time": "Jue",
      "callType": "missed",
      "profilePic": "assets/images/carlos_calls.jpg"
    },
  ];

  return fakeJson.map((e) => CallsModel.fromJson(e)).toList();
}





   static Future<MeModel> Me() async {
   await Future.delayed(const Duration(milliseconds: 800));

   final fakeJson = {
     "first_name": "Alejandro",
     "last_name": "Núñez",
     "avatar": "assets/images/me.jpg",
     "city": "Ciudad de México",
     "relationship": "Soltero",
     "gender": "Masculino",
     "job_title": "Ingeniero de Software",
     "job_area": "Tecnología",
     "story": true,
     "status": "Disponible",
     "stories": ["assets/images/story_daniel.jpg", "assets/images/story_laura.jpg", "assets/images/story_miguel.jpg"]
   };

   return MeModel.fromJson(fakeJson);
 }

}
