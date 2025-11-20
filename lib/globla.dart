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
      "avatar": "https://i.pravatar.cc/150?img=1",
      "msg": "¿Cómo estás?",
      "date": "10:20 AM",
      "count": "1",
      "story": false,
      "opened": true,
      "type": "incoming"
    },
    {
      "name": "María López",
      "avatar": "https://i.pravatar.cc/150?img=2",
      "msg": "Te mandé el archivo",
      "date": "Ayer",
      "count": "3",
      "story": true,
      "opened": false,
      "type": "outgoing"
    },
    {
      "name": "Carlos García",
      "avatar": "https://i.pravatar.cc/150?img=3",
      "msg": "¡Listo el proyecto!",
      "date": "Lun",
      "count": "0",
      "story": false,
      "opened": true,
      "type": "incoming"
    },
    {
      "name": "Ana Torres",
      "avatar": "https://i.pravatar.cc/150?img=4",
      "msg": "Hablamos luego",
      "date": "12:45 PM",
      "count": "5",
      "story": true,
      "opened": false,
      "type": "missed"
    },
    {
      "name": "Roberto Cruz",
      "avatar": "https://i.pravatar.cc/150?img=5",
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
      "first_name": "Carlos",
      "last_name": "Mendoza",
      "msg": "Nos vemos mañana",
      "date": "Hoy",
      "count": 0,
      "story": true,
      "image": "https://picsum.photos/300/200",
      "avatar": "https://i.pravatar.cc/150?img=11",
      "status": "Disponible",
      "stories": ["img1", "img2"]
    },
    {
      "first_name": "Laura",
      "last_name": "Cortés",
      "msg": "Voy en camino",
      "date": "Ayer",
      "count": 1,
      "story": false,
      "image": "https://picsum.photos/300/201",
      "avatar": "https://i.pravatar.cc/150?img=12",
      "status": "Ocupada",
      "stories": ["img1"]
    },
    {
      "first_name": "Miguel",
      "last_name": "Ángel",
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
      "first_name": "Sofía",
      "last_name": "Ramírez",
      "msg": "Listo todo",
      "date": "8:15 AM",
      "count": 0,
      "story": false,
      "image": "https://picsum.photos/300/203",
      "avatar": "https://i.pravatar.cc/150?img=14",
      "status": "Conectada",
      "stories": []
    },
    {
      "first_name": "Daniel",
      "last_name": "Torres",
      "msg": "Te marco luego",
      "date": "Lun",
      "count": 4,
      "story": true,
      "image": "https://picsum.photos/300/204",
      "avatar": "https://i.pravatar.cc/150?img=15",
      "status": "Ausente",
      "stories": ["img1"]
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
    "avatar": "https://i.pravatar.cc/150?img=30",
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
