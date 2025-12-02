import 'package:chat_app/globla.dart';
import 'package:chat_app/Screens/login_screen.dart';
import 'package:chat_app/Services/auth_service.dart';
import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

/// Pantalla para configurar el perfil del usuario después del primer login
/// Permite ingresar nombre, estado y foto de perfil
/// Guarda la información en Firebase Firestore y Storage
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();      // Controlador para el campo de nombre
  final TextEditingController _statusController = TextEditingController();     // Controlador para el campo de estado
  final AuthService _authService = AuthService();                              // Servicio de autenticación
  File? _profileImage;                                                        // Archivo de imagen (para móvil)
  Uint8List? _profileImageBytes;                                               // Bytes de imagen (para web)
  bool _isLoading = false;                                                    // Indica si se está guardando el perfil
  final ImagePicker _imagePicker = ImagePicker();                             // Selector de imágenes

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  /// Permite al usuario seleccionar una imagen de su galería
  /// Maneja diferentes formatos para web (bytes) y móvil (File)
  Future<void> _pickImage() async {
    try {
      // Abrir selector de imágenes desde la galería
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,      // Redimensionar para optimizar
        maxHeight: 512,
        imageQuality: 85,   // Calidad de compresión
      );

      if (image != null) {
        if (kIsWeb) {
          // Para web, leer los bytes de la imagen (no se puede usar File)
          final bytes = await image.readAsBytes();
          setState(() {
            _profileImageBytes = bytes;
            _profileImage = null;
          });
        } else {
          // Para móvil, usar File
          setState(() {
            _profileImage = File(image.path);
            _profileImageBytes = null;
          });
        }
      }
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('Error al seleccionar imagen: $e'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  /// Sube la imagen de perfil a Firebase Storage
  /// Retorna la URL de descarga de la imagen subida
  Future<String?> _uploadProfileImage() async {
    if (_profileImage == null && _profileImageBytes == null) return null;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      // Crear referencia en Firebase Storage con el UID del usuario como nombre
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')      // Carpeta en Storage
          .child('${user.uid}.jpg');    // Nombre único basado en UID

      if (kIsWeb && _profileImageBytes != null) {
        // Para web, subir los bytes
        await storageRef.putData(
          _profileImageBytes!,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else if (_profileImage != null) {
        // Para móvil, subir el archivo
        await storageRef.putFile(_profileImage!);
      }

      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  /// Guarda el perfil del usuario en Firebase
  /// Actualiza el display name en Auth, sube la imagen a Storage
  /// y guarda todos los datos en Firestore
  Future<void> _saveProfile() async {
    // Validar que se haya ingresado un nombre
    if (_nameController.text.trim().isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: const Text('Por favor ingresa tu nombre'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;  // Mostrar indicador de carga
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Si no hay usuario autenticado, volver al login
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => const LoginScreen()),
        );
        return;
      }

      // Actualizar display name en Firebase Auth
      await user.updateDisplayName(_nameController.text.trim());

      // Subir imagen de perfil si existe
      String? profileImageUrl;
      if (_profileImage != null || _profileImageBytes != null) {
        profileImageUrl = await _uploadProfileImage();  // Obtener URL de la imagen subida
      }

      // Guardar datos del perfil en Firestore (base de datos)
      final userRef = FirebaseFirestore.instance
          .collection('users')      // Colección de usuarios
          .doc(user.uid);           // Documento con el UID del usuario

      await userRef.set({
        'phoneNumber': user.phoneNumber,
        'name': _nameController.text.trim(),
        'status': _statusController.text.trim().isEmpty
            ? 'Disponible'
            : _statusController.text.trim(),
        'profileImageUrl': profileImageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      // Navegar a la pantalla principal
      Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (context) => const MyHomePage(title: 'Chat App'),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('Error al guardar perfil: $e'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Logo
              _buildLogo(),
              
              const SizedBox(height: 20),
              
              // Texto "keynotecast chat"
              const Text(
                'keynotecast chat',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.black,
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Foto de perfil
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary!,
                      width: 3,
                    ),
                    color: CupertinoColors.white,
                  ),
                  child: (_profileImage != null || _profileImageBytes != null)
                      ? ClipOval(
                          child: kIsWeb && _profileImageBytes != null
                              ? Image.memory(
                                  _profileImageBytes!,
                                  fit: BoxFit.cover,
                                )
                              : _profileImage != null
                                  ? Image.file(
                                      _profileImage!,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      CupertinoIcons.camera_fill,
                                      size: 50,
                                      color: AppColors.primary,
                                    ),
                        )
                      : Icon(
                          CupertinoIcons.camera_fill,
                          size: 50,
                          color: AppColors.primary,
                        ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Campo de nombre
              CupertinoTextField(
                controller: _nameController,
                placeholder: 'Enter your name',
                placeholderStyle: TextStyle(color: Colors.grey.shade400),
                style: const TextStyle(color: CupertinoColors.black),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Campo de estado
              CupertinoTextField(
                controller: _statusController,
                placeholder: 'Enter your status',
                placeholderStyle: TextStyle(color: Colors.grey.shade400),
                style: const TextStyle(color: CupertinoColors.black),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              
              const Spacer(),
              
              // Botón Continue
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _isLoading ? null : _saveProfile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CupertinoActivityIndicator(
                            color: CupertinoColors.white,
                          )
                        : const Text(
                            'Continue',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Botón Logout
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _isLoading ? null : _logout,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Color(0xFFC10000),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SizedBox(
      width: 120,
      height: 90,
      child: Stack(
        children: [
          // Burbuja azul oscuro (detrás, a la izquierda)
          Positioned(
            left: 0,
            top: 5,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // Burbuja roja (delante, a la derecha) con llaves
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '{}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.white,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

