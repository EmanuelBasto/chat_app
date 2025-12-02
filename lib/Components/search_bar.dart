import 'package:flutter/cupertino.dart';

/// Componente de barra de búsqueda reutilizable
/// Utiliza el estilo Cupertino (iOS) para mantener consistencia visual
class SearchBar extends StatelessWidget {
  /// Callback que se ejecuta cuando el texto cambia mientras el usuario escribe
  /// Recibe el texto actual del campo de búsqueda
  final Function(String)? onChanged;
  
  /// Callback que se ejecuta cuando el usuario presiona Enter o confirma la búsqueda
  /// Recibe el texto final del campo de búsqueda
  final Function(String)? onSubmitted;

  const SearchBar({Key? key, this.onChanged, this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding horizontal de 15px y vertical de 5px para espaciado adecuado
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      // Campo de búsqueda con estilo iOS (Cupertino)
      child: CupertinoSearchTextField(
        // Se ejecuta cada vez que el usuario escribe o borra texto
        onChanged: onChanged,
        // Se ejecuta cuando el usuario confirma la búsqueda (Enter)
        onSubmitted: onSubmitted,
      ),
    );
  }
}


