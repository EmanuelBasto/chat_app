import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

/// Utilidad para comprimir imágenes antes de subirlas a servidores
/// Reduce el tamaño de archivo manteniendo una calidad aceptable
/// Útil para optimizar el almacenamiento y la velocidad de carga
class ImageCompressor {
  /// Comprime una imagen hasta que pese menos del tamaño máximo especificado (por defecto 500KB)
  /// 
  /// **Parámetros:**
  /// - [file] - Archivo de imagen File (para plataformas móviles: Android/iOS)
  /// - [xFile] - XFile de image_picker (para plataforma web)
  /// - [maxSizeKB] - Tamaño máximo deseado en kilobytes (por defecto 500KB)
  /// 
  /// **Retorna:** Los bytes comprimidos de la imagen como Uint8List
  /// 
  /// **Nota:** La función detecta automáticamente si está en web o móvil
  /// y usa el método de compresión apropiado para cada plataforma
  static Future<Uint8List> compressImage({
    File? file,
    XFile? xFile,
    int maxSizeKB = 500,
  }) async {
    try {
      Uint8List? imageBytes;
      
      // OBTENER LOS BYTES DE LA IMAGEN SEGÚN LA PLATAFORMA
      // En web, Flutter usa XFile en lugar de File
      if (kIsWeb && xFile != null) {
        // Leer bytes desde XFile (plataforma web)
        imageBytes = await xFile.readAsBytes();
      } else if (file != null) {
        // Leer bytes desde File (plataformas móviles)
        imageBytes = await file.readAsBytes();
      } else {
        // Si no se proporciona ningún archivo, lanzar excepción
        throw Exception('Debes proporcionar un archivo o XFile');
      }

      // VERIFICAR SI LA IMAGEN YA ES SUFICIENTEMENTE PEQUEÑA
      // Si ya pesa menos del máximo, no es necesario comprimirla
      final sizeInKB = imageBytes.length / 1024; // Convertir bytes a kilobytes
      if (sizeInKB <= maxSizeKB) {
        print('Imagen ya es pequeña: ${sizeInKB.toStringAsFixed(2)}KB');
        return imageBytes; // Retornar sin comprimir
      }

      print('Comprimiendo imagen de ${sizeInKB.toStringAsFixed(2)}KB...');

      // REDIRIGIR A LA FUNCIÓN DE COMPRESIÓN APROPIADA SEGÚN LA PLATAFORMA
      // Web y móvil tienen diferentes APIs y capacidades
      if (kIsWeb) {
        // Para web, usar compresión con lista de bytes
        return _compressForWeb(imageBytes, maxSizeKB);
      }

      // Para móvil, usar compresión con archivo (más eficiente)
      return _compressForMobile(file!, imageBytes, maxSizeKB);
    } catch (e) {
      print('Error al comprimir imagen: $e');
      // MANEJO DE ERRORES: Intentar retornar los bytes originales como fallback
      // Esto asegura que la app no falle completamente si la compresión falla
      if (kIsWeb && xFile != null) {
        return await xFile.readAsBytes();
      } else if (file != null) {
        return await file.readAsBytes();
      }
      // Si no hay archivo disponible, relanzar la excepción
      rethrow;
    }
  }

  /// Compresión específica para plataforma web
  /// Usa flutter_image_compress que internamente utiliza canvas HTML5 para la compresión
  /// 
  /// **Estrategia:** Prueba diferentes niveles de calidad empezando desde 70% y reduciendo
  /// hasta encontrar un tamaño aceptable o alcanzar el mínimo de calidad (30%)
  static Future<Uint8List> _compressForWeb(Uint8List imageBytes, int maxSizeKB) async {
    try {
      // CONFIGURACIÓN INICIAL DE CALIDAD
      // Empezar con calidad media-alta y reducir gradualmente si es necesario
      int quality = 70;        // Calidad inicial (70% = buena calidad)
      int minQuality = 30;     // Calidad mínima aceptable (30% = calidad baja pero usable)
      int step = 10;           // Reducción de calidad en cada intento (10%)
      
      // BUCLE DE COMPRESIÓN CON PRUEBA Y ERROR
      // Intenta comprimir con diferentes niveles de calidad hasta encontrar uno adecuado
      while (quality >= minQuality) {
        try {
          // Comprimir usando la lista de bytes directamente (método para web)
          final compressed = await FlutterImageCompress.compressWithList(
            imageBytes,
            minHeight: 1024,   // Reducir altura máxima a 1024px si es más grande
            minWidth: 1024,    // Reducir ancho máximo a 1024px si es más grande
            quality: quality,  // Calidad JPEG actual (0-100)
            format: CompressFormat.jpeg, // Formato de salida: JPEG
          );
          
          // Verificar si el tamaño comprimido es aceptable
          final sizeKB = compressed.length / 1024;
          if (sizeKB <= maxSizeKB) {
            // ✅ Éxito: La imagen está dentro del tamaño máximo
            print('✅ Imagen comprimida para web: ${sizeKB.toStringAsFixed(2)}KB (calidad: $quality%)');
            return compressed;
          }
          // Si aún es muy grande, reducir calidad y volver a intentar
          quality -= step;
        } catch (e) {
          // Si hay error con esta calidad, intentar con calidad más baja
          print('Error al comprimir con calidad $quality: $e');
          quality -= step;
        }
      }
      
      // FALLBACK: Si no se pudo comprimir suficientemente después de todos los intentos
      // Retornar la imagen original con un warning
      // Esto evita que la app falle, aunque la imagen pueda ser grande
      print('⚠️ No se pudo comprimir suficientemente, usando imagen original');
      return imageBytes;
    } catch (e) {
      // Manejo de errores generales: retornar imagen original
      print('Error en compresión web: $e');
      return imageBytes;
    }
  }

