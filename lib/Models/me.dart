/// Modelo de datos para representar el perfil del usuario actual
/// Contiene toda la información personal del usuario logueado
class MeModel{
  final String firstName;      // Nombre del usuario
  final String lastName;        // Apellido del usuario
  final String avatar;          // URL o ruta de la foto de perfil
  final String city;            // Ciudad donde vive el usuario
  final String relationship;    // Estado civil/relación
  final String gender;          // Género del usuario
  final String job_title;       // Título del trabajo
  final String job_area;        // Área de trabajo
  final bool story;             // Indica si el usuario tiene historias publicadas
  final String status;           // Estado actual (ej: "Disponible", "Ocupado")
  final List<String> stories;   // Lista de URLs/rutas de las historias del usuario
  
  // Constructor principal
  MeModel({
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.city,
    required this.relationship,
    required this.gender,
    required this.job_title,
    required this.job_area,
    required this.story,
    required this.status,
    required this.stories,
  });  

  // Constructor desde JSON (para convertir datos de Firestore a objeto)
  // Nota: Los campos en Firestore usan snake_case (first_name) pero aquí usamos camelCase
  factory MeModel.fromJson(Map<String, dynamic> data) => MeModel(
      avatar: data['avatar'],
      firstName: data['first_name'],      // Mapea 'first_name' del JSON a firstName
      lastName: data['last_name'],        // Mapea 'last_name' del JSON a lastName
      city: data['city'],
      relationship: data['relationship'],
      gender: data['gender'],
      job_title: data['job_title'],
      job_area: data['job_area'],
      story: data['story'],
      status: data['status'],
      stories: List.from(data['stories']),  // Convertir lista de JSON a List<String>
    );
}