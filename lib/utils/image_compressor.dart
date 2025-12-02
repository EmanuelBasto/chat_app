import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class ImageCompressor {
  /// Comprime una imagen hasta que pese menos de 500KB
  /// 
  /// [file] - Archivo de imagen (para móvil)
  /// [xFile] - XFile de image_picker (para web)
  /// 
  /// Retorna los bytes comprimidos de la imagen
  static Future<Uint8List> compressImage({
    File? file,
    XFile? xFile,
    int maxSizeKB = 500,
  }) async {
    try {
      Uint8List? imageBytes;
      
      // Obtener bytes de la imagen
      if (kIsWeb && xFile != null) {
        imageBytes = await xFile.readAsBytes();
      } else if (file != null) {
        imageBytes = await file.readAsBytes();
      } else {
        throw Exception('Debes proporcionar un archivo o XFile');
      }

      // Si la imagen ya pesa menos de 500KB, retornarla sin comprimir
      final sizeInKB = imageBytes.length / 1024;
      if (sizeInKB <= maxSizeKB) {
        print('Imagen ya es pequeña: ${sizeInKB.toStringAsFixed(2)}KB');
        return imageBytes;
      }

      print('Comprimiendo imagen de ${sizeInKB.toStringAsFixed(2)}KB...');

      // Para web, usar una compresión simple reduciendo calidad
      if (kIsWeb) {
        return _compressForWeb(imageBytes, maxSizeKB);
      }

      // Para móvil, usar flutter_image_compress
      return _compressForMobile(file!, imageBytes, maxSizeKB);
    } catch (e) {
      print('Error al comprimir imagen: $e');
      // En caso de error, intentar retornar los bytes originales
      if (kIsWeb && xFile != null) {
        return await xFile.readAsBytes();
      } else if (file != null) {
        return await file.readAsBytes();
      }
      rethrow;
    }
  }

  /// Compresión para web usando canvas HTML5
  static Future<Uint8List> _compressForWeb(Uint8List imageBytes, int maxSizeKB) async {
    try {
      // Intentar comprimir usando flutter_image_compress para web
      int quality = 70;
      int minQuality = 30;
      int step = 10;
      
      while (quality >= minQuality) {
        try {
          final compressed = await FlutterImageCompress.compressWithList(
            imageBytes,
            minHeight: 1024,
            minWidth: 1024,
            quality: quality,
            format: CompressFormat.jpeg,
          );
          
          final sizeKB = compressed.length / 1024;
          if (sizeKB <= maxSizeKB) {
            print('✅ Imagen comprimida para web: ${sizeKB.toStringAsFixed(2)}KB (calidad: $quality%)');
            return compressed;
          }
          quality -= step;
        } catch (e) {
          print('Error al comprimir con calidad $quality: $e');
          quality -= step;
        }
      }
      
      // Si no se pudo comprimir, retornar original pero con un warning
      print('⚠️ No se pudo comprimir suficientemente, usando imagen original');
      return imageBytes;
    } catch (e) {
      print('Error en compresión web: $e');
      return imageBytes;
    }
  }

  /// Compresión para móvil usando flutter_image_compress
  static Future<Uint8List> _compressForMobile(File file, Uint8List imageBytes, int maxSizeKB) async {
    int quality = 85;
    int minQuality = 30;
    int step = 10;
    
    Uint8List? compressedBytes;
    
    while (quality >= minQuality) {
      try {
        final result = await FlutterImageCompress.compressWithFile(
          file.absolute.path,
          minHeight: 1024,
          minWidth: 1024,
          quality: quality,
          format: CompressFormat.jpeg,
        );
        
        if (result != null) {
          compressedBytes = result;
          final sizeKB = compressedBytes.length / 1024;
          
          if (sizeKB <= maxSizeKB) {
            print('✅ Imagen comprimida para móvil: ${sizeKB.toStringAsFixed(2)}KB (calidad: $quality%)');
            return compressedBytes;
          }
          
          if (sizeKB > maxSizeKB * 1.5) {
            quality -= step * 2;
          } else {
            quality -= step;
          }
        } else {
          quality -= step;
        }
      } catch (e) {
        print('Error al comprimir con calidad $quality: $e');
        quality -= step;
      }
    }
    
    if (compressedBytes != null) {
      final finalSizeKB = compressedBytes.length / 1024;
      print('⚠️ Imagen comprimida (tamaño final): ${finalSizeKB.toStringAsFixed(2)}KB');
      return compressedBytes;
    }
    
    print('⚠️ No se pudo comprimir, usando original');
    return imageBytes;
  }
}