  /// Compresión específica para plataformas móviles (Android/iOS)
  /// Usa flutter_image_compress que aprovecha las capacidades nativas del dispositivo
  /// Más eficiente que la compresión web porque trabaja directamente con archivos
  /// 
  /// **Estrategia mejorada:** 
  /// - Empieza con calidad alta (85%)
  /// - Si el archivo es mucho más grande que el máximo, reduce calidad más agresivamente
  /// - Si está cerca del máximo, reduce calidad gradualmente
  static Future<Uint8List> _compressForMobile(File file, Uint8List imageBytes, int maxSizeKB) async {
    // CONFIGURACIÓN INICIAL CON CALIDAD MÁS ALTA QUE WEB
    // Los dispositivos móviles pueden manejar mejor la compresión nativa
    int quality = 85;        // Calidad inicial alta (85% = muy buena calidad)
    int minQuality = 30;     // Calidad mínima aceptable
    int step = 10;           // Paso de reducción estándar
    
    Uint8List? compressedBytes; // Variable para almacenar el último resultado exitoso
    
    // BUCLE DE COMPRESIÓN CON ESTRATEGIA ADAPTATIVA
    while (quality >= minQuality) {
      try {
        // Comprimir usando la ruta del archivo (más eficiente en móvil)
        final result = await FlutterImageCompress.compressWithFile(
          file.absolute.path,  // Ruta absoluta del archivo
          minHeight: 1024,      // Redimensionar si la altura es mayor a 1024px
          minWidth: 1024,       // Redimensionar si el ancho es mayor a 1024px
          quality: quality,     // Calidad JPEG actual
          format: CompressFormat.jpeg, // Formato de salida: JPEG
        );
        
        if (result != null) {
          compressedBytes = result; // Guardar resultado exitoso
          final sizeKB = compressedBytes.length / 1024;
          
          // VERIFICAR SI EL TAMAÑO ES ACEPTABLE
          if (sizeKB <= maxSizeKB) {
            // ✅ Éxito: La imagen está dentro del tamaño máximo
            print('✅ Imagen comprimida para móvil: ${sizeKB.toStringAsFixed(2)}KB (calidad: $quality%)');
            return compressedBytes;
          }
          
          // ESTRATEGIA ADAPTATIVA DE REDUCCIÓN DE CALIDAD
          // Si el archivo es mucho más grande (1.5x el máximo), reducir calidad más rápido
          // Esto acelera el proceso cuando la imagen es muy grande
          if (sizeKB > maxSizeKB * 1.5) {
            quality -= step * 2; // Reducir calidad en 20% (paso doble)
          } else {
            quality -= step; // Reducir calidad en 10% (paso normal)
          }
        } else {
          // Si la compresión retorna null, reducir calidad y continuar
          quality -= step;
        }
      } catch (e) {
        // Si hay error, intentar con calidad más baja
        print('Error al comprimir con calidad $quality: $e');
        quality -= step;
      }
    }
    
    // FALLBACK: Si se alcanzó la calidad mínima pero aún hay bytes comprimidos
    // Retornar la mejor compresión lograda (aunque pueda ser mayor al máximo)
    if (compressedBytes != null) {
      final finalSizeKB = compressedBytes.length / 1024;
      print('⚠️ Imagen comprimida (tamaño final): ${finalSizeKB.toStringAsFixed(2)}KB');
      return compressedBytes;
    }
    
    // ÚLTIMO RECURSO: Si no se pudo comprimir en absoluto, usar imagen original
    print('⚠️ No se pudo comprimir, usando original');
    return imageBytes;
  }
}

