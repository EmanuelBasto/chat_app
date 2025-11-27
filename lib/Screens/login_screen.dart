import 'package:chat_app/globla.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              
              // Logo con dos burbujas de chat
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
                  // TODO: Implementar inicio de sesión con teléfono
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
                  'By signing in, you agree to our terms and conditions.',
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

