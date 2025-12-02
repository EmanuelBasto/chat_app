import 'package:chat_app/globla.dart';
import 'package:chat_app/Services/auth_service.dart';
import 'package:chat_app/Screens/profile_setup_screen.dart';
import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SmsCodeScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const SmsCodeScreen({
    Key? key,
    required this.phoneNumber,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<SmsCodeScreen> createState() => _SmsCodeScreenState();
}

class _SmsCodeScreenState extends State<SmsCodeScreen> {
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final AuthService _authService = AuthService();
  bool _isLoading = false;

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

  void _onCodeChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }

    // Verificar si todos los campos están llenos
    bool allFilled = _codeControllers.every((controller) => controller.text.isNotEmpty);
    if (allFilled) {
      _verifyCode();
    }
  }

  Future<void> _verifyCode() async {
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

