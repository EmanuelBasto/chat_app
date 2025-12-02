/// Modelo de datos para representar un mensaje en un chat
/// Contiene toda la información necesaria para mostrar un mensaje
class MessageModel {
  final String image;      // URL o ruta de la imagen (si el mensaje es tipo imagen)
  final String msg;        // Contenido del mensaje de texto
  final bool sender;      // true = enviado por el usuario actual, false = recibido
  final String type;      // Tipo de mensaje: 'text' o 'image'
  final bool opened;      // Indica si el mensaje ha sido leído

  // Constructor principal
  MessageModel({
    required this.image,
    required this.msg,
    required this.sender,
    required this.type,
    required this.opened,
  });

  // Constructor desde JSON (para convertir datos de Firestore/API a objeto)
  factory MessageModel.fromJson(Map<String, dynamic> data) => MessageModel(
      image: data['image'],
      msg: data['msg'],
      sender: data['sender'],
      type: data['type'],
      opened: (data['opened']),
    );
}