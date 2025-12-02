/// Modelo de datos para representar un chat en la lista de conversaciones
/// Contiene información del contacto y el último mensaje del chat
class ChatsModel {
  final String name;      // Nombre del contacto con quien se chatea
  final String avatar;    // URL o ruta de la foto de perfil del contacto
  final String msg;       // Último mensaje enviado/recibido en el chat
  final String date;      // Fecha/hora del último mensaje (formateada)
  final String count;     // Número de mensajes no leídos (como String)
  final bool story;       // Indica si el contacto tiene historias
  final bool opened;      // Indica si el último mensaje fue abierto/leído
  final String type;      // Tipo de chat: 'incoming', 'outgoing', 'missed'

  // Constructor principal
  ChatsModel({
    required this.name,
    required this.avatar,
    required this.msg,
    required this.date,
    required this.count,
    required this.story,
    required this.opened,
    required this.type,
  });

  // Constructor desde JSON (para convertir datos a objeto)
  factory ChatsModel.fromJson(Map<String, dynamic> data) => ChatsModel(
        name: data['name'],
        avatar: data['avatar'],
        msg: data['msg'],
        date: data['date'],
        count: data['count'],
        story: data['story'],
        opened: data['opened'],
        type: data['type'],
      );
}