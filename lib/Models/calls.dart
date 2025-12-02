/// Modelo de datos para representar una llamada en el historial
/// Almacena información sobre llamadas realizadas, recibidas o perdidas
class CallsModel {
  final String name;        // Nombre del contacto con quien se hizo la llamada
  final String time;        // Hora o fecha de la llamada
  final String callType;    // Tipo: 'outgoing', 'incoming' o 'missed'
  final String profilePic;  // URL o ruta de la foto de perfil del contacto

  // Constructor principal
  CallsModel({
    required this.name,
    required this.time,
    required this.callType,
    required this.profilePic,
  });

  // Constructor desde JSON (para convertir datos a objeto)
  factory CallsModel.fromJson(Map<String, dynamic> data) => CallsModel(
      name: data['name'],
      time: data['time'],
      callType: data['callType'],
      profilePic: data['profilePic'],
    );
  
}
