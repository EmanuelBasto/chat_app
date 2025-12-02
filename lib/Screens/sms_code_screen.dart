import 'package:chat_app/globla.dart';
import 'package:chat_app/Services/auth_service.dart';
import 'package:chat_app/Screens/profile_setup_screen.dart';
import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Pantalla para ingresar el código SMS de verificación
/// Tiene 6 campos individuales para cada dígito del código
/// Verifica automáticamente cuando se completa el código
class SmsCodeScreen extends StatefulWidget {
  final String phoneNumber;      // Número de teléfono al que se envió el código
  final String verificationId;   // ID de verificación de Firebase Auth

  const SmsCodeScreen({
    Key? key,
    required this.phoneNumber,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<SmsCodeScreen> createState() => _SmsCodeScreenState();
}

class _SmsCodeScreenState extends State<SmsCodeScreen> {
  // 6 controladores de texto, uno para cada dígito del código
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  // 6 nodos de foco para navegar automáticamente entre campos
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final AuthService _authService = AuthService();  // Servicio de autenticación
  bool _isLoading = false;  // Indica si se está verificando el código

  @override
  void dispose() {
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  /// Se ejecuta cuando el usuario escribe un dígito
  /// Mueve automáticamente el foco al siguiente campo
  /// Verifica el código cuando todos los campos están llenos
  void _onCodeChanged(int index, String value) {
    // Si hay un valor y no es el último campo, mover foco al siguiente
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    // Verificar si todos los campos están llenos para verificar automáticamente
    bool allFilled = _codeControllers.every((controller) => controller.text.isNotEmpty);
    if (allFilled) {
      _verifyCode();  // Verificar código automáticamente
    }
  }

  /// Verifica el código SMS ingresado con Firebase Auth
  /// Si es correcto, verifica si el usuario tiene perfil configurado
  /// Navega a la pantalla principal o a configuración de perfil según corresponda
  Future<void> _verifyCode() async {
    // Unir todos los dígitos en un solo código
    final code = _codeControllers.map((controller) => controller.text).join();
    if (code.length != 6) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Verificar código SMS
      final userCredential = await _authService.verifySmsCode(
        widget.verificationId,
        code,
      );

      if (!mounted) return;

      if (userCredential?.user != null) {
        if (!mounted) return;
        
        // Esperar un momento para que Firestore se actualice
        await Future.delayed(const Duration(milliseconds: 800));
        
        try {
          // Verificar si el usuario ya tiene nombre configurado
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential!.user!.uid)
              .get();

          if (!mounted) return;

          final userData = userDoc.data();
          final hasName = userData != null && 
                         userData['name'] != null && 
                         userData['name'] is String &&
                         (userData['name'] as String).trim().isNotEmpty;

          if (!mounted) return;

          if (hasName) {
            // Usuario ya tiene perfil, ir directo a chats
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => const MyHomePage(title: 'Chat App'),
              ),
              (route) => false,
            );
          } else {
            // Usuario nuevo, mostrar pantalla de configuración de perfil
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => const ProfileSetupScreen(),
              ),
              (route) => false,
            );
          }
        } catch (e) {
          // En caso de error, siempre mostrar pantalla de configuración
          if (!mounted) return;
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => const ProfileSetupScreen(),
            ),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });

      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('Código inválido: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              
              // Título
              const Text(
                'Enter SMS code',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Campos de código SMS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 45,
                    child: CupertinoTextField(
                      controller: _codeControllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.primary!,
                            width: 2,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.black,
                      ),
                      onChanged: (value) => _onCodeChanged(index, value),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Botón "Verify"
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _isLoading ? null : _verifyCode,
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
                            'Verify',
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
              
              // Link "Go back"
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Go back',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

