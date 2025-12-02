/// Modelo de datos para representar un contacto en la lista de personas
/// Contiene información del perfil, estado y historias del contacto
class PeopleModel {
  final String first_name;    // Nombre del contacto
  final String last_name;      // Apellido del contacto
  final String msg;            // Último mensaje o estado del contacto
  final String date;           // Fecha del último mensaje/actualización
  final int count;             // Contador de mensajes no leídos
  final bool story;            // Indica si el contacto tiene historias (stories)
  final String image;          // Imagen principal de la historia
  final String avatar;         // Foto de perfil del contacto
  final String status;         // Estado del contacto (ej: "Disponible", "Ocupado")
  final List<String> stories;  // Lista de URLs/rutas de las historias del contacto

  // Constructor principal
  PeopleModel({
    required this.first_name,
    required this.last_name,
    required this.msg,
    required this.date,
    required this.count,
    required this.story,
    required this.image,
    required this.avatar,
    required this.status,
    required this.stories,
  });

  // Constructor desde JSON (para convertir datos de Firestore/API a objeto)
  factory PeopleModel.fromJson(Map<String, dynamic> data) => PeopleModel(
        first_name: data['first_name'],
        last_name: data['last_name'],
        msg: data['msg'],
        date: data['date'],
        count: data['count'],
        story: data['story'],
        image: data['image'],
        avatar: data['avatar'],
        status: data['status'],
        stories: List.from(data['stories']),  // Convertir lista de JSON a List<String>
      );
}