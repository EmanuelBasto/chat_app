import 'package:chat_app/globla.dart';
import 'package:chat_app/Screens/phone_login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Pantalla inicial de login
/// Muestra el logo de la app y un botón para iniciar sesión con teléfono
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              
              // Logo con dos burbujas de chat (azul y roja con llaves {})
              _buildLogo(),
              
              const SizedBox(height: 20),
              
              // Texto "keynotecast chat"
              const Text(
                'Dragon Fridman chat',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.black,
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Título "Sign in"
              const Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Mensaje de bienvenida
              const Text(
                'Welcome to Whatsapp Clone, please sign in!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.black,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Link "Don't have an account? Register"
              GestureDetector(
                onTap: () {
                  // TODO: Navegar a pantalla de registro
                },
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.black,
                    ),
                    children: [
                      TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: 'Register',
                        style: TextStyle(
                          color: Color(0xFFC10000),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Botón "Sign in with phone"
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const PhoneLoginScreen(),
                    ),
                  );
                },
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
                      'Sign in with phone',
                      style: TextStyle(
                        color: Color(0xFFC10000),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Texto legal
              const Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Text(
                  'inicia sesión para conectar con tus amigos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el logo de la app usando la imagen Logo.jpg
  Widget _buildLogo() {
    return Image.asset(
      'assets/images/Logo.jpg',
      width: 120,
      height: 90,
      fit: BoxFit.contain,
    );
  }
}

