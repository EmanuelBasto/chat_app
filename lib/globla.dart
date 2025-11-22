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
      "image": "https://picsum.photos/300/200",
      "avatar": "https://i.pravatar.cc/150?img=11",
      "status": "Disponible",
      "stories": ["img1", "img2"]
    },
    {
      "first_name": "Laury",
      "last_name": "Walsh",
      "msg": "vel vel ea",
      "date": "Ayer",
      "count": 1,
      "story": true,
      "image": "https://picsum.photos/300/201",
      "avatar": "https://i.pravatar.cc/150?img=12",
      "status": "Ocupada",
      "stories": ["img1"]
    },
    {
      "first_name": "Jedidiah",
      "last_name": "Denesik",
      "msg": "Gracias!",
      "date": "Dom",
      "count": 2,
      "story": true,
      "image": "https://picsum.photos/300/202",
      "avatar": "https://i.pravatar.cc/150?img=13",
      "status": "En el trabajo",
      "stories": ["img1", "img2", "img3"]
    },
    {
      "first_name": "Sheridan",
      "last_name": "Wehner",
      "msg": "Listo todo",
      "date": "8:15 AM",
      "count": 0,
      "story": true,
      "image": "https://picsum.photos/300/203",
      "avatar": "https://i.pravatar.cc/150?img=14",
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
      "image": "https://picsum.photos/300/204",
      "avatar": "https://i.pravatar.cc/150?img=15",
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
      "image": "https://picsum.photos/300/205",
      "avatar": "https://i.pravatar.cc/150?img=16",
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
      "image": "https://picsum.photos/300/206",
      "avatar": "https://i.pravatar.cc/150?img=17",
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
      "image": "https://picsum.photos/300/207",
      "avatar": "https://i.pravatar.cc/150?img=18",
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
      "image": "https://picsum.photos/300/208",
      "avatar": "https://i.pravatar.cc/150?img=19",
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
      "image": "https://picsum.photos/300/209",
      "avatar": "https://i.pravatar.cc/150?img=20",
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
      "image": "https://picsum.photos/300/210",
      "avatar": "https://i.pravatar.cc/150?img=21",
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
      "name": "Juan Pérez",
      "time": "10:20 AM",
      "callType": "incoming",
      "profilePic": "https://i.pravatar.cc/150?img=21"
    },
    {
      "name": "María López",
      "time": "Ayer",
      "callType": "missed",
      "profilePic": "https://i.pravatar.cc/150?img=22"
    },
    {
      "name": "Carlos García",
      "time": "Lun",
      "callType": "outgoing",
      "profilePic": "https://i.pravatar.cc/150?img=23"
    },
    {
      "name": "Ana Torres",
      "time": "Hoy 8:00 AM",
      "callType": "incoming",
      "profilePic": "https://i.pravatar.cc/150?img=24"
    },
    {
      "name": "Roberto Cruz",
      "time": "Mar",
      "callType": "missed",
      "profilePic": "https://i.pravatar.cc/150?img=25"
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
    "stories": ["img1", "img2", "img3"]
  };

  return MeModel.fromJson(fakeJson);
}

}
