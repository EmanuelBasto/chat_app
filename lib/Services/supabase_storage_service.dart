import 'dart:io';
import 'dart:typed_data';
import 'package:chat_app/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  static SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      print('Error al obtener cliente de Supabase: $e');
      return null;
    }
  }

  /// Sube una foto al bucket de Supabase y retorna la URL pública
  /// La imagen se comprime automáticamente si pesa más de 1MB
  /// 
  /// [file] - Archivo de imagen (para móvil)
  /// [bytes] - Bytes de la imagen (para web) - ya comprimidos
  /// [fileName] - Nombre del archivo (se generará automáticamente si no se proporciona)
  /// 
  /// Retorna la URL pública de la imagen subida
  static Future<String> uploadPhoto({
    File? file,
    Uint8List? bytes,
    String? fileName,
  }) async {
    try {
      // Validar que Supabase esté inicializado
      final client = _client;
      if (client == null) {
        throw Exception('Supabase no está inicializado. Verifica tu anon key en lib/config/supabase_config.dart');
      }

      // Validar que se proporcione al menos uno
      if (file == null && bytes == null) {
        throw Exception('Debes proporcionar un archivo o bytes de imagen');
      }

      // Verificar que la anon key esté configurada
      if (SupabaseConfig.supabaseAnonKey == 'TU_ANON_KEY_AQUI') {
        throw Exception('⚠️ ERROR: No has configurado tu anon key de Supabase.\n\nPor favor:\n1. Ve a tu proyecto en Supabase Dashboard\n2. Settings > API\n3. Copia la "anon public" key\n4. Pégala en lib/config/supabase_config.dart reemplazando "TU_ANON_KEY_AQUI"');
      }

      // Generar nombre único para el archivo
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueFileName = fileName ?? 'photo_$timestamp.jpg';
      final filePath = 'chats/$uniqueFileName';

      // Obtener bytes si es necesario
      Uint8List imageBytes;
      if (bytes != null) {
        imageBytes = bytes;
      } else if (file != null) {
        imageBytes = await file.readAsBytes();
      } else {
        throw Exception('No se proporcionaron bytes ni archivo');
      }

      // Subir la imagen usando uploadBinary (funciona tanto en web como móvil)
      await client.storage
          .from(SupabaseConfig.photosBucket)
          .uploadBinary(
            filePath,
            imageBytes,
            fileOptions: FileOptions(
              contentType: 'image/jpeg',
              upsert: true, // Permitir sobrescribir si existe
            ),
          );

      // Obtener URL pública
      final publicUrl = client.storage
          .from(SupabaseConfig.photosBucket)
          .getPublicUrl(filePath);

      print('✅ Foto subida exitosamente: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('❌ Error al subir foto a Supabase: $e');
      
      // Mensaje de error más descriptivo
      String errorMessage = 'Error al subir foto: $e';
      if (e.toString().contains('Unauthorized') || 
          e.toString().contains('403') || 
          e.toString().contains('row-level security policy') ||
          e.toString().contains('RLS')) {
        errorMessage = 'Error: Políticas de seguridad de Supabase.\n\n'
            'El bucket "Fotos" necesita políticas configuradas.\n\n'
            'Pasos para solucionarlo:\n'
            '1. Ve a Supabase Dashboard > Storage\n'
            '2. Haz clic en el bucket "Fotos"\n'
            '3. Ve a la pestaña "Policies"\n'
            '4. Crea una nueva política:\n'
            '   - Nombre: "Allow public uploads"\n'
            '   - Operación: INSERT\n'
            '   - Roles: anon\n'
            '   - Definición: true\n'
            '5. Guarda la política\n'
            '6. Reinicia la aplicación';
      } else if (e.toString().contains('Invalid Compact JWS')) {
        errorMessage = 'Error: Anon key inválida.\n\n'
            'Por favor verifica que tu anon key en lib/config/supabase_config.dart sea correcta.\n'
            'Puedes encontrarla en: Supabase Dashboard > Settings > API > anon/public key';
      }
      
      throw Exception(errorMessage);
    }
  }

  /// Elimina una foto del bucket de Supabase
  static Future<void> deletePhoto(String filePath) async {
    try {
      final client = _client;
      if (client == null) {
        throw Exception('Supabase no está inicializado');
      }
      
      await client.storage
          .from(SupabaseConfig.photosBucket)
          .remove([filePath]);
    } catch (e) {
      print('Error al eliminar foto de Supabase: $e');
      rethrow;
    }
  }
}

